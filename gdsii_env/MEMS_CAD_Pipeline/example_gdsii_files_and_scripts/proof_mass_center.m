%in this matlab file we create the box which will be the proof mass center
%where we define a function which takes in a length, width, and starting
%position for the bottom left corner


function proofmassobj = proof_mass_center(width, length, bottom_left_x, bottom_left_y, write_to_lib)
    %{
        This function takes a width, length an bottom_left_pos(tuple) and
        returns the proofmassobj

        inputs:
            width (just some float determining width in the y direction).
            length (just some float determining the length in the x
            direction).
            bottom_left_x (x coord of bottom left corner)
            bottom_left_y (y coord of bottom left corner)

        output:
            proofmassobj (the gdsii object, we also write to a library)
    %}

    %first create a top level gds structure
    gd = gds_structure('proof mass center');

    %creates a box of 3000um * 2000um consistent with dimensions in the paper
    proofmassobj = 1000*[
        bottom_left_x,bottom_left_y; 
        bottom_left_x,bottom_left_y+width; 
        bottom_left_x+length,bottom_left_y+width; 
        bottom_left_x+length,bottom_left_y; 
        bottom_left_x,bottom_left_y
    ]; 
    %now we add the proof mass center inside the gds_structure
    gd(end+1) = gds_element('boundary', 'xy',proofmassobj, 'layer',0);

    %if we're told to write than write
    if write_to_lib == true

        %now create a library to hold this proof mass
        glib = gds_library('proofmasscenter', 'uunit','1e6', 'dbunit','1e9', gd);

        %now write to the file to complete everything
        write_gds_library(glib, '!proofmasscenter.gds');
    
    end

    
end

