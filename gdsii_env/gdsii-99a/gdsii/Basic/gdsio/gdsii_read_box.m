function [gel] = gdsii_read_box(gf);
%
% read a box element and return an element object
% Dimensions are converted to user units.
%

% global variables
global gdsii_uunit;

% set element defaults for optional variables
data.isref = logical(0);
data.elflags = [];
data.plex = [];
data.prop = [];
nprop = 1;

% read in element data
while 1
  
  % read the next record
  [rlen, rtype] = gdsii_record_info(gf);
  switch rtype
    
    % ENDEL - finished with element
    case 4352
       break

    % XY
    case 4099
       N = rlen/4;
       data.xy = fread(gf, [2,N/2], 'int32')' / gdsii_uunit;

    % LAYER
    case 3330
       data.layer = fread(gf, 1, 'int16');

    % BOXTYPE
    case 11778
       data.btype = fread(gf, 1, 'int16');
       
    % PROPATTR
    case 11010
       data.prop(nprop).attr = fread(gf, 1, 'int16');
       
    % PROPVALUE
    case 11270
       data.prop(nprop).value = gdsii_read_string(gf, rlen);
       nprop = nprop + 1;
    
    % PLEX   
    case 12035
       data.plex = fread(gf, 1, 'int32');
       if plex >= 16777216, plex = -plex; end

    % ELFLAGS
    case 9729
       data.elflags = gdsii_read_elflags(gf);
       
   otherwise
       error('corrupted or invalid box element data in GDS file.');
  end
end

gel = gds_element('box', data);

return
