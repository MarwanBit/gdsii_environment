function gdsii_deflayer(layer);
% function gdsii_deflayer(layer);
%  
% gdsii_deflayer :  change the default layer for a layout.
%
% layer :  new default layer
%

% Ulf Griesmann, NIST, March 2008

% default layer is stored in global variable
global gdsii_layer; 

% check arguments
if nargin < 1
   error('gdsii_deflayer :  missing argument');
end

% set default layer
gdsii_layer = layer;
