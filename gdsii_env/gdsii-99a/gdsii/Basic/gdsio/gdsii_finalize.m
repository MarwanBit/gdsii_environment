function gdsii_finalize(gf);
%function gdsii_finalize(gf);
%
% gdsii_finalize :  closes a GDS II file created with
%                   gdsii_initialize by writing an ENDLIB record 
%                   and closing the file.
%
% gf :   file handle returned by gdsii_initialize
%

% initial revision : Ulf Griesmann, NIST, Feb 2011
% simplified it again, Ulf Griesmann, NIST, Nov 2011

% write the ENDLIB record
fwrite(gf, [4, 1024], 'int16');

% close file
fclose(gf);
