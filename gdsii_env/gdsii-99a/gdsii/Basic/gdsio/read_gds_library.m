function [glib] = read_gds_library(gdsname, verbose, hdronly);
%function [glib] = read_gds_library(gdsname, verbose, hdronly);
%
% read_gds_library :  
%        Reads a GDS II file and returns its structures
%        and elements as a gds_library object. Can also be 
%        used to read and display the header portion of a 
%        GDS II file.
%
% gdsname :  name of a GDS II file to read (with or without .gds extension).
% verbose :  when > 0, print out information about the file and
%            structure names during reading. Default is 1 (verbose).
% hdronly :  when > 0, only the header information will be displayed and 
%            the header structure will be returned. Implies verbose = 1. 
%            Default is 0.
% glib :     library object with GDS elements and structures
%

% Initial version, Ulf Griesmann, NIST, November 2011

% check arguments
if nargin < 3, hdronly = []; end
if nargin < 2, verbose = []; end
if nargin < 1 
   error('missing file name');
end
if ~nargout & ~hdronly
   error('missing output argument');
end

% set defaults
if isempty(hdronly), hdronly = 0; end
if hdronly, verbose = 1; end
if isempty(verbose), verbose = 0; end

% open file for reading
[gf, msg] = fopen(gdsname, 'r', 'ieee-be');  % NOTE BYTE ORDER
if gf == -1
   gdsname = [gdsname, '.gds'];
   [gf, msg] = fopen(gdsname, 'r', 'ieee-be');
   if gf == -1
      fprintf('%s\n',msg);
      error('gdsii_read :  could not open GDS II library file.');
   end
end 

% start time
t_start = now();

% read the library information records
ldata = gdsii_read_libdata(gf);
fprintf('\nLibrary name  : %s\n', ldata.libname);
fprintf('Creation date : %d-%d-%d, %02d:%02d:%02d\n', ldata.creation_date);
fprintf('User unit     : %g m\n', ldata.uunit);
fprintf('Database unit : %g m\n', ldata.dbunit);

% return if only header display
if hdronly
   return
end

% create the library object
glib = gds_library(ldata.libname, 'uunit',ldata.uunit, 'dbunit', ldata.dbunit);

% read all structures
if verbose
   fprintf('Structures    :\n');
end

% element counter
tnel = 0;

while 1
  
  [rlen, rtype] = gdsii_record_info(gf);
  switch rtype
    
   case 1024 % ENDLIB
      break
  
   case 1282 % BGNSTR - beginning of structure
      glib(end+1) = gdsii_read_struct(gf);  % read structure
      tnel = tnel + numel(glib(end));
      if verbose                            % print structure information
         fprintf('%d ... %s (%d)\n', numst(glib), sname(glib(end)), numel(glib(end)) );
      end
      
   otherwise
      fclose(gf); % something is wrong - get out
      error('invalid GDS file - ENDLIB or BGNSTR expected.');
  end
  
end

% close the GDS file
fclose(gf);

% end time
t_el = now() - t_start;  % elapsed time in days

% print statistical information
fprintf('\nRead time  : %s\n', datestr(t_el, 'HH:MM:SS.FFF'));
fprintf('Structures : %d\n', numst(glib));
fprintf('Elements   : %d\n', tnel);
if verbose
   fprintf('Top level: ');
   tls = topstruct(glib);
   if iscell(tls)
      for k=1:length(tls)
         fprintf('%s  ', tls{k});
      end
   else
      fprintf('%s\n', tls);
   end
end
fprintf('\n');

return
