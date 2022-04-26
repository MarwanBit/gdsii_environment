function gdsii_node(gf, xy, layer, ntype, prop, plex, elflags);
%function gdsii_node(gf, xy, layer, ntype, prop, plex, elflags);
%
% gdsii_node : output a node element
% 
% gf     : file handle returned by gdsii_initialize
% xy     : N x 2 matrix of vertex coordinates in user units, 
%          N <= 50.
% layer  : (Optional) layer number. Default is set by gdsii_initialize.
% ntype  : (Optional) node type - a number between 0 .. 255
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
if nargin < 3, layer = []; end;
if nargin < 4, ntype = []; end;
if nargin < 5, prop = []; end;
if nargin < 6, plex = []; end;
if nargin < 7, elflags = []; end;

if isempty(layer), layer = gdsii_layer; end;
if layer ~= gdsii_layer, gdsii_layer = layer; end;
if isempty(ntype), ntype = 0; end;

% start NODE record
fwrite(gf, [4, 5376], 'int16');

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

% NODETYPE
fwrite(gf, [6, 10754, ntype], 'int16');

% XY
xy = xy * gdsii_uunit;     % convert to database units
N = length(xy);
fwrite(gf, [2*N*4+4, 4099], 'int16');
fwrite(gf, xy', 'int32'); 

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 128);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');
