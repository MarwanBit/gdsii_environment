function gdsii_plex(gf, plex)
%
% internal use only - write plex data
% a negative plex number specifies the plex head
%

% fixed a bug: actually write 'pw' to file; u.g.; January 2012

if abs(plex) > 16777215
   error('gdsii_plex :  plex number too large');
end
if plex < 0
   pw = int32(-plex);
   pw = bitor(pw, 16777216); % set bit 25
else
   pw = int32(plex);
end
fwrite(gf, [8, 12035], 'int16');
fwrite(gf, pw, 'int32');

return
