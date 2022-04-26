function pelm = poly_box(belm);
%function pelm = poly_box(belm);
%
% creates a boundary element with the same shape 
% as a box element.
%
% belm :  input box element
% pelm :  output boundary element

% Initial version, Ulf Griesmann, December 2011

% check if input is a box
if ~strcmp(belm.etype, 'box')
   error('gds_element.poly_box :  input must be box element.');
end

% copy element
pelm  = belm;

% re-define it as a boundary
pelm.etype = 'boundary';
pelm.data.nume = 1;
pelm.data.dtype = belm.data.btype; % box type becomes data type
rmfield(pelm.data, 'btype');       % remove box type
    
return
