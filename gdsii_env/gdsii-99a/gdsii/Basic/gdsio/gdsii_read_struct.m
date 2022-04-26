function [gst] = gdsii_read_struct(gf);
%
% read all elements contained in a structure and return 
% a gds_structure object 
%

% read creation and modification date

% read creation/modification dates
cdate = fread(gf, 6, 'int16');
mdate = fread(gf, 6, 'int16');

% check STRNAME record
[rlen, rtype] = gdsii_record_info(gf);
if rtype ~= 1542
   error('STRNAME record expected.');
end

% read structure name
sname = gdsii_read_string(gf, rlen);

% create a new GDS structure
gst = gds_structure(sname);
gst = set(gst, 'cdate',cdate, 'mdate',mdate);  % use creation date from from file

% read all elements belonging to it
elist = {};
while 1
  
  [rlen, rtype] = gdsii_record_info(gf);
  switch rtype
    
   case 1792 % ENDSTR - reached end of structure
      break
  
   % boundary 
   case 2048
      elist{end+1} = gdsii_read_boundary(gf); % add boundary element
      
   % path
   case 2304
      elist{end+1} = gdsii_read_path(gf); % add path element
      
   % sref
   case 2560
      elist{end+1} = gdsii_read_sref(gf); % add sref element
      
   % aref
   case 2816
      elist{end+1} = gdsii_read_aref(gf); % add aref element
      
   % text
   case 3072
      elist{end+1} = gdsii_read_text(gf); % add text element
      
   % node 
   case 5376
      elist{end+1} = gdsii_read_node(gf); % add node element
      
   % box 
   case 11520
      elist{end+1} = gdsii_read_box(gf); % add box element
      
   otherwise
      error('invalid GDS file - ENDSTR or element expected.');
  end
  
end

gst = add_element(gst, elist);

return
