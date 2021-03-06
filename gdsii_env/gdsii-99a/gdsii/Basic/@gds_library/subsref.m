function gstrs = subsref(glib, ins);
%function gstrs = subsref(glib, ins);
%
% subscript reference method for the gds_library class
%
% glib  :   a gds_structure object
% ins   :   an array index reference structure
% gstrs :   a gds_structure object or a 
%           cell array of the indexed gds_structure objects

% Ulf Griesmann, NIST, June 2011

switch ins.type
 
 case '()'
    idx = ins.subs{:};
    if length(idx) == 1 % return the structure
       gstrs = glib.st{idx};
    else
       gstrs = glib.st(idx);
    end
       
 case '.'
    for k = 1:length(glib)
       if strcmp(ins.subs, get(glib.st{k}, 'sname')) 
          gstrs = glib.st{k};
          return 
       end
    end 

    error(sprintf('gds_library.subsref :  structure >> %s << not found', ins.subs));   
       
 otherwise
    error('gds_library.subsref :  invalid indexing type.');

end
  
return  
