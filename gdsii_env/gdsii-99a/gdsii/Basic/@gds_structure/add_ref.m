function [ostruc] = add_ref(istruc, struc, varargin);
%function [ostruc] = add_ref(istruc, struc, varargin);
%
% Add elements or other structures to structures
%
% istruc :   a gds_structure object
% struc :    a gds_structure object, a cell array of gds_structure
%            objects, or a structure name to be referenced
% varargin : variable/property pairs to describe the placement of
%            the gds_structure. The default position 'xy' is [0,0].
% ostruc :   gds_structure containing the input structure with the added
%            reference elements.
%
% Example:
%           struc = add_ref(struc, {beauty,truth} 'xy',[1000,1000]);
%

% Initial version, Ulf Griesmann, December 2011

% copy input to output
ostruc = istruc;

% get the structure name
if ischar(struc)
   sname = {struc};   
elseif isa(struc, 'gds_structure')
   sname = {struc.sname};
elseif iscell(struc)
   sname = cellfun(@(x)x.sname, struc, 'UniformOutput',0);
else
   error('gds_structure.add_ref :  second argument must be a string or gds_structure(s).');
end

% make a reference element
[xy,elflags,plex,prop,strans,adim] = deal([]);
while length(varargin) > 0
  switch varargin{1}
   case 'xy'
      xy = varargin{2};
   case 'strans'
      strans = varargin{2};
   case 'adim'
      adim = varargin{2};
   case 'elflags'
      elflags = varargin{2};
   case 'plex'
      plex = varargin{2};
   case 'prop'
      prop = varargin{2};
   otherwise
      error(sprintf('gds_structure.add : unrecognized element property %s'), varargin{1});
  end
  varargin(1:2) = [];
end

% default position
if isempty(xy)
   xy = [0,0];
end

for k = 1:length(sname)
   if isempty(adim)
      sr = gds_element('sref', 'xy',xy, 'sname',sname{k}, 'strans',strans, ...
                       'elflags',elflags, 'plex',plex, 'prop',prop);
   else
      sr = gds_element('aref', 'xy',xy, 'sname',sname{k}, 'strans',strans, 'adim',adim,...
                       'elflags',elflags, 'plex',plex, 'prop',prop);
   end
   ostruc.el{end+1} = sr;
end
ostruc.numel = ostruc.numel + length(sname);

return
