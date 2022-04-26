function gdsii_sref(gf, xy, sname, strans, prop, plex, elflags);
%function gdsii_sref(gf, xy, sname, strans, prop, plex, elflags);
%
% gdsii_sref : output one or more structure reference (sref) elements
% 
% gf     : file handle returned by gdsii_initialize
% xy     : EITHER the origin of the referenced structure in user units.
%          One coordinate pair.
%          OR an array (Nx2) with coordinates, each row containing a
%          coordinate pair.
% sname  : name of the referenced structure
% strans : (Optional) structure transformation parameters
%            strans.reflect : if this is set (=1), the element is
%                             reflected about the x-axis prior to
%                             rotation. Default is 0.
%            strans.absmag  : if set to 1, specifies absolute
%                             magnification. Default is 0.
%            strans.absang  : if set to 1, specifies absolute angle.
%                             Default is 0.
%            strans.mag     : magnification factor for structure.
%                             Default is 1.
%            strans.angle   : rotation angle for structure in degrees.
%                             Default is 0.
% prop   : (Optional) a property number and property name pair
%             prop.attr  : 1 .. 127
%             prop.value : string with up to 126 characters
% plex   : (Optional) plex number used for grouping of
%          elements. Should be small enough to use only the
%          rightmost 24 bits. A negative number indicates the start
%          of a plex group. E.g. -5 for the first element in the
%          plex, 5 for all the others.
% elflags: (Optional) an array (string) with the flags 'T' (template
%          data) and/or 'E' (exterior data).

% Ulf Griesmann, NIST, January 2008
% U.G., Jan. 2011: make strans optional
% U.G., Feb. 2011: structure can be referenced at several locations

% global variables
global gdsii_uunit;

% check arguments
if nargin < 3
   error('gdsii_sref : too few arguments');
end
if nargin < 4, strans = []; end;
if nargin < 5, prop = []; end;
if nargin < 6, plex = []; end;
if nargin < 7, elflags = []; end;
if isempty(xy), error('gdsii_strans :  xy is empty.'); end;

% build SNAME
% pad string with 0 if not an even number of characters long
% (do this outside the loop)
slen = length(sname);
if slen > 32
   error('string too long in gdsii_struct');
end
if mod(slen,2) ~= 0
   sname(end+1) = 0;
   slen = slen + 1;
end
rlen = slen + 4;

% write out sref records 
for pos = xy'
   
   % start SREF record
   fwrite(gf, [4, 2560], 'int16');

   % ELFLAGS
   if ~isempty(elflags)
      gdsii_elflags(gf, elflags);
   end

   % PLEX
   if ~isempty(plex)
      gdsii_plex(gf, plex);
   end

   % write SNAME 
   fwrite(gf, [rlen, 4614], 'int16');
   fwrite(gf, sname, 'char');

   % STRANS record
   if ~isempty(strans)
      gdsii_strans(gf, strans);
   end

   % XY
   pos = pos * gdsii_uunit; % convert to database units
   fwrite(gf, [12, 4099], 'int16');
   fwrite(gf, pos, 'int32'); 

   % Property
   if ~isempty(prop)
      gdsii_property(gf, prop, 512);
   end

   % ENDEL
   fwrite(gf, [4, 4352], 'int16');
   
end

return
