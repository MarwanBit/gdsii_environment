function s = set(gelm, varargin);
%function s = set(gelm, varargin);
%
% set property method for GDS elements
%

if (length (varargin) < 2 || rem (length (varargin), 2) != 0)
   error ('gds_element.set :  expecting property/value pair(s).');
end

s = gelm;

while length(varargin) > 1
  
   % get property/value pair
   prop = varargin{1};
   val = varargin{2};
   if ~ischar(prop)
      error('gds_element.set :  property must be a string.');
   end
   if strcmp(prop, 'xy') && ~iscell(val)
      val = {val};  % always stored as cell array
   end
   s.data.(prop) = val;
   varargin(1:2) = [];

end

return
