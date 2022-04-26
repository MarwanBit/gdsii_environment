function s = get(gelm, p);
%function s = get(gelm, p);
%
% get property method for GDS elements
%

% called with only one argument, return a structure with all data
if nargin == 1
  
   s = gelm.data;
   
elseif nargin == 2  % get a specific property
   
   if ischar(p)

      if strcmp(p, 'etype')  % element type
         s = gelm.etype;
      else
         if isfield(gelm.data, p)
            s = gelm.data.(p);
         else
            s = [];
         end
      end
     
   else
      error('gds_element.get :  property must be a string.');
   end
  
else
   error('gds_element.get :  invalid number of arguments.');
end
  
return
