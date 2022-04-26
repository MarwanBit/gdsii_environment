function write_gds_library(glib, fname, verbose);
%function write_gds_library(glib, fname, verbose);
% 
% write_gds_library :
%     writes a GDS library object to a file
%
% glib  :    a gds_library object
% fname :    (Optional) a file name. This argument overrides 
%            the library name stored in the gds_library object.
% verbose :  (Optional) when == 1, print out information about the 
%            library. When > 1 the top level structures are also 
%            printed out. Default is 1 (medium verbose).
%

% Ulf Griesmann, NIST, November 2011

% check and get file name
if nargin < 3, verbose = []; end
if nargin < 2 || isempty(fname)    % no file name specified
   fname = glib.lname;             % use the library name
   if length(fname) < 4 || ~strcmp(fname(end-3:end), '.gds')
      fname = [fname, '.gds'];
   end
end

if isempty(verbose), verbose = 1; end

% check if all structure names are unique
N = cellfun(@(x)sname(x), glib.st, 'UniformOutput',0); % structure names
if length(N) ~= length(unique(N))
   error('write_gds_library :  structure names are not unique.');
end

if verbose == 1
   fprintf('\nLibrary name  : %s\n', glib.lname);
   fprintf('User unit     : %g m\n', glib.uunit);
   fprintf('Database unit : %g m\n', glib.dbunit);
   fprintf('Structures    : %d\n\n', glib.numst);
end

% top level structures
if verbose > 1
   fprintf('Top level: ');
   tls = topstruct(glib);
   if iscell(tls)
      for k=1:length(tls)
         fprintf('%s  ', tls{k});
      end
   else
      fprintf('%s', tls);
   end
   fprintf('\n\n');
end

% start time
t_start = now();

% initialize the library file
gf = gdsii_initialize(fname, glib.uunit, glib.dbunit, glib.layer, ...
                      glib.lname, glib.reflibs );

% write all structures in library to file
cellfun(@(x)write_structure(x,gf), glib.st);

% close file
gdsii_finalize(gf);

% end time
if verbose == 1
   t_el = now() - t_start;  % elapsed time in days
   fprintf('Write time: %s\n\n', datestr(t_el, 'HH:MM:SS.FFF'));
end

return
