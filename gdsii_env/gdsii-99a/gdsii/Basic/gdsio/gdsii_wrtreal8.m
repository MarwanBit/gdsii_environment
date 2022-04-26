function gdsii_wrtreal8(gf, dnum);
%
% internal use - write an 8 byte real number in 
% excess-64 representation
%
% Ulf Griesmann, NIST, January 2008
%

fwrite(gf, gdsii_excess64enc(dnum));

return
