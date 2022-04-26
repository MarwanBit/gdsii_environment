function [dnum] = gdsii_readreal8(gf);
%
% internal use - read an 8 byte real number in 
% excess-64 representation and return as IEEE-754 
% double
%
% Ulf Griesmann, NIST, November 2011
%

dnum = gdsii_excess64dec( fread(gf, 8, '*uint8') );

return
