%{
This file is used for the development of rotor combs associated with
the design of a MEMS accelerometer.
%}


function gd = rotor_combs( ...
    proof_mass_bottom_left_x,...
    proof_mass_bottom_left_y,...
    proof_mass_length,...
    proof_mass_width,...
    rotor_comb_numb, ...
    rotor_comb_length, ...
    end_stopper_width, ...
    gd_structure,...
    spacing_constant,...
    write_to_lib)

    %{
        This function takes in info about our proof mass centers position,
        length, and width, alongside number of rotor combs we want on each
        side, the height of them, and there length and then we generate
        rotor combs which should attach to the proof mass

        inputs:
            proof_mass_bottom_left_x (the x coord of the bottom left corner
            of the proof mass)

            proof_mass_bottom_left_y (the y coord of the bottom left corner
            of the proof mass)

            proof_mass_length (the length in the y direction of the proof
            mass)

            proof_mass_width (the length in the x direction of our proof
            mass)
    
            rotor_comb_numb (the number of rotor combs on each side that
            are desired)

            rotor_comb_length (the length of these rotor combs)

            end_stopper_width (the width between the rotor comb closest to
            the end of the proof mass and the end of the proof mass)

            gd_structure (the gdsii structure which we append to)
    
            spacing_constant (the distance from the tip of the rotor comb
            to the first rung)

            write_to_lib (determines if we write this to a library or not)

        

        outputs:
            the generation of rotor combs located on either side of our
            proof mass...
    
    %}

    %create new structure for if we want to write to the library 
    temp_gds_return_structure = gds_structure('Rotor Combs');

    %now let's calculate some fundamental constants 
    box_length = proof_mass_length/rotor_comb_numb;
    effective_box_length = box_length - end_stopper_width;
    rotor_comb_width = (1/6)*effective_box_length;

    %Now loop through and create the rotor combs on each end of the spring mass
    for n=0:rotor_comb_numb-1
        starting_distance = proof_mass_bottom_left_y + (effective_box_length-rotor_comb_width)/2 + n*box_length;

        %generate the base of the rotor comb (left side)
        rotor_comb = 1000*[proof_mass_bottom_left_x, starting_distance; 
            proof_mass_bottom_left_x-rotor_comb_length,starting_distance; 
            proof_mass_bottom_left_x-rotor_comb_length,starting_distance+rotor_comb_width; 
            proof_mass_bottom_left_x,starting_distance+rotor_comb_width; 
            proof_mass_bottom_left_x,starting_distance];
        gd_structure(end+1) = gds_element('boundary', 'xy',rotor_comb, 'layer',0);

        %now generate the base of the rotor combs on the right side
        rotor_comb_right = 1000*[proof_mass_bottom_left_x+proof_mass_width, starting_distance; 
            proof_mass_bottom_left_x+proof_mass_width+rotor_comb_length,starting_distance; 
            proof_mass_bottom_left_x+proof_mass_width+rotor_comb_length,starting_distance+rotor_comb_width; 
            proof_mass_bottom_left_x+proof_mass_width,starting_distance+rotor_comb_width; 
            proof_mass_bottom_left_x+proof_mass_width,starting_distance];
        gd_structure(end+1) = gds_element('boundary', 'xy',rotor_comb_right, 'layer',0);




        if write_to_lib == true
            %if we want to write to library add this structure to our
            %temp_structure
            temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',rotor_comb, 'layer',0);
            temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',rotor_comb_right, 'layer',0);
        end

        %Now we generate the combs attached to each rotor_comb
        for i = 0:3

            comb_starting_x = proof_mass_bottom_left_x -rotor_comb_length + i*((1/4)*(1/3)*rotor_comb_length) + spacing_constant;
            comb_length = (1/3)*(effective_box_length);
            comb_width = (1/3)*(((1/4)*(1/3)*rotor_comb_length));
    
            %now we create the combs on the top...
            top_comb = 1000*[comb_starting_x,starting_distance+rotor_comb_width; 
            comb_starting_x,starting_distance+rotor_comb_width+comb_length; 
            comb_starting_x+comb_width,starting_distance+rotor_comb_width+comb_length; 
            comb_starting_x+comb_width,starting_distance+rotor_comb_width; 
            comb_starting_x,starting_distance+rotor_comb_width];
            gd_structure(end+1) = gds_element('boundary', 'xy',top_comb, 'layer',0);

            %now we create the combs on the top for the right rotor comb...
            new_starting_x =  proof_mass_bottom_left_x +proof_mass_length  - i*((1/4)*(1/3)*rotor_comb_length) - spacing_constant;
            top_comb_right = 1000*[new_starting_x,starting_distance+rotor_comb_width; 
            new_starting_x,starting_distance+rotor_comb_width+comb_length; 
            new_starting_x-comb_width,starting_distance+rotor_comb_width+comb_length; 
            new_starting_x-comb_width,starting_distance+rotor_comb_width; 
            new_starting_x,starting_distance+rotor_comb_width];
            gd_structure(end+1) = gds_element('boundary', 'xy',top_comb_right, 'layer',0);

            if write_to_lib == true
                %if we want to write to library add this structure to our
                %temp_structure
                 temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',top_comb, 'layer',0);
                 temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',top_comb_right, 'layer',0);
            end
    
            %now create the bottom combs...
            bottom_comb = 1000*[comb_starting_x,starting_distance; 
            comb_starting_x,starting_distance-comb_length; 
            comb_starting_x+comb_width,starting_distance-comb_length; 
            comb_starting_x+comb_width,starting_distance; 
            comb_starting_x,starting_distance];
            gd_structure(end+1) = gds_element('boundary', 'xy',bottom_comb, 'layer',0);

            %now we create the combs on the top for the right rotor comb...
            new_starting_x =  proof_mass_bottom_left_x +proof_mass_length - i*((1/4)*(1/3)*rotor_comb_length) - spacing_constant;
            bottom_comb_right = 1000*[new_starting_x,starting_distance; 
            new_starting_x,starting_distance-comb_length; 
            new_starting_x-comb_width,starting_distance-comb_length; 
            new_starting_x-comb_width,starting_distance; 
            new_starting_x,starting_distance];
            gd_structure(end+1) = gds_element('boundary', 'xy',bottom_comb_right, 'layer',0);

            if write_to_lib == true
                %if we want to write to library add this structure to our
                %temp_structure
                 temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',bottom_comb, 'layer',0);
                 temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',bottom_comb_right, 'layer',0);
            end
    
    
        end

    end

    %save results to gd
    gd = gd_structure;

    %now let's consider the case where we want to write to our library
    if write_to_lib == true
        %if we want to write to library add this structure to our
         %temp_structure
         glib = gds_library('rotor_combs', 'uunit','1e6', 'dbunit','1e9', temp_gds_return_structure);
         %now we write this library
         write_gds_library(glib, '!rotor_combs.gds');
    end

        



end 