function gdsii_elflags(gf, elflags);
%
% internal use : set the elflags
%
% gf :     file id returned by gdsii_initialize
% elflags: an array (string) with the flags 'T' (template
%          data) and/or 'E' (exterior data).
%

% Ulf Griesmann, NIST, January 2008
% changed from bitset to bitor and
% check for the correct flag 'E'; u.g.; January 2012

flags = uint16(0);
for k=1:length(elflags)
   if elflags(k) == 'E'
      flags = bitor(flags, 16384); % set bit 15
   end
   if elflags(k) == 'T'
      flags = bitor(flags, 32768); % set bit 16
   end
end
fwrite(gf, [6, 9729, flags], 'uint16');

return
