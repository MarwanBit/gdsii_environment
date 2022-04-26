function gdsii_text(gf, txt, xy, tform, strans, layer, prop, plex, elflags);
%function gdsii_text(gf, txt, xy, tform, strans, layer, prop, plex, elflags);
%
% gdsii_text : output a text element
% 
% gf     : file handle returned by gdsii_initialize
% txt    : text string to be plotted
% xy     : position of the text in user units (one pair of coordinates)
% tform  : text format. 
%            tform.type : text type: a number 0 .. 63 (DEFAULT is 0)
%            tform.font : text font 0 .. 3 (DEFAULT is 0)
%            tform.verj : vertical justification: 0 = top, 1 =
%                         middle, 2 = bottom (DEFAULT is 0)
%            tform.horj : horzontal justification: 0 = left, 1 =
%                         center, 2 = right (DEFAULT is 0)
%            tform.ptype: (Optional) path type as defined in gdsii_path 
%            tform.width: (Optional) with of line to draw text in user
%                         coordinates.
% strans : (Optional) text transform flags
%            strans.reflect : if this is set (=1), the element is
%                             reflected about the x-axis prior to
%                             rotation. Default is 0.
%            strans.absmag  : if set to 1, specifies absolute
%                             magnification. Default is 1.
%            strans.absang  : if set to 1, specifies absolute angle.
%                             Default is 1.
%            strans.mag     : magnification factor for structure.
%                             Default is 1.
%            strans.angle   : rotation angle in degrees.
%                             Default is 0.
% layer  : (Optional) layer number. Default is set by gdsii_initialize.
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
if nargin < 9, elflags = []; end;
if nargin < 8, plex = []; end;
if nargin < 7, prop = []; end;
if nargin < 6, layer = []; end;
if nargin < 5, strans = []; end;
if nargin < 4, tform = []; end;

if isempty(layer), layer = gdsii_layer; end;
if layer ~= gdsii_layer, gdsii_layer = layer; end;

if ~isfield(tform, 'type'), tform.type = 0; end;
if ~isfield(tform, 'width'), tform.width = []; end;
if ~isfield(tform, 'font'), tform.font = 0; end;
if ~isfield(tform, 'verj'), tform.verj = 0; end;
if ~isfield(tform, 'horj'), tform.horj = 0; end;
if ~isfield(tform, 'ptype'), tform.ptype = []; end;

% start TEXT record
fwrite(gf, [4, 3072], 'int16');

% ELFLAGS
if ~isempty(elflags)
   gdsii_elflags(gf, elflags);
end

% PLEX
if ~isempty(plex)
   gdsii_plex(gf, plex)
end

% LAYER
fwrite(gf, [6, 3330, layer], 'int16');

% TEXTTYPE
fwrite(gf, [6, 5634, tform.type], 'int16'); 

% PRESENTATION
pw = uint16(0);
switch(tform.font)
 case 0
    % do nothing
 case {1, 3}
    pw = bitset(pw, 1);
 case {2, 3}
    pw = bitset(pw, 2);
end
switch(tform.verj)
 case 0
    % do nothing
 case 1
    pw = bitset(pw, 3);
 case 2
    pw = bitset(pw, 4);
end
switch(tform.horj)
 case 0
    % do nothing
 case 1
    pw = bitset(pw, 5);
 case 2
    pw = bitset(pw, 6);
end
fwrite(gf, [6, 5889, pw], 'uint16');

% PATHTYPE
if ~isempty(tform.ptype)
   fwrite(gf, [6, 8450, tform.ptype], 'int16');
end

% WIDTH
if ~isempty(tform.width)
   fwrite(gf, [8, 3843], 'int16');
   fwrite(gf, tform.width*gdsii_uunit, 'int32');
end

% STRANS
gdsii_strans(gf, strans);

% XY
xy = xy * gdsii_uunit; % convert to database units
fwrite(gf, [12, 4099], 'int16');
fwrite(gf, xy, 'int32'); 

% STRING
slen = length(txt);
if mod(slen,2)
   txt(end+1) = 0;
   slen = slen + 1;
end
if slen > 512
   error('string too long in gdsii_text');
end
fwrite(gf, [slen+4, 6406], 'int16');
fwrite(gf, txt, 'char');

% Property
if ~isempty(prop)
   gdsii_property(gf, prop, 128);
end

% ENDEL
fwrite(gf, [4, 4352], 'int16');

return
