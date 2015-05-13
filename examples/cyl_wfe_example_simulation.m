%% Create a 'Simulation' 

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';
f = 1;                  % frequency of interest 
body = 'Fl';            % Flap
body_orient = 'b0';     % Orientation - free runs were done at b0 and b45
wave_type = 'pw';       % plane wave

date = [];              % Leave date empty
run_num = [];           % Leave empty - get all runs
body_damp = 0;          % Should always be 0, was never used
prac_run = false;       % Practive run was used for practice runs, 

%% 1)  Load the 'incident' wave 
body_setup = 'NB';      % Empty tank run to get incident wave
body_motions = 'NB';    
wg_setup = 1;           % Use wg setup 1, because it has the wg at the center, s0
wg_conn = 'sqr';        % sqr has the s0 wg

name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, f, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);

names = dir([file_loc '\' name]);
names = {names.name};

% There are 3 repeat runs - take the first one
irun = 1;
data = wfe_load_data_file([file_loc '\' names{irun}]);
cData = wfe_get_cald_data(file_loc, data);

% s0 is index 17, could also find out with data.WGNames
is0 = 17;
time = data.time;
% This is the incident wave:
iwave = cData(:,is0);

%% 2) Load the force on the body held fixed
body_setup = body;      % Flap
body_motions = 'Fix';   % Fixed
wg_setup = 2;           % Has to be wg setup 2
wg_conn = [];           % Get all run - the force wave collected on all

name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, f, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);

names = dir([file_loc '\' name]);
names = {names.name};

% There are 8 runs - 2 of the run were done when rig was oscillating, the
% problem was fixed by adding guide wires. A waring will occur when you
% load it:

% wfe_load_data_file([file_loc '\' names{6}]);

% But lets just get a different run
irun = 1;
data = wfe_load_data_file([file_loc '\' names{irun}]);
cData = wfe_get_cald_data(file_loc, data);

% Force (Torque) is the last channel, could also find out with data.ChanNames
itor = 23;
torque = cData(:, itor); % Torque is in Nm

%% 3) Load the motions for the freely moving body
body_setup = body;      % Flap
body_motions = 'Fre';   % Fixed
wg_setup = 2;           % Has to be wg setup 2
wg_conn = [];           % Get all run - the force wave collected on all

name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, f, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);

names = dir([file_loc '\' name]);
names = {names.name};

% 6 runs, (two repeats)*(3 wg setups) - can use any
irun = 1;
data = wfe_load_data_file([file_loc '\' names{irun}]);
cData = wfe_get_cald_data(file_loc, data);

% Motion is the last channel, could also find out with data.ChanNames
imot = 23;
motions = cData(:, imot);   % Motions are in degrees

%% Plot it all

tinds = 1921:2241;
figure;

subplot(2,1,1);
ax = plotyy(time(tinds), iwave(tinds), time(tinds), torque(tinds));
title('Incident Wave');
xlabel('Time (s)');
ylabel(ax(1), 'Elevation (cm)');
ylabel(ax(2), 'Torque on Fixed Body (Nm)');

subplot(2,1,2);
plot(time(tinds), motions(tinds));
title('Flap Motions (No Mechancial Forces)');
xlabel('Time (s)');
ylabel('Position (degrees)');