%In this Matlab/ GDSII file we will be creating a gds structure
%which violates the edge to edge/ center_to_center overlay rules
%by having on metal circular etch over another :)

%first let's start by clearing vars and creating a top level structure
clear all 

%create top level struct
gd_structure = gds_structure('PMETL to SOI Violation');

%Now let's go ahead and try to create some circle in the SOI layer
SOI_arc_object.r = 100;
SOI_arc_object.c = [0,0];
SOI_arc_object.a1 = 0;
SOI_arc_object.a2 = 360;
SOI_arc_object.w = 100;
SOI_arc_object.e = 2;

%now let's add this to the structure
gd_structure(end+1) = gdsii_arc(SOI_arc_object, 10);


%Now let's go ahead and try to create som circle in the PMETL layer
%(violation if within 6um of each other)
PMETL_arc_object.r= 99;
PMETL_arc_object.c= [0,500];
PMETL_arc_object.a1 = 0;
PMETL_arc_object.a2 = 360;
PMETL_arc_object.w = 100;
PMETL_arc_object.e = 2;
PMETL_arc = gdsii_arc(PMETL_arc_object, 5);

%now let's add this to the structure
gd_structure(end+1) = PMETL_arc;


%create our library to hold the accelerometer structures
glib = gds_library('PMETL_to_SOI_Violation');
glib(end+1) = gd_structure;


%Now we write the file to complete everything....
write_gds_library(glib, '!virgil.gds');
