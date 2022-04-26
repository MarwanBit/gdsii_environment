function gdsii_property(gf, prop, maxlen);
%
% internal use only - writes property records for elements
% to the GDS II file.
%

% Ulf Griesmann, January 2008

% prop is a structure array

plen = 0;

for k = 1:length(prop)
  
   % attribute PROPATTR
   fwrite(gf, [6, 11010, prop(k).attr], 'int16');

   % value PROPVALUE
   slen = length(prop(k).value);
   if mod(slen,2) ~= 0
      prop(k).value(end+1) = 0;
      slen = slen + 1;
   end
   fwrite(gf, [slen+4, 11270], 'int16');
   fwrite(gf, prop(k).value, 'char');
   
   % check length
   plen = plen + slen + 10;
   if plen > maxlen
      fclose(gf);
      error('gdsii_property :  property data exceed maximum of %d bytes.', maxlen);
   end
   
end

return
