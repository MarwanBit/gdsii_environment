function [si] = subtree(glib, sname);
%function [si] = subtree(glib, sname);
%
% si :  indices of all structures in the library
%       that make up a subtree of structures in a 
%       gds_library object.
%
% glib :   input gds_library object
% sname :  name of the subtree top structure
% si :     structure indices 

% Initial version, Ulf Griesmann, December 2011

% global variables
global subtree_ind;
subtree_ind = [];

% compute adjacency matrix of input library
[A,N] = adjmatrix(glib.st);

% find index of structure 'sname'
stri = find(ismember(N,{sname}) > 0);
if isempty(stri)
   error(sprintf('Structure >>> %s <<< not found in library.', sname));
end

% find the indices of all children
find_children(A, stri);
si = sort(unique(subtree_ind));

return

function find_children(A, pai);
%
% Recursively find all children of node si.
% The resulting set of indices is returned through
% a global variable because I couldn't figure out 
% how to initialize the return value of a recursive
% function.
%

% global variable
global subtree_ind;

for p = pai
  
    % add index to array
    subtree_ind(end+1) = p;
    
    % find the children
    chi = find(A(p,:)>0);
    
    % no more children
    if isempty(chi)
       continue
    end
    
    % look for the next generation
    for c = chi
       find_children(A, c);
    end

end

return
