function [gel] = gdsii_read_path(gf);
%
% read a path element and return an element object
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
data.ptype = [];
data.width = [];
data.ext.beg = 0;
data.ext.end = 0;

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
       data.xy = {fread(gf, [2,N/2], 'int32')' / gdsii_uunit};
       data.nume = 1;

    % LAYER
    case 3330
       data.layer = fread(gf, 1, 'int16');

    % DATATYPE
    case 3586
       data.dtype = fread(gf, 1, 'int16');
       
    % WIDTH
    case 3843
       data.width = fread(gf, 1, 'int32') / gdsii_uunit;
       
    % PATHTYPE
    case 8450
       data.ptype = fread(gf, 1, 'int16');

    % BGNEXTN
  case 12291
       data.ext.beg = fread(gf, 1, 'int32') / gdsii_uunit;
       
    % ENDEXTN
    case 12547
       data.ext.end = fread(gf, 1, 'int32') / gdsii_uunit;
    
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
       fprintf('\n>>> Unrecognized record code 0x%s\n', dec2hex(rtype));
       fprintf('>>> Skipping %d bytes ...\n\n', rlen);
       discard = fread(gf, rlen, '*char'); 
  end
end

gel = gds_element('path', data);

return
