% standalone motor generation script
clear;clc;
global VREP_ignore s_motor joints
VREP_ignore=1;
root='motor';

% load default motor parameters
% TT is for tintoy motor (low force/higher reliability)
% Flik is for gen 2 flik motors (high force, lower reliability)
load Motor_TT
%load Motor_Flik

% load default layer properties
default_layer_properties_dc;

h_motor.layer=[SOI, SOIHOLE];
h_motor.pos = [0 0];
h_motor.N = 70;
h_motor.travel = 2000;
h_motor.angle = 0;                 %Angle of shuttle in degrees
h_motor.hopper_shuttle_extend = 1; % Extend shuttle for etch hole alignment
h_motor.label = 'moto11';
h_motor.circle_etch_holes = 0;
h_motor.num_inch_sets = 2;
h_motor.ground_serpentine = 1;
[m1 moto_pts]= motor(h_motor);

% Create a top level structure
ts = gds_structure('TOP');
ts = add_ref(ts, m1);  % add sref elements to top level

% Create a library to hold the structure
glib = gds_library('lib',m1,ts);

% Finally write the library to a file, looking first for other files names
% the same thing and incrementing the appended digit if need be. 
ending = '.gds';
str = sprintf('%s*%s',root,ending);
a = dir([str]);
suffix = [];
if ~isempty(a)
    k = [];
    for ii=1:length(a)
        k = [k str2num(strtok(strtok(a(ii).name,'.'),root))];
    end
    if isempty(k)
        suffix = 1;
    else
        suffix = max(k)+1;
    end
end

write_gds_library(glib, [root num2str(suffix) ending]);