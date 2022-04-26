function [ts] = topstruct(csa);
%function [ts] = topstruct(csa);
%
% topstruct :  return the name(s) of the top structure(s)
%              in a cell array of gds_structure objects
%
% csa :  a cell array of gds_structure objects
% ts :   name of the top structure or cell array with names if 
%        the library has more than one top level structure

% Initial version, Ulf Griesmann, December 2012

% calculate the adjacency matrix of the structure tree
[A,N] = adjmatrix(csa);

% find top level structure name(s)
naml = N(find(sum(A)==0));
if length(naml) == 1
   ts = naml{1};
else
   ts = naml;
end

return
