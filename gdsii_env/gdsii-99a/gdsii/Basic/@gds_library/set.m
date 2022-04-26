function s = set(glib, varargin);
%function s = set(glib, varargin);
%
% set property method for GDS elements
%

if (length (varargin) < 2 || rem (length (varargin), 2) ~= 0)
   error ('gds_library.set :  expecting property/value pair(s).');
end

s = glib;

while length(varargin) > 1
  
   % get property/value pair
   prop = varargin{1};
   val = varargin{2};
   if ~ischar(prop)
      error('gds_library.set :  property name must be a string.');
   end
   
   if strcmp(prop, 'layer') || strcmp(prop, 'uunit') || ...
      strcmp(prop, 'dbunit') || strcmp(prop, 'lname')
      s.(prop) = val;
   else
      error('gds_library.set :  property cannot be changed.');
   end

   varargin(1:2) = [];

end

return
