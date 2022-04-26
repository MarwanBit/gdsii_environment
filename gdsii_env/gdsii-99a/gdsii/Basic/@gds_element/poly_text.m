function pelm = poly_text(telm);
%function pelm = poly_text(telm);
%
% renders a text element as a boundary element with
% the text defined as polygons.
%
% telm :  input text element
% pelm :  output boundary element
%
% NOTE:
% -----
% * GDS II text elements are not designed to be rendered as polygons.
% They appear to have originally been intended for drawning by a
% plotter device. The height property of text elements (not in the
% GDS definition !) is used to size the text elements for rendering
% with polygons. The default height is 10 user units (see:
% gds_element.m).
%
% * This function is not very efficient because it renders each string twice;
% first to determine the length in user units, then to render it at the correct
% location in the desired orientation. This is acceptable because there are only
% few text elements in any given layout.
%
% * the magnification factor of the optional strans record is ignored.

% Initial version, Ulf Griesmann, December 2011

% check if input is a text
if ~strcmp(telm.etype, 'text')
   error('gds_element.poly_text :  input must be text element.');
end

% copy element and remove properties that are ignored
pelm  = telm;
pelm.etype = 'boundary';
pelm.data.dtype = telm.data.ttype; % text type becomes data type
rmfield(pelm.data, 'ttype');       % remove ttype field
rmfield(pelm.data, 'font');        % ignore font
rmfield(pelm.data, 'width');       % ignore line width
rmfield(pelm.data, 'strans');      % not used
rmfield(pelm.data, 'verj');        % not used
rmfield(pelm.data, 'horj');        % not used

% render text string as cell array of boundaries to get width
[tchars, twidth] = gdsii_ptext([], telm.data.text, [0,0], ...
                               telm.data.height, 0, 1);

% determine origin depending on justification
XY = telm.data.xy;  % text location
switch telm.data.horj
 case 1
    XY(1) = XY(1) - twidth/2;
 case 2
    XY(1) = XY(1) - twidth;
end
switch telm.data.verj
 case 0
    XY(2) = XY(2) - telm.data.height;
 case 1
    XY(2) = XY(2) - telm.data.height/2;
end

% get angle from strans and convert to radians
ang = 0;
if ~isempty(telm.data.strans)
   ang = pi * telm.data.strans.ang / 180; 
end

% render the string at the correct place
pelm.data.xy = gdsii_ptext([], telm.data.text, XY, telm.data.height, ...
                           telm.data.layer, ang, 1);
pelm.data.nume = length(pelm.data.xy); 

return
