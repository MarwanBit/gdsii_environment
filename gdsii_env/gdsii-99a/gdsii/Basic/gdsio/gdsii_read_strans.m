function [reflect, absmag, absang] = gdsii_read_strans(gf);
%
% internal use - read the data of an STRANS record
%

word = fread(gf, 1, '*uint16');
reflect = bitand(word, 32768) ~= 0; % bit 15
absmag  = bitand(word, 4) ~= 0;     % bit 3
absang  = bitand(word, 2) ~= 0;     % bit 2

return
