function [gel] = gdsii_read_text(gf);
%
% read a text element and return an element object
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
data.strans = [];
data.width = [];
data.height = 10;  % default for polygon rendering
data.ttype = [];
data.font = [];
data.verj = [];
data.horj = [];

% read in element data
while 1
  
  % read the next record
  [rlen, rtype] = gdsii_record_info(gf);
  switch rtype
    
    % ENDEL - finished with element
    case 4352
       break

    % STRING
    case 6406
       data.text = gdsii_read_string(gf, rlen);
       
    % XY
    case 4099
       N = rlen/4;
       data.xy = fread(gf, [2,N/2], 'int32')' / gdsii_uunit;

    % LAYER
    case 3330
       data.layer = fread(gf, 1, 'int16');

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
     
    % WIDTH
    case 3843
       data.width = fread(gf, 1, 'int32') / gdsii_uunit;
       
    % PATHTYPE
    case 8450
       data.ptype = fread(gf, 1, 'int16');
       
    % TEXT TYPE
    case 5634
       data.ttype = fread(gf, 1, 'int16');
       
    % PRESENTATION
    case 5889
       word = fread(gf, 1, '*uint16');    
       data.font = bitshift( bitand(word, 3));         % bits 1,2
       data.verj = bitshift( bitand(word, 12), -2);    % bits 3,4
       data.horj = bitshift( bitand(word, 48), -4);    % bits 5,6
     
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
       error('corrupted or invalid text element data in GDS file.');
  end
end

gel = gds_element('text', data);

return
