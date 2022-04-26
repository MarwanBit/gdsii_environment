function gdsii_aref(gf, xy, sname, strans, adim, prop, plex, elflags);
%function gdsii_aref(gf, xy, sname, strans, adim, prop, plex, elflags);
%
% gdsii_sref : output an array reference (aref) element
% 
% gf     : file handle returned by gdsii_initialize
% xy     : 3x2 matrix with coordinates of the referenced array in
%          user units.
%            xy(1,:) :  origin
%            xy(2,:) :  lower right corner
%            xy(3,:) :  upper left corner
% sname  : name of the referenced structure
% strans : (Optional) structure parameters
%            strans.reflect : if this is set (=1), the element is
%                             reflected about the x-axis prior to
%                             rotation. Default is 0.
%            strans.absmag  : if set to 1, specifies absolute
%                             magnification. Default is 0.
%            strans.absang  : if set to 1, specifies absolute angle.
%                             Default is 0.
%            strans.mag     : magnification factor for structure.
%                             Default is 1.
%            strans.angle   : rotation angle for structure.
%                             Default is 0.
% adim   : number of rows and columns in the array
%             adim.row : number of rows
%             adim.col : number of columns
% prop   : (Optional) a structure array of property number and 
%          property name pairs
%             prop.attr  : 1 .. 127
%             prop.value : string
% plex   : (Optional) plex number used for grouping of
%          elements. Should be small enough to use only the
%          rightmost 24 bits. A negative number indicates the start
%          of a plex group. E.g. -5 for the first element in the
%          plex, 5 for all the others.
% elflags: (Optional) an array (string) with the flags 'T' (template
%          data) and/or 'E' (exterior data).

% Ulf Griesmann, NIST, January 2008

% global variables
global gdsii_uunit;

% check arguments
if nargin < 4
   error('too few parameters in gdsii_sref');
end
if nargin < 6, prop = []; end;
if nargin < 7, plex = []; end;
if nargin < 8, elflags = []; end;

% start AREF record
fwrite(gf, [4, 2816], 'int16');

% ELFLAGS
if ~isempty(elflags)
   gdsii_elflags(gf, elflags);
end

% PLEX
if ~isempty(plex)
   gdsii_plex(gf, plex);
end

% write SNAME 
% pad string with 0 if not an even number of characters long
slen = length(sname);
if slen > 32
   error('string too long in gdsii_struct');
end
if mod(slen,2) ~= 0
   sname(end+1) = 0;
   slen = slen + 1;
end
rlen = slen + 4;
fwrite(gf, [rlen, 4614], 'int16');
fwrite(gf, sname, 'char');

% STRANS record
if ~isempty(strans)
   gdsii_strans(gf, strans);
end

% COLROW record
fwrite(gf, [8, 4866, adim.col, adim.row], 'int16');

% XY
[nr,nc] = size(xy);
if nr ~= 3 || nc ~= 2
   error('gdsii_aref :  xy must be 3x2 matrix.');
end
xy = xy * gdsii_uunit; % convert to database units
fwrite(gf, [28, 4099], 'int16');
fwrite(gf, xy', 'int32'); 

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 512);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');
