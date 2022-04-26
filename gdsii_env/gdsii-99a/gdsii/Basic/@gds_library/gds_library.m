function glib = gds_library(lname, varargin);
%function glib = gds_library(lname, varargin);
%
% Constructor for the GDS library class.
% Libraries contain one or more GDS structures.
%
% lname :     a string with the name of the library
% glib :      the library object returned by the constructor
% varargin :  (Optional) one or more library property/value pairs
%                 'layer'  the default layer. Default is 2.
%                 'uunit'  the user unit in m. Default is 1e-6 = 1 um
%                 'dbunit' the database unit in m. Default is 1e-9 = 1 nm
%                 'reflib' a cell array of names of external reference libraries.
%              or a cell array with gds_structure objects    

% Ulf Griesmann, NIST, June 2011

% check arguments
if nargin < 2 && ~ischar(lname) 
   error('gds_library :  first argument is missing or not a string');
end

% default values; the library is implemented as a cell array
glib.lname = lname; % library name
glib.reflibs = [];  % external reference libraries
glib.numst = 0;     % number of structures
glib.st = {};       % cell array of structures
glib.uunit = 1e-6;  % default user unit
glib.dbunit = 1e-9; % default database unit
glib.layer = 1 ;    % default layer

% add the structures to the library
while length(varargin) > 0

   % get element
   st = varargin{1};
   
   if isa(st, 'gds_structure')  % check if a structure
      glib.st{end+1} = st;
      glib.numst = glib.numst + 1;
      varargin(1) = [];
      
   elseif iscell(st)            % check if it is a cell array of structures
      for k = 1:length(st)   
         if ~isa(st{k}, 'gds_structure'); 
            error('gds_library :  can only add structures'); 
         end
      end
      glib.st = [glib.st, st];
      glib.numst = length(glib.st);
      varargin(1) = [];
      
   elseif ischar(st)
      val = varargin{2};   
      switch st
          
        case 'layer'
          glib.layer = val;
          
        case 'uunit'
          glib.uunit = val;
          
        case 'dbunit'
          glib.dbunit = val;
          
        case 'reflibs'
          glib.reflibs = val;
          
        otherwise
          error('gds_library :  invalid keyword');  
          
      end
      varargin(1:2) = [];
      
   else
      error('gds_library :  argument must be GDS structure or cell array of structures.');
   end

end

% create the library object
glib = class(glib, 'gds_library');

return
