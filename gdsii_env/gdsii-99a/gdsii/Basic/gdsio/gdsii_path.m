function gdsii_path(gf, xy, layer, dtype, ptype, width, ext, prop, plex, elflags);
%function gdsii_path(gf, xy, layer, dtype, ptype, width, prop, plex, elflags);
%
% gdsii_path : output a path element
% 
% gf     : file handle returned by gdsii_initialize
% xy     : EITHER N x 2 matrix of vertex coordinates in user
%          units (nominally, N <= 200 but the format permits N < 32*1024 
%          and many programs will be able to handle more than 200
%          vertices), OR a cell array containing Nx2 matrices of
%          vertex coorinates.
% layer  : (Optional) layer number. Default is set by gdsii_initialize.
% dtype  : (Optional) Data type number 0..255. Default is 0.
% ptype  : (Optional) type of path: 0 for square ends, 1 for
%          rounded ends, 2 for square ended paths that extend
%          half-width beyond their end points, 4 for variable
%          length square ends (type 3 is not used).
%          Default is 0.
% width  : (Optional) Width of path in user units. 0 if omitted.
% ext    : (Optional) path extension for path type 4
%            ext.beg : extension at the beginning of path in
%                      user units.
%            ext.end : extension at the end in user units.
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
global gdsii_layer;

% check arguments
if nargin < 10, elflags = []; end;
if nargin < 9, plex = []; end;
if nargin < 8, prop = []; end;
if nargin < 7, ext = []; end;
if nargin < 6, width = []; end;
if nargin < 3, layer = []; end;
if nargin < 5, ptype = []; end;
if nargin < 4, dtype = []; end;

if isempty(layer), layer = gdsii_layer; end;
if layer ~= gdsii_layer, gdsii_layer = layer; end;
if isempty(dtype), dtype = 0; end;
if isempty(ext), ext.beg = 0; ext.end = 0; end;

% write out path records
if iscell(xy)
   for k = 1:length(xy)
      write_path(gf, xy{k}, layer, dtype, ptype, width, ext, prop, plex, elflags);   end
else
   write_path(gf, xy, layer, dtype, ptype, width, ext, prop, plex, elflags);
end

return

function write_path(gf, xy, layer, dtype, ptype, width, ext, prop, plex, elflags);
%
% local function to write a path record
%

% global variables
global gdsii_uunit;

% start PATH record
fwrite(gf, [4, 2304], 'int16');

% ELFLAGS
if ~isempty(elflags)
   gdsii_elflags(gf, elflags);
end

% PLEX
if ~isempty(plex)
   gdsii_plex(gf, plex);
end

% LAYER
fwrite(gf, [6, 3330, layer], 'int16');

% DTYPE
fwrite(gf, [6, 3586, dtype], 'int16'); % four byte integer

% PTYPE
if ~isempty(ptype)
   fwrite(gf, [6, 8450, ptype], 'int16');
end
   
% WIDTH
if ~isempty(width)
   fwrite(gf, [8, 3843], 'int16');
   fwrite(gf, width * gdsii_uunit, 'int32');
end

% Path extensions
if ptype == 4
   fwrite(gf, [8, 12291], 'int16'); %BGNEXTN
   fwrite(gf, ext.beg*gdsii_uunit, 'int32');
   fwrite(gf, [8, 12457], 'int16'); %ENDEXTN
   fwrite(gf, ext.end*gdsii_uunit, 'int32');
end

% XY
xy = xy * gdsii_uunit; % convert to database units
N = length(xy);
if N > 4095
   fprintf('\nWarning :  creating path element with > 4095 vertices\n\n');
end
if N > 8191
   error('gdsii_path :  too many vertices (must be < 8191).');
end
fwrite(gf, [4+2*N*4, 4099], 'uint16');
fwrite(gf, xy', 'int32'); 

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 128);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');

return
