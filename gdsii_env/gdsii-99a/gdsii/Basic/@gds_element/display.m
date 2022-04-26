function display(gelm);
%function display(gelm);
%
% display method for GDS elements
%

% print variable name
fprintf('%s = \n\n', inputname(1));

switch gelm.etype
  
 case 'boundary'
   fprintf('Boundary:\npolygons: %d\n', gelm.data.nume);
   fprintf('layer = %d\n', gelm.data.layer);
   fprintf('dtype = %d\n', gelm.data.dtype);
      
 case 'sref'
   fprintf('Sref --> %s:\n', gelm.data.sname);
   if size(gelm.data.xy,2) > 10
      fprintf('reference positions: %d\n', size(gelm.data.xy,2));
   else
      fprintf('xy = '); 
      fprintf('\n%g  %g', gelm.data.xy');
    end
   if ~isempty(gelm.data.strans)
      display_strans(gelm.data.strans);
   end
   
 case 'aref'
   fprintf('Aref --> %s:\n', gelm.data.sname);
   fprintf('xy = '); 
   fprintf('\n%g  %g', gelm.data.xy');
   fprintf('adim = (rows = %d, cols = %d)\n', gelm.data.adim.row, gelm.data.adim.col);
   if ~isempty(gelm.data.strans)
      display_strans(gelm.data.strans);
   end
  
 case 'node' % what is that anyway ...
   fprintf('Node:\n');
   fprintf('xy = '); 
   fprintf('\n%g  %g', gelm.data.xy');
   fprintf('layer = %d\n', gelm.data.layer);
   fprintf('ntype = %d\n', gelm.data.ntype);
  
 case 'path'
   fprintf('Path:\npaths: %d\n', gelm.data.nume);
   fprintf('layer = %d\n', gelm.data.layer);
   fprintf('dtype = %d\n', gelm.data.dtype);
   fprintf('ptype = %d\n', gelm.data.ptype);
   fprintf('width = %f\n', gelm.data.width);
  
 case 'text'
   fprintf('Text:\n');
   fprintf('text = %s\n', gelm.data.text);
   fprintf('layer = %d\n', gelm.data.layer);
   fprintf('ttype = %d\n', gelm.data.ttype);
   fprintf('font = %d\n', gelm.data.font);
   fprintf('verj = %d\n', gelm.data.verj);
   fprintf('horj = %d\n', gelm.data.horj);
   fprintf('ptype = %d\n', gelm.data.ptype);
   fprintf('width = %f\n', gelm.data.width);
   fprintf('height = %f\n', gelm.data.height);
   fprintf('xy = '); 
   fprintf('\n%g  %g', gelm.data.xy');
   if ~isempty(gelm.data.strans)
      display_strans(gelm.data.strans);
   end
   
 case 'box'
   fprintf('Box:\n'); 
   fprintf('xy = '); 
   fprintf('\n%g  %g', gelm.data.xy');
   fprintf('\n');
   fprintf('layer = %d\n', gelm.data.layer);
   fprintf('btype = %d\n', gelm.data.btype);
  
end

% display records common to all elements
if ~isempty(gelm.data.elflags)
   fprintf('elflags = %s\n', gelm.data.elflags);
end
if ~isempty(gelm.data.plex)
   fprintf('plex = %d\n', gelm.data.plex);
end
if ~isempty(gelm.data.prop)
   fprintf('property = ');
   for k = 1:length(gelm.data.prop)
      fprintf('(Property %d :  attribute = %d, value = %s)\n', k, gelm.data.prop(k).attr, gelm.data.prop(k).value);
   end
end
fprintf('\n');

return


%
% display a strans structure
%
function display_strans(strans);

fprintf('strans = (');
fprintf('reflect ');
if isfield(strans,'reflect')
   fprintf('= %d, ', strans.reflect);
else
   fprintf('not used, ');
end
fprintf('absmag ');
if isfield(strans,'absmag')
   fprintf('= %d, ', strans.absmag);
else
   fprintf('not used, ');
end
fprintf('absang ');
if isfield(strans,'absang')
   fprintf('= %d, ', strans.absang);
else
   fprintf('not used, ');
end
fprintf('mag ');
if isfield(strans,'mag')
   fprintf('= %f, ', strans.mag);
else
   fprintf('not used, ');
end
fprintf('angle ');
if isfield(strans,'angle')
   fprintf('= %f)\n', strans.angle);
else
   fprintf('not used)\n');
end

return
