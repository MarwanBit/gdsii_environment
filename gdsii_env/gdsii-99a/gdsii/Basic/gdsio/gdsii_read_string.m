function [str] = gdsii_read_string(gf, nchar);
%
% internal - reads a string of nchar characters from file with handle gf
%

str = deblank( fread(gf, nchar, '*char')' );

return
