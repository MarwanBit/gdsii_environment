function prop = subsref(gelm, ins);
%function prop = subsref(gelm, ins);
%
% subscript reference method for the gds_element class
% This method allows class properties to be addressed using
% structure field name indexing. 
% The element type cannot be changed.
%
% gelm :   a gds_element object
% ins :    an array index reference structure
% prop :   the index property

% Ulf Griesmann, NIST, June 2011

switch ins.type
 
 case '.'
    try
       prop = gelm.data.(ins.subs);
    catch
       error(sprintf('GDS element has no property >> %s <<', ins.subs));
    end
 
 otherwise
    error('gds_element.subsref :  must use structure field name indexing.');

end
  
return  
