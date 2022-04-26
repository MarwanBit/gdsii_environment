function oelm = add_poly(ielm, xy);
%function oelm = add_poly(ielm, xy);
%
% adds a polygon, or a cell array of polygons to a boundary
% elment. 
%
% ielm :  input boundary element
% xy :    a polygon or cell array of polygons
% oelm :  output element

% Initial version, Ulf Griesmann, December 2011
% extend to path elements; U. Griesmann, November 2012

% works only with bounary elements
if strcmp(gelm.etype, 'boundary') || strcmp(gelm.etype, 'path')

   % copy element
   oelm = ielm;

   % add polygon(s)
   if ~iscell(xy), xy = {xy}; end
   oelm.xy = [ielm.xy, xy];
   oelm.data.nume = length(oelm.xy);

else
  
  error('gds_element.add_poly :  input must be a boundary or path element.');

end

return
