function ef = gdsii_read_elflags(gf);
%
% internal use - read data of an ELFLAGS record
%

word = fread(gf, 1, '*uint16');
if bitand(word, 16384)      % check bit 15
   data.elflags = 'E';
elseif bitand(word, 32768)  % check bit 16
   data.elflags = 'T';
end

return
