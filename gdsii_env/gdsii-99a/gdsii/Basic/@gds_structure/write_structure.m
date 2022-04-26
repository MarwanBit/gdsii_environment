function write_structure(gstruc, gf);
%function write_structure(gstruc, gf);
% 
% write_structure :
%     writes a gds_structure object to an open file
%
% gstruc :  a gds_structure object
% gf :      a file handle of a gds library file
%

% Ulf Griesmann, NIST, November 2011

% check and get file handle
if nargin < 2
   error('gdsii_write_structure :  missing file handle.');
end

% write a structure record
gdsii_struct(gf, gstruc.sname, gstruc.cdate);

% write all elements in the structure
cellfun(@(x)write_element(x,gf), gstruc.el);

% write an end structure record
gdsii_endstruct(gf);

return
