function gelm = subsasgn(gelm, ins, val);
%function gelm = subsasgn(gelm, ins, val);
%
% Subscript assign method for the gds_element class
% Enables addressing element properties using
% structure field name indexing.
%
% gelm :  gds_element object to be modified
% ins :   index structure
% val :   new value

% Ulf Griesmann, NIST, June 2011

switch ins.type
  
 case '.'
    gelm.data.(ins.subs) = val;
  
 otherwise
    error('gds_element.subsasgn :  must use structure field name indexing.');
    
end
