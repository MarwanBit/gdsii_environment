%This document is for experimenting with gdsii/ trying to create an obj...
%Let's try to just make some simple object and then experiment with using 
%other built in objects within the toolbox.

clear all

%Now create the library...
glib = gds_library('my_first_gdsii_example');

%creates our top-level structure
gd = gds_structure('Example Structure');

%Now let's create some elements to put within our top-level structure...
% arc shaped element
arc.r = 400;        % inside radius of arc
arc.c = [0,500];    % arc center
arc.a1 = 0;         % arc angles
arc.a2 = pi;
arc.w = 100;        % arc width
arc.e = 2;          % approximation error


%Now let's add this circle to the gd, add gd to some library and then write
%the library creating the structure...
gd(end+1) = gdsii_arc(arc, 1);

%Now write the structure into the library
glib(end+1) = gd;

%Now let's write the file!!
write_gds_library(glib, 'my_first_gdsii_example.gds');
