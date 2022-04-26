function gdsii_strans(gf, sp);
%
% internal use only - writes an strans record 
% to the GDS II file. These are needed for sref, 
% aref, and text elements
%

% Ulf Griesmann, January 2008
% improved; U.G. November 2011
% use bitor instead of bitset; u.g. Jan 2012
% finally set the correct bits. U.G. Feb 2013

% create the bit array
ba = uint16(0);
if isfield(sp, 'reflect') && sp.reflect
   ba = bitor(ba, 32768); % set bit 16
end
if isfield(sp, 'absmag') && sp.absmag
   ba = bitor(ba, 4);     % set bit 3
end
if isfield(sp, 'absang') && sp.absang
   ba = bitor(ba, 2);     % set bit 2
end
fwrite(gf, [6, 6657, ba], 'uint16');

% optional magnification and angle
if isfield(sp, 'mag') && sp.mag ~= 1
   fwrite(gf, [12, 6917], 'int16');
   gdsii_wrtreal8(gf, sp.mag);
end
if isfield(sp, 'angle') && sp.angle ~= 0
   fwrite(gf, [12, 7173], 'int16');
   gdsii_wrtreal8(gf, sp.angle);
end

return
