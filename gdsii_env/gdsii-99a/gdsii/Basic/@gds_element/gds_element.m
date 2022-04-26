function gelm = gds_element(etype, varargin);
%function gelm = gds_element(etype, varargin);
%
% gds_element :  Constructor for the GDS element class. It creates the 
%                elements of a GDS II layout: boundary, box, path, text, 
%                node, structure reference (sref), and array reference (aref).
%
% gelm :       element object created by the constructor
% etype :      a string with one of the GDS II elements: boundary,
%              path, box, aref, sref, text, node. 
% varargin :   EITHER a list of property, value pairs
%              OR a structure with ALL element properties - no
%              error checking ! This provides a fast way to create
%              elements that is used internally by the gdsii file
%              read functions.
%
% Example :    be = gds_element('boundary', 'xy',poly, 'layer',5);
%  
%          Properties common to all elements:
%          ==================================
%             elflags : a string with 'T' for template data and/or
%                       'E' for exterior data. This flag is 
%                       omitted by default.
%             plex :    a number used for grouping of
%                       elements. Omitted by default.
%             prop :    a structure array with property number and property name pairs.
%                           prop(k).attr : 1 .. 127
%                           prop(k).name : string.
%                       The total number of bytes for all properties in the structure
%                       array must not exceed 128, or 512 in the case of sref and aref
%                       elements.
%             layer :   GDS layer for the element EXCEPT SREF and AREF, which
%                       have no layer property (default is 2).
%             
%           Element specific properties:
%           ============================
%
%             Boundary element:
%             -----------------
%                xy :    a cell array of N x 2 matrices containing the vertices
%                        of a one or more closed polygons. 
%                dtype : data type number 0 .. 255. Default is 0.
%                        Forms a layer specification together with 
%                        the layer.
%                nume :  number of polygons in the boundary element
%
%             Path element:
%             -------------
%                xy :    a cell array of N x 2 matrices of vertex coordinates 
%                        along the path describing one or more paths.
%                dtype : data type number 0 .. 255. Default is 0.
%                        Forms a layer specification together with 
%                        the layer.
%                ptype : path type 0,1, 2, or 4. Default is 0.
%                width : width of the path in user units
%                        Negative numbers imply absolute widths 
%                        unaffected by scaling.
%                ext :   path extension for type 4 paths.
%                        ext.beg - square extension at path beginning
%                        ext.end - square extension at path end
%                nume :  number of path segements in the path element
%
%             Box element:
%             ------------
%                xy :    5 x N matrix of closed rectangular
%                        polygon.
%                btype : a box type 0 .. 255
%
%             Node element:
%             -------------
%                ntype : node type, a number 0 .. 255. Default is 0.
%                xy   :  up to 50 node coordinates
%
%             Text element:
%             -------------
%                text :  a text string
%                xy :    text location in user units  
%                ttype : text type, a number 0 .. 63. Default
%                             is 0.
%                font :  text font 0 .. 3. Default is 0
%                verj :  vertical justification; 0 = top, 1 =
%                        middle, 2 = bottom. Default is 0.
%                horj :  horizontal justification. 0 = left, 1
%                        = center, 2 = right. Default is 0.
%                ptype : path type. Default is 1.
%                width : width of line for drawing text in
%                        user units (obsolete)
%                height: text height to use when text is rendered
%                        with boundary elements. 
%                        Default is 10 user units.
%                strans: an strans record which describes text
%                        transformations. Omitted by default. 
%
%             Sref element(s):
%             ----------------
%                xy :    N x 2 list of coordinates in user
%                        units.
%                sname : Name of the referenced structure
%                strans: strans record for transforming the
%                        structure.
%
%             Aref element:
%             -------------
%                xy :    3 x 2 list of coordinates in user
%                        units.
%                          xy(1,:) :  origin
%                          xy(2,:) :  lower right corner
%                          xy(3,:) :  upper left corner
%                sname : Name of the referenced structure
%                strans: strans record for transforming the
%                        structure.
%                adim :  number of rows and columns in the array
%                           adim.row : number of rows
%                           adim.col : number of columns
%
%              NOTE:
%              =====
%
%                 strans : structure transformation parameters
%                 --------------------------------------------
%                 strans.reflect : if this is set (=1), the element is
%                                  reflected about the x-axis prior to
%                                  rotation. Default is 0.
%                 strans.absmag  : if set to 1, specifies absolute
%                                  magnification. Default is 0.
%                 strans.absang  : if set to 1, specifies absolute angle.
%                                  Default is 0.
%                 strans.mag     : magnification factor for structure.
%                                  Default is 1.
%                 strans.angle   : rotation angle for structure in degrees.
%                                  Default is 0.
%

% Ulf Griesmann, NIST, June 2011

% check arguments
if ~ischar(etype)
   error('gds_element :  wrong type of first argument.');
end

% get element properties
if isstruct(varargin{1})  % properties are passed in a structure
  
   data = varargin{1};
   
else  % collect all arguments into a structure

   if rem(length(varargin), 2) ~= 0
      error('gds_element :  must have at least one property/value argument pair.');
   end
   
   data = parse_element_data(etype, varargin);

end

% create the element object
elmo.etype = etype;
elmo.data  = data;
gelm = class(elmo, 'gds_element');

return;
