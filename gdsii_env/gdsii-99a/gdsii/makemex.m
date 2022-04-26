%
% script to make .mex files
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
fprintf('>>>>>  Compiling Boolean set algebra functions (Clipper) ...\n');
fprintf('>>>>>\n\n');

% for Clipper library
cd ../../Boolean/clipper
mex -O poly_boolmex.cpp clipper.cpp

% back up
cd ../..

