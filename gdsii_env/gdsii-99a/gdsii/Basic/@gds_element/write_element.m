function write_element(gelm, gf);
%
% Stores a GDS element object to a library file.
% This function calls the 'gdsii_*' function appropriate
% for the element type. 
%
% gelm :  gds_element object to write to the file
% gf :    file handle for a gds II library file

% Ulf Griesmann, NIST, June 2011

switch gelm.etype
 
 case 'boundary'
    gdsii_boundary(gf, gelm.data.xy, gelm.data.layer, gelm.data.dtype, ...
                   gelm.data.prop, gelm.data.plex, gelm.data.elflags);
  
 case 'sref'
    gdsii_sref(gf, gelm.data.xy, gelm.data.sname, gelm.data.strans, ...
               gelm.data.prop, gelm.data.plex, gelm.data.elflags);
  
 case 'aref'
    gdsii_aref(gf, gelm.data.xy, gelm.data.sname, gelm.data.strans, ...
               gelm.data.adim, gelm.data.prop, gelm.data.plex, gelm.data.elflags);
  
 case 'path'
    gdsii_path(gf, gelm.data.xy, gelm.data.layer, gelm.data.dtype, ...
               gelm.data.ptype, gelm.data.width, gelm.data.ext, ...
               gelm.data.prop, gelm.data.plex, gelm.data.elflags);
  
 case 'node'
    gdsii_node(gf, gelm.data.xy, gelm.data.layer, gelm.data.ntype, ...
               gelm.data.prop, gelm.data.plex, gelm.data.elflags);               
  
 case 'box'
    gdsii_box(gf, gelm.data.xy, gelm.data.layer, gelm.data.btype, ... 
               gelm.data.prop, gelm.data.plex, gelm.data.elflags);               
  
 case 'text'
    tform.type = gelm.data.ttype;
    tform.font = gelm.data.font;
    tform.verj = gelm.data.verj;
    tform.horj = gelm.data.horj;
    tform.ptype = gelm.data.ptype;
    tform.width = gelm.data.width;
    gdsii_text(gf, gelm.data.text, gelm.data.xy, tform, gelm.data.strans, ...
               gelm.data.layer, ...
               gelm.data.prop, gelm.data.plex, gelm.data.elflags);                 
end

return
