function gdsii_endstruct(gf);
%function gdsii_endstruct(gf);
%
% gdsii_endstruct :  end structure inside a GDS II library that was
%                    started with gdsii_struct
%
% gf    : file handle returned by gdsii_initialize
%

% Ulf Griesmann, January 2008
%

% write ENDSTR
fwrite(gf, [4, 1792], 'int16');
