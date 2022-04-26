/*
 * A mex interface to the Generic Polygon Clipper library
 * for the GDS II toolbox
 * 
 * [pc, hf] =  = poly_boolmex(pa, pb, op, ud);
 *
 * pa :  cell array of polygons (nx2 matrices)
 * pb :  cell array of polygons (nx2 matrices)
 * op :  polygon operation
 * ud :  conversion factor for conversion from user
 *       coordinates to database coordinates
 * pc :  a cell array containing one or more polygons
 * hf :  hole flagarray; when hf(k) > 0, pc{k} is the
 *       interior boundary of a hole.
 *
 * polygon operations are:
 *   'and' :  polygon intersection
 *   'or' :   polygon union
 *   'notb' : polygon difference
 *   'xor' :  polygon union minus polygon difference
 *
 * Ulf Griesmann, NIST, November 2012
 */

#include <math.h>
#include <string.h>
#include "mex.h"
#include "gpc.h"

#define STR_LEN    8

/*-- local prototypes -----------------------------------------*/

static gpc_vertex_list *
transpose_scale_pol(double *poli, int m, double sf);


/*-------------------------------------------------------------*/

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
   mxArray *par;               /* pointer to array structure */
   double *pda;                /* polynom data */
   double *pud;                /* pointer to unit factor */
   mxLogical *ph;              /* pointer to hole flags */
   gpc_polygon pa, pb, pc;     /* polygon structures */ 
   gpc_op pop;                 /* polygon operation */
   int ma;
   int k, m, Na, Nb;
   double ud, iud;             /* conversion to database units and back */
   char ostr[STR_LEN];         /* string with polygon operation */

   /*
    * check arguments
    */

   /* check argument number */
   if (nrhs < 4) {
      mexErrMsgTxt("polyboolmex :  expected 4 input arguments.");
   }
   
   /* check argument pa */
   if ( !mxIsCell(prhs[0]) ) {
      mexErrMsgTxt("polyboolmex :  first argument must be a cell array.");
   }
   Na = mxGetM(prhs[0])*mxGetN(prhs[0]);
   if (!Na) {
      mexErrMsgTxt("polyboolmex :  no input polygons pa.");
   }
   
   /* check argument pb */
   if ( !mxIsCell(prhs[1]) ) {
      mexErrMsgTxt("polyboolmex :  second argument must be a cell array.");
   }
   Nb = mxGetM(prhs[1])*mxGetN(prhs[1]);
   if (!Nb) {
      mexErrMsgTxt("polyboolmex :  no input polygons pb.");
   }

   /* get operation argument */
   mxGetString(prhs[2], ostr, STR_LEN);
   if ( !strncmp(ostr, "or", 2) )
      pop = GPC_UNION; 
   else if ( !strncmp(ostr, "and", 3) )
      pop = GPC_INT; 
   else if ( !strncmp(ostr, "notb", 4) )
      pop = GPC_DIFF; 
   else if ( !strncmp(ostr, "xor", 3) )
      pop = GPC_XOR; 
   else {
      mexErrMsgTxt("polyboolmex :  unknown boolean set algebra operation.");
   }

   /* conversion factor argument */
   pud = mxGetData(prhs[3]);  
   ud = *pud;
   iud = 1.0/ud;

   /* initialize polygon structures */   
   pa.num_contours = 0; pa.hole = NULL; pa.contour = NULL;
   pb.num_contours = 0; pb.hole = NULL; pb.contour = NULL;
   pc.num_contours = 0; pc.hole = NULL; pc.contour = NULL;

   /*
    * copy and prepare data
    */

   /* pa */
   for (k=0; k<Na; k++) {

      /* get the next polygon from the cell array */ 
      par = mxGetCell(prhs[0], k); /* ptr to mxArray */
      if ( mxIsEmpty(par) ) {
	 mexErrMsgTxt("poly_boolmex :  empty polygon in pa.");
      }
      pda = mxGetData(par);        /* ptr to a data */     
      ma  = mxGetM(par);           /* rows = vertex number */

      gpc_add_contour(&pa, transpose_scale_pol(pda, ma, ud), 0);
   }

   /* pb */
   for (k=0; k<Nb; k++) {

      /* get the next polygon from the cell array */ 
      par = mxGetCell(prhs[1], k); /* ptr to mxArray */
      if ( mxIsEmpty(par) ) {
	 mexErrMsgTxt("poly_boolmex :  empty polygon in pb.");
      }
      pda = mxGetData(par);        /* ptr to a data */     
      ma  = mxGetM(par);           /* rows = vertex number */

      gpc_add_contour(&pb, transpose_scale_pol(pda, ma, ud), 0);
   }

   /*
    * clip the polygon(s)
    */
   gpc_polygon_clip(pop, &pa, &pb, &pc);
      
   /*
    * create a cell array for output argument
    */
   plhs[0] = mxCreateCellMatrix(1, pc.num_contours);

   /*
    * and fill it
    */
   for (k=0; k<pc.num_contours; k++) {
      
      /*
       * allocate matrix for boundary
       */
      par = mxCreateDoubleMatrix(pc.contour[k].num_vertices, 2, mxREAL);
      pda = mxGetData(par);
    
      /*
       * copy vertex array, transpose, and scale back to user units
       */
      for (m=0; m<pc.contour[k].num_vertices; m++) {
         pda[m] = iud * pc.contour[k].vertex[m].x;
         pda[pc.contour[k].num_vertices + m]
                = iud * pc.contour[k].vertex[m].y;
      }

      /*
       * store in cell array
       */
      mxSetCell(plhs[0], k, par);

   }

   /*
    * return the hole flags
    */
   plhs[1] = mxCreateLogicalMatrix(1, pc.num_contours);
   ph = (mxLogical *)mxGetData(plhs[1]);
   for (k=0; k<pc.num_contours; k++)
       ph[k] = (mxLogical)pc.hole[k];
}


/*-----------------------------------------------------------------*/

/*
 * Arrays in MATLAB/Octave are stored in column-major order. Nx2 polygons
 * are, therefore, stored (x1,x2,...,xN,y1,y2,...,yN). GPC expects polygon
 * vertices stored at consecutive memory locations: (x1,y1,x2,y2,....,xN,yN). 
 * This is equivalent to transposing the array with polygon vertices.
 * The transposed array is returned in a vertex list structure.
 */
static gpc_vertex_list *
transpose_scale_pol(double *poli, int m, double sf) {

   int i,k;
   gpc_vertex_list *vlp;
   double *polo;

   /* allocate memory for transposed array */
   polo = mxMalloc(2 * m * sizeof(double));
   for (k=i=0; k<m; k++,i+=2) {
      polo[i]   = floor(sf * poli[k]     + 0.5);
      polo[i+1] = floor(sf * poli[k + m] + 0.5); 
   }

   /* allocate memory for vertex list structure */
   vlp = (gpc_vertex_list *)mxMalloc(sizeof(gpc_vertex_list));
   vlp->num_vertices = m;
   vlp->vertex = (gpc_vertex *)polo;

   return vlp;
}
