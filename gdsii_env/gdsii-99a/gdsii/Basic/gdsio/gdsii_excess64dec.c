/*
 * A mex function to convert an 8-byte real number in
 * excess-64 representation into an IEEE double 
 * precision floating point number.
 *
 * num = gdsii_excess64dec(bytestring);
 *
 * Uses code from GDSreader 0.3.2 by
 * Serban-Mihai Popescu.
 * 
 * COPYRIGHT: GNU GPL version 2
 * 
 * Ulf Griesmann, NIST, November 2011
 */

#include <math.h>
#include "mex.h"

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
  int k, sign, exponent;
  double mantissa, value;
  unsigned char *bytes;    /* byte string */
  double *pr;


  /*
   * get pointer to byte string
   */
  bytes = mxGetData(prhs[0]);

  /*
   * convert to IEEE-754 double
   */
  sign = bytes[0] & 0x80;
  exponent = (bytes[0] & 0x7f) - 64;
  mantissa = 0;
  for(k=1; k<8; k++) {
     mantissa *= 256;
     mantissa += bytes[k];
  }
  mantissa /= 72057594037927936.0;  /* divide by 2^56 */

  value = mantissa * pow(16, (float)exponent);
  if(sign)
     value = -value;

  /*
   * return the result
   */
  plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
  pr = mxGetData(plhs[0]);
  *pr = value;

  return;
}
