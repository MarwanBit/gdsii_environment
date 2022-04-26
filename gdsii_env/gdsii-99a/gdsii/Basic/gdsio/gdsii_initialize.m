function [gf] = gdsii_initialize(fname, uunit, dbunit, layer, lname, reflibs);
%function [gf] = gdsii_initialize(fname, uunit, dbunit, layer, lname, reflibs);
%
% gdsii_initialize : this function creates a new file in GDSII stream
%                    format and writes the header section of the file.
%                    The function does NOT start a top level structure.
%
% fname   : name of .gds file to be created. If a file with the 
%           name already exists, the existing file will be renamed,
%           unless the file name begins with a '!'. If the file
%           name begins with '!' an existing file will be overwritten.
% uunit   : (Optional) user unit in meters. Default is 1^-6 (1 um)
% dbunit  : (Optional) database unit in meters. Default is 10^-9 (1 nm)
% layer   : (Optional) default layer for elements. Default = 1
% lname   : (Optional) library name which is stored in the file header. By
%           default, the file name is used as the library name.
% reflibs : (Optional) cell array of strings with names of 
%           referenced libraries. Strings must have <= 44
%           characters, and there can be no more than 15 of them.
%

% Initial version: Ulf Griesmann, NIST, January 2008
% Changed GDS II version number from 3 to 7. Ulf Griesmann, Feb. 2011
% changed user unit to "real" unit in m. Ulf Griesmann, Oct. 2011
% accept library name as an additional argument. U. Griesmann, Jan. 2012
%
% This software is in the Public Domain. 
%

% global variables
global gdsii_uunit;
global gdsii_dbunit;
global gdsii_layer;

% check parameters
if nargin < 2, uunit = []; end;
if nargin < 3, dbunit = []; end;
if nargin < 4, layer = []; end;
if nargin < 5, lname = []; end;
if nargin < 6, reflibs = []; end;
if isempty(uunit), uunit = 1.0e-6; end;
if isempty(dbunit), dbunit = 1.0e-9; end;
if isempty(layer) 
   gdsii_layer = 1;
else
   gdsii_layer = layer;
end;
if gdsii_layer > 255
   error('invalid layer number');
end

% store units for all other functions
gdsii_dbunit = dbunit;
gdsii_uunit  = uunit / dbunit; % store the uunit/dbunit ratio

if fname(1) ~= '!'  % back up existing file
  
   % check if the file already exists
   if exist(fname, 'file')
  
      % find a backup file name
      bakver = 1;
      while 1
         bak_fname = sprintf('%s.%d', fname, bakver);
         if ~exist(bak_fname, 'file')
            break
         else
            bakver = bakver + 1;
         end
      end
   
      % rename the existing file
      if isunix || ismac
         system(sprintf('mv %s %s', fname, bak_fname));
      elseif ispc
         system(sprintf('ren %s %s', fname, bak_fname));
      else
         error('gdsii_initialize :  could not rename existing file.');
      end
      
   end % if exist ...
   
else  % overwrite file if it exists
   fname = fname(2:end);
end

% set default library name
if isempty(lname)
   lname = fname;
end

% open the library file, enable byte swapping
if is_octave()
   omode = 'w';
else  
   omode = 'W'; % enable buffering in MATLAB for ~15% speed increase
end
[gf, msg] = fopen(fname, omode, 'ieee-be');
if gf == -1
   disp(msg);
   error('gdsii_initialize :  could not open GDS II library file.');
end

% write the HEADER record (format version 7 permits 8191 polygon vertices)
fwrite(gf, [6, 2, 7], 'int16');

% write the BGNLIB record
fwrite(gf, [28, 258], 'int16');
dv = datevec(now);           % current date
dv(6) = round(dv(6));        % round to nearest second
dates = zeros(1,12);
dates(1:6) = dv;             % same date for modification
dates(7:12) = dv;            % and access time
fwrite(gf, dates, 'int16');

% write the LIBNAME record
nl = length(lname);
if mod(nl,2) ~= 0
   lname(end+1) = 0;            % pad with zero
   nl = nl + 1;
end
fwrite(gf, [nl+4, 518], 'int16');
fwrite(gf, lname, 'char');      % store filename

% write reflib records
if ~isempty(reflibs)
  
   lr = length(reflibs);
   if lr > 15
      error('gds_initialize :  max. 15 reflibs are allowed.');
   end
   
   fwrite(gf, [4+lr*44, 7942], 'int16'); % REFLIBS record
   for k = 1:lr
      fwrite(gf, sprintf('%-44s', reflibs{k}), 'char');
   end
   
end

% write the UNITS record
fwrite(gf, [20, 773], 'int16'); % UNITS
gdsii_wrtreal8(gf, 1/gdsii_uunit);
gdsii_wrtreal8(gf, gdsii_dbunit);

return


function bo = is_octave()
%
% function to check if we are running on Octave or MATLAB
%
bo = exist('OCTAVE_VERSION')==5;

return
