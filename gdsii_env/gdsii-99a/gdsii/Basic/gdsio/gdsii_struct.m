function gdsii_struct(gf, sname, cdate);
%function gdsii_struct(gf, sname, cdate);
%
% gdsii_struct :  begin a new structure inside a GDS II library
%
% gf    : file handle returned by gdsii_initialize
% sname : name of the structure up to 32 charactes long
% cdate : optional - creation date
%

% Ulf Griesmann, January 2008
%

% check arguments
if nargin < 3, cdate = []; end;
if nargin < 2
   error('gdsii_struct :  missing argument.');
end

% write the BGNSTR record
fwrite(gf, [28, 1282], 'int16');
dv = datevec(now);           % current date
dv(6) = round(dv(6));        % round to nearest second
dates = zeros(1,12);
if isempty(cdate)
   dates(1:6) = dv;          % creation date
else
   dates(1:6) = cdate;
end
dates(7:12) = dv;            % modification date
fwrite(gf, int16(dates), 'int16');

% write STRNAME 
% pad string with 0 if not an even number of characters long
slen = length(sname);
if mod(slen,2) ~= 0
   sname(end+1) = 0;
   slen = slen + 1;
end
if slen > 32
   error('Structure name too long. Must be <= 32 characters.');
end
fwrite(gf, [slen+4, 1542], 'int16');
fwrite(gf, sname, 'char');
