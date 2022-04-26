function gdsii_box(gf, xy, layer, type, prop, plex, elflags);
%function gdsii_box(gf, xy, layer, type, prop, plex, elflags);
%
% gdsii_box : output a box element
% 
%+----------------------------------------------------------+
%| NOTE: Box elements are ignored by many layout processors |
%| especially in the microfabrication world. Boundary       |
%| elements (polygons) should be used instead.              |
%+----------------------------------------------------------+
%
% gf     : file handle returned by gdsii_initialize
% xy     : 5 x 2 matrix of box corner coordinates in user units.
% layer  : (Optional) layer number. Default is set by gdsii_initialize.
% type   : (Optional) box type - a number between 0 .. 255
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
global gdsii_uunit;

% check arguments
if nargin < 7, elflags = []; end;
if nargin < 6, plex = []; end;
if nargin < 5, prop = []; end;
if nargin < 4, type = []; end;
if nargin < 3, layer = []; end;

if isempty(layer), layer = gdsii_layer; end;
if layer ~= gdsii_layer, gdsii_layer = layer; end;
if isempty(type), type = 0; end;

% start box record
fwrite(gf, [4, 11520], 'int16');

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

% BOXTYPE
fwrite(gf, [6, 11778, type], 'int16');

% XY
if length(xy) == 4
   xy(5,:) = xy(1,:);  % last point must be same as first
end
xy = xy * gdsii_uunit; % convert to database units
fwrite(gf, [44, 4099], 'int16');
fwrite(gf, xy', 'int32'); 

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 128);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');
