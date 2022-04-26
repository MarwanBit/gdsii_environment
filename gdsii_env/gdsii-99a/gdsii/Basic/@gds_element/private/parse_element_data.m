function data = parse_element_data(etype, propval);
%function data = parse_element_data(etype, propval);
% 
% parses the property value argument list
% of the gds_element constructor and returns
% arguments and default values in a structure

% global variables
global gdsii_layer;

data = [];
while (length(propval) > 1)

   % get property/value pair
   elproperty = propval{1};
   elvalue = propval{2};
   data.(elproperty) = elvalue;
   propval(1:2) = []; % remove from list
end

% fill in defaults common to all elements
if ~isfield(data, 'elflags'), data.elflags = []; end
if ~isfield(data, 'plex'), data.plex = []; end
if ~isfield(data, 'prop'), data.prop = []; end
if ~isfield(data, 'layer')
   if exist('gdsii_layer')
      data.layer = gdsii_layer;
   else
     data.layer = []; 
   end
end

% check element specific data and fill in defaults
switch etype
  
 case 'boundary'
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if ~iscell(data.xy), data.xy = {data.xy}; end
    data.nume = length(data.xy);
    if ~isfield(data, 'dtype'), data.dtype = 0; end
    data.isref = logical(0);
   
 case 'sref'
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if  isfield(data, 'adim'), error('gds_element :  adim not used for sref.'); end
    if ~isfield(data, 'sname'), error('gds_element :  missing structure name.'); end
    if ~isfield(data, 'strans'), data.strans = []; end
    data.isref = logical(1);
      
 case 'aref'
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if ~isfield(data, 'sname'), error('gds_element :  missing structure name.'); end
    if ~isfield(data, 'adim'), error('gds_element :  missing array dimensions.'); end
    if ~isfield(data, 'strans'), data.strans = []; end
    data.isref = logical(1);
  
 case 'path'
    if ~isfield(data, 'dtype'), data.dtype = 0; end
    if ~isfield(data, 'ptype'), data.ptype = 0; end
    if ~isfield(data, 'ext'), data.ext = []; end
    if ~isfield(data, 'width'), data.width = []; end
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if ~iscell(data.xy), data.xy = {data.xy}; end 
    data.nume = length(data.xy);
    data.isref = logical(0);
    
 case 'text'
    if ~isfield(data, 'text'), error('gds_element :  missing text.'); end
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if ~isfield(data, 'ttype'), data.ttype = 0; end
    if ~isfield(data, 'font'), data.font = 0; end
    if ~isfield(data, 'verj'), data.verj = 0; end
    if ~isfield(data, 'horj'), data.horj = 0; end
    if ~isfield(data, 'ptype'), data.ptype = 1; end
    if ~isfield(data, 'strans'), data.strans = []; end
    if ~isfield(data, 'width'), data.width = []; end
    if ~isfield(data, 'height'), data.height = 10; end % 10 user units
    data.isref = logical(0);
    
 case 'box'
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    if ~isfield(data, 'btype'), data.btype = 0; end
    if length(data.xy) ~= 5, error('gds_element :  invalid box polygon.'); end 
    data.isref = logical(0);
    
 case 'node' % what is that anyway ...
    if ~isfield(data, 'ntype'), data.ntype = 0; end
    if ~isfield(data, 'xy'), error('gds_element :  missing xy data.'); end
    data.isref = logical(0);
    
 otherwise
    error(sprintf('gds_element :  unknown element type >> %s <<', etype));
end

return
