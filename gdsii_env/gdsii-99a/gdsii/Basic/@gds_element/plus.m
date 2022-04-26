function [gelm] = plus(gelm1, gelm2);
%function [gelm] = plus(gelm1, gelm2);
%
% Overloads the '+' operator for the gds_element class.
% Can be used to combine to simple or compound boundary, path,
% or sref elements into a new compound element. All properties
% are inherited from gelm1.
%
% gelm1 :  input boundary, path, or sref element 1
% gelm2 :  input boundary, path, or sref element 2
% gelm  :  compound boundary path or sref element
%          on the same layer as gelm1.

% Ulf Griesmann, NIST, November 2012

if strcmp(gelm1.etype, 'boundary') || strcmp(gelm1.etype, 'path')
   gelm = gelm1;
   gelm.data.xy = [gelm1.data.xy, gelm2.data.xy];
   gelm.data.nume = gelm1.data.nume + gelm2.data.nume;
  
elseif strcmp(gelm1.etype, 'sref')
   gelm = gelm1;
   gelm.data.xy = [gelm1.data.xy; gelm2.data.xy];
  
else
   error('gds_element.plus :  input must be boundary, sref, or path element.');
end

return

