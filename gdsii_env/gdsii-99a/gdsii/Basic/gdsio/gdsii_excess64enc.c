/*
 * A mex function to convert an 8-byte real number into 
 * excess-64 representation. The converted number is 
 * returned as a string of 8 characters (bytes).
 *
 * bytestr = gdsii_excess64enc(anumber);
 *
 * Ulf Griesmann, NIST, January 2008
 */

#include <math.h>
#include "mex.h"

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
   double anum;                         /* double precision number */
   double mantissa;                     /* its mantissa */
   int exponent;                        /* and its exponent */
   int k;
   unsigned char *snum;
   unsigned char help;

   /*
    * retrieve the argument
    */
   anum = mxGetScalar(prhs[0]);

   /*
    * find exponent and mantissa
    */
   exponent = find_float_parts(anum, &mantissa);

   /*
    * return the result in an array of small unsigned integers
    */
   plhs[0] = mxCreateNumericMatrix(1, 8, mxUINT8_CLASS, 0);
   snum = mxGetData(plhs[0]); /* pointer to the data array */

   /*
    * convert to excess-64 representation
    */
   exponent += 64;  
   if (mantissa < 0.0) {
      exponent |= 0x80;   /* set the sign bit */
      mantissa *= -1;     /* and make mantissa positive */
   }
   snum[0] = exponent;

   for (k=1; k<8; k++) {
      mantissa *= 256;    /* shift 8 bits to the right */
      help = (unsigned char)mantissa;
      snum[k] = help;
      mantissa -= help;
   }

   return;
}

/*--------------------------------------------*/

/*
 * find mantissa and exponent of a real number
 * in a normalized base 16 representation: M * 16 ^ E
 *
 * Ulf Griesmann, NIST, January 2008
 */
int 
find_float_parts(double anum, double *M) {
  
   int E;
   int ex;
   int sgn;
   double mn;
   double ex16;

   /*
    * handle special case of 0 input
    */
   if (anum == 0.0) {
      *M = 0.0;
      return 0;
   }

   /*
    * separate out the sign;
    */
   if (anum < 0.0) {
      sgn = -1;
      anum *= -1;
   }
   else {
      sgn = 1;
   }

   /*
    * find a base 16 representation of the number
    */
   mn = frexp(anum, &ex);          /* anum = mn * 2^ex, normalized */
   ex16 = 0.25 * ex;               /* scale to base 16 */
   E = ceil(ex16);                 /* integer fraction is exponent */
   *M = mn * pow(16.0, ex16 - E);  /* base 16 mantissa */

   /*
    * normalize the representation such that
    * 1/16 <= M < 1
    */
   while (*M >= 1) {
      *M *= 0.0625;
      E++;
   }
   while (*M < 0.0625) {
      *M *= 16.0;
      E--;
   }

   *M *= sgn;

   return E;
}
