function [rlen, rtype] = gdsii_record_info(gf);
%
% return the first two 16-bit words of a GDS file record
%
% rlen :   number of bytes in record data without record header
% rtype :  type id consisting of record type (low byte) and data
%          type (high byte). In practice, different record types use 
%          only one data type and the two can be treated as one id. 

rinfo = fread(gf, 2, 'uint16');
rlen  = rinfo(1)-4;  % remaining record bytes left to read
rtype = rinfo(2);    % record type and data type

return
