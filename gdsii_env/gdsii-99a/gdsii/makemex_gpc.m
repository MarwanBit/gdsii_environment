%
% script to make .mex files using the 
% General Polygon Clipper library
%

% low level functions
fprintf('\n\n>>>>>\n');
fprintf('>>>>>  Compiling low-level mex functions ...\n');
fprintf('>>>>>\n');

cd Basic/gdsio
mex -O gdsii_excess64enc.c
mex -O gdsii_excess64dec.c

cd ../@gds_element/private
mex -O poly_iscwmex.c

cd ../../../Structures/private
mex -O datamatrixmex.c

% Boolean functions
fprintf('\n\n>>>>>\n');
fprintf('>>>>>  Compiling Boolean set algebra functions (GPC) ...\n');
fprintf('>>>>>\n\n');

% for GPC library
cd ../../Boolean/gpc
mex -O poly_boolmex.c gpc.c

% back up
cd ../..

