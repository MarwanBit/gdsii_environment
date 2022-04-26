function gdsii_boundary(gf, xy, layer, dtype, prop, plex, elflags);
%function gdsii_boundary(gf, xy, layer, dtype, prop, plex, elflags);
%
% gdsii_boundary : write one or more  boundary element(s) to a file
% 
% gf     : file handle returned by gdsii_initialize
% xy     : EITHER a N x 2 matrix of vertex coordinates in user
%          units. Last vertex must be the same as the first. 
%          Nominally, N <= 200 but the format permits N < 8191 
%          and many programs will be able to handle more than 200
%          OR a cell array with N x 2 matrices containing vertices
%          Data are stored as 4 byte signed integers,
% layer  : (Optional) layer number. Default is set by gdsii_initialize.
% dtype  : (Optional) Data type number between 0..255. Layer number 
%          and data type together form a layer specification. 
%          DEFAULT is 0.
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
% extended to write cell arrays of boundaries: U Griesmann, Jan 2010

% global variables
global gdsii_layer;

% check arguments
if nargin < 3, layer = []; end;
if nargin < 4, dtype = []; end;
if nargin < 5, prop = []; end;
if nargin < 6, plex = []; end;
if nargin < 7, elflags = []; end;

if isempty(layer), layer = gdsii_layer; end;
if layer ~= gdsii_layer, gdsii_layer = layer; end;
if isempty(dtype), dtype = 0; end;

% write out boundaries to file
if iscell(xy)
   for k = 1:length(xy)
      write_boundary(gf, xy{k}, layer, dtype, prop, plex, elflags);
   end
else
   write_boundary(gf, xy, layer, dtype, prop, plex, elflags);
end

return

function write_boundary(gf, xy, layer, dtype, prop, plex, elflags);
%
% local function to write a boundary element to a GDSII file
%

% global variables
global gdsii_dbunit;
global gdsii_uunit;

% first check if boundary polygon is closed
% NOTE: this is tricky, because the first and last point can be the same
% and yet numerically different.
%
N = length(xy);
if any(xy(1,:) ~= xy(N,:))        % check is first and last point are exactly the same
   D = norm(xy(1,:) - xy(N,:))*gdsii_uunit;  % calculate distance in database units
   if D < gdsii_dbunit            % check if they are the same within one data base unit
      xy(N,:) = xy(1,:);          % make them the same numerically
   else                           % the last point really is different
      xy(end+1,:) = xy(1,:);      % close the polygon
      N = N + 1;
   end
end

if N > 8191
   error('More than 8191 vertices in gdsii_boundary element.');
end

% start BOUNDARY record
fwrite(gf, [4, 2048], 'int16');

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

% DATATYPE
fwrite(gf, [6, 3586, dtype], 'int16');

% XY
xy = xy * gdsii_uunit; % convert to database units
fwrite(gf, [4+2*N*4, 4099], 'uint16');
fwrite(gf, xy', 'int32'); 

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 128);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');

return
