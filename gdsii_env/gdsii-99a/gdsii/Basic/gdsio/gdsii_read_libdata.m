function [ldata] = gdsii_read_libdata(gf);
%
% read the first records of a GDS II library
% file containing meta data and return
% a structure with the data.
%

% global variables
global gdsii_uunit;
global gdsii_dbunit;

% set defaults
ldata.reflibs = [];
ldata.fonts = [];
ldata.attrtable = [];

% HEADER record
[rlen, rtype] = gdsii_record_info(gf);
if rtype ~= 2
   error('invalid HEADER record.');
end
ldata.libver = fread(gf, 1, 'int16');

% BGNLIB record
[rlen, rtype] = gdsii_record_info(gf);
if rtype ~= 258
   error('invalid BGNLIB record.');
end
dates = fread(gf, 12, 'int16');
ldata.creation_date = dates(1:6);
ldata.modification_date = dates(7:12);

% LIBNAME record
[rlen, rtype] = gdsii_record_info(gf);
if rtype ~= 518
   error('invalid LIBNAME record');
end
ldata.libname = gdsii_read_string(gf, rlen);

% now come optional records (except UNITS)
recn = 0;
while recn <= 10
  
  % get next record
  [rlen, rtype] = gdsii_record_info(gf);
  
  switch rtype
  
   case 773   % UNITS
             uunit = gdsii_readreal8(gf);  % stored before dbunit
      ldata.dbunit = gdsii_readreal8(gf);
      ldata.uunit  = ldata.dbunit / uunit; % actual user unit
      gdsii_uunit  = 1 / uunit;            % stores the multiplier
      gdsii_dbunit = ldata.dbunit;

      % UNITS is the last record in the header section - return
      return
      
   case 7942  % REFLIBS
      nrl = rlen/44;
      ldata.reflibs = cell(1,nrl);
      for k=1:nrl
         ldata.reflibs{k} = gdsii_read_string(gf, 44);
      end
  
   case 8198  % FONTS
      nfn = rlen/44;
      ldata.fonts = cell(1,nfn);
      for k=1:nfn
         ldata.fonts{k} = gdsii_read_string(gf, 44);
      end
  
   case 8966  % ATTRTABLE
      fprintf('>>> Ignoring record type ATTRTABLE in header (%d data bytes)\n', rlen);
      ignore = fread(gf, rlen, '*uint8'); 
  
   case 8706  % GENERATIONS
      ldata.generations = fread(gf, 1, 'int16');
  
   otherwise
      fprintf('>>> Ignoring unknown record type 0x%x in header (%d data bytes)\n', rtype, rlen);
      ignore = fread(gf, rlen, '*uint8'); 

  end
  
  recn = recn + 1;

end

error('fatal error - no UNITS record found');

return
