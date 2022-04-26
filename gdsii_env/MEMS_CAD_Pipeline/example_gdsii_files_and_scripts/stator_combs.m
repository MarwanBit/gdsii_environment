%{
This file is used to generate stator combs associated with the design 
of a MEMS accelerometer.
%}

function gd = stator_combs( ...
    proof_mass_top_left_x,...
    proof_mass_top_left_y,...
    proof_mass_length,...
    proof_mass_width,...
    starting_x, ...
    stator_height, ...
    stator_number, ...
    spacing_constant,...
    gd_structure,...
    write_to_lib)

    %{
        This function takes in info about our proof mass centers position,
        length, and width, alongside the starting x for our stator_combs,
        the height of them, and the number we want per level alongside how
        much we want them to be spaced in order to create our stator_combs

        inputs:
            proof_mass_top_left_x (x coord of top left corner of the proof
            mass)

            proof_mass_top_left_y (y coord of top left corner of the proof
            mass)

            proof_mass_length (length of the proof mass in y direction)

            proof_mass_width (width of the proof mass in x direction)

            starting_x (the displacement from the top left corner of the
            proof mass where we place the left corner of our first stator
            comb)
            
            stator_height (the height of each stator_comb)

            stator_number (the number of stator combs we want on each
            level)

            spacing_constant (the space between comb "partitions")
            %determines how much space you want to be seperated for the capacitive fingers

            gd_structure (the gdsii structure which we append to)

            write_to_lib (determines if we write this to a library or not)

        

        outputs:
            the generation of stator_combs located above and below our
            proofmass, they get appended to the gds_structure element
            passed into the function named gd_structure
    
    %}

    %create new structure for if we want to write to the library 
    temp_gds_return_structure = gds_structure('Stator Combs');
    
    %now based off of the arguments we find the length of the boxs
    %partitioning the stator comb pairs
    box_length = ((proof_mass_width - 2*starting_x)/(stator_number));
    %now define the width of the stator combs
    stator_width = (1/3)*(box_length) - spacing_constant;

    %Now let's loop through and create the stator combs
    for n = 0:stator_number-1
        
        %find the starting_x pos for the stator combs
        starting_distance = proof_mass_top_left_x + starting_x + n*(box_length) + spacing_constant;

        %create the top stator_comb 
        stator_comb_top = 1000*[starting_distance,proof_mass_top_left_y; 
            starting_distance,proof_mass_top_left_y+stator_height; 
            starting_distance+stator_width,proof_mass_top_left_y+stator_height; 
            starting_distance+stator_width,proof_mass_top_left_y; 
            starting_distance,proof_mass_top_left_y];
        
        %now create the bottom stator_comb
        starting_distance_bot = proof_mass_top_left_x + starting_x + n*(box_length)...
                                    + 2*stator_width - spacing_constant;
        %get the y coordinate for the bottom stator_comb
        stator_comb_bot_y = proof_mass_top_left_y - proof_mass_length;
        
        %now create the bottom stator combs
        stator_comb_bot = 1000*[starting_distance_bot,stator_comb_bot_y; 
            starting_distance_bot,stator_comb_bot_y-stator_height; 
            starting_distance_bot+stator_width,stator_comb_bot_y-stator_height; 
            starting_distance_bot+stator_width,stator_comb_bot_y; 
            starting_distance_bot,stator_comb_bot_y];

        %append both stator combs to the gds structure
        gd_structure(end+1) = gds_element('boundary', 'xy',stator_comb_top, 'layer',0);
        gd_structure(end+1) = gds_element('boundary', 'xy',stator_comb_bot, 'layer',0);

        %now make gd the new gd_structure
        gd = gd_structure;

        %use a seperate blank structure to return stator_combs.m if we say
        %write to lib
        if write_to_lib == true
            %append both stator combs to the gds structure
            temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',stator_comb_top, 'layer',0);
            temp_gds_return_structure(end+1) = gds_element('boundary', 'xy',stator_comb_bot, 'layer',0);
        end


    end

    %now let's see if we write to a library
    if write_to_lib == true

        %now create a library to hold this proof mass
        glib = gds_library('stator_combs', 'uunit','1e6', 'dbunit','1e9', temp_gds_return_structure);

        %now write to the file to complete everything
        write_gds_library(glib, '!stator_combs.gds');

    end

end 