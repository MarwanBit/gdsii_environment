%In this matlab file we will write the code which will be used to generate
%the cage for our accelerometer...

function cage = generate_cage( ...
    gd_structure,...
    write_to_lib)
    
    %{
    This function generates a cage for our accelerometer
    %}

    %create new structure for if we want to write to the library 
    temp_gds_return_structure = gds_structure('accelerometer cage');

    %now we generate the bounding box for the structure
    [boundary_box_cage, ref] = bbox(gd_structure);

    %now we see if we get the boundary box and append it to gd_structure
    llx = boundary_box_cage(1);
    lly = boundary_box_cage(2);
    urx = boundary_box_cage(3);
    ury = boundary_box_cage(4);
    width = urx - llx;
    length = ury - lly;

    cage_box = 1000*[
        llx,lly;
        llx,lly+length;
        llx+width,lly+length;
        llx+width,lly;
        llx,lly;   
        ];

    cage_box = gds_element('boundary', 'xy',cage_box, 'layer',0);

    %now let's go through each element in the current structure and take
    %the piecewise difference:
    
    %first create a list which will store these new elements
    element_array = get(gd_structure);
  
    element_array(1)
    cage_box
    cage_box = minus(cage_box, element_array(1));

    %now after the piecewise or is done we will append each element in
    %differences list to our gd_structure
    gd_structure(end+1) = cage_box;
    
    %if we decided to write to lib we'll write to the temp gds
    %structure aswell
    if write_to_lib == True
        temp_gds_return_structure(end+1) = cage_box;
    end

   


    %now we've done it :)

   
    %now let's consider the case where we want to write to our library
    if write_to_lib == true
        %if we want to write to library add this structure to our
         %temp_structure
         glib = gds_library('cage', 'uunit','1e6', 'dbunit','1e9', temp_gds_return_structure);
         %now we write this library
         write_gds_library(glib, '!cage.gds');
    
    end


end


    

