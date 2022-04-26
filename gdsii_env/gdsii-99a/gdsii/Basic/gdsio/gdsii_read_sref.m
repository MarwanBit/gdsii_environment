function [gel] = gdsii_read_sref(gf);
%
% read an sref element and return an element object
% Dimensions are converted to user units.
%

% global variables
global gdsii_uunit;

% set element defaults for optional variables
data.isref = logical(1);
data.elflags = [];
data.plex = [];
data.prop = [];
nprop = 1;
data.strans = [];

% read in element data
while 1
  
  % read the next record
  [rlen, rtype] = gdsii_record_info(gf);
  switch rtype
    
    % ENDEL - finished with element
    case 4352
       break

    % SNAME
    case 4614
       data.sname = gdsii_read_string(gf, rlen);

    % XY
    case 4099
       N = rlen/4;
       data.xy = fread(gf, [2,N/2], 'int32')' / gdsii_uunit;

    % STRANS
    case 6657
       [data.strans.reflect, data.strans.absmag, data.strans.absang] ...
           = gdsii_read_strans(gf); 

    % MAG
    case 6917
       data.strans.mag = gdsii_readreal8(gf);
      
    % ANGLE
    case 7173
       data.strans.angle = gdsii_readreal8(gf);
     
    % PLEX   
    case 12035
       data.plex = fread(gf, 1, 'int32');
       if plex >= 16777216, plex = -plex; end

    % PROPATTR
    case 11010
       data.prop(nprop).attr = fread(gf, 1, 'int16');
       
    % PROPVALUE
    case 11270
       data.prop(nprop).value = gdsii_read_string(gf, rlen);
       nprop = nprop + 1;
       
    % ELFLAGS
    case 9729
       data.elflags = gdsii_read_elflags(gf);
       
   otherwise
       error('corrupted or invalid sref element data in GDS file.');
  end
end

gel = gds_element('sref', data);

return
