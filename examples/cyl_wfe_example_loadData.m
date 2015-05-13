%% 0 - Load log file 
% The log file contains a log of all of the non-practice runs

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

log = wfe_read_log(file_loc);


%% 1 - Load a raw data from a particular run into Matlab
                        
% Options for a data set,(Format/options)
date = '27/10/2014';    % day/mon/year

wg_setup = 2;           % 1, 2 (any run with a body must be 2)
wg_conn = 'sqr';        % cir, sqr, star
wave_type = 'div';      % pw, foc, div, rand
wave_freq = 1;          % 0.8, 1, 1.25 (Hz)

body_setup = 'At';      % NB, At, Fl (for No body, Attenuator or Flap)
body_motions = 'Fix';   % NB, Fix, Rad, Fre
body_orient = 'b0';     % bn675, bn45, bn225, b0, b225, b45, b675, b90 
                        % (for -67.5, -45, -22.5, 0, 22.5, 45, 67.5, 90 degrees)
body_damp = 0;          % Should always be 0, was never used

run_num = 1;            % 1, 2, or sometimes 3

prac_run = false;       % Practive run was used for practice runs, these end
                        % with the letter p

% Gets the name of a given data file 
name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, wave_freq, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);

% the location of the raw data files
file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';
file_to_get = [file_loc '\' name];

% Loads all the data from the .csv into a structure
% If data == -1, then the file was not found.
[data] = wfe_load_data_file(file_to_get);

% calibration the data
[cData] = wfe_get_cald_data(file_loc, data);

chanInd = 3;
figure;
subplot(2,1,1);
plot(data.time, data.Data(:,chanInd));
xlabel('Time (s)');
ylabel('Raw Signal (Volts)');
title(['Wave Gauge: ' data.WGNames{chanInd}]);

subplot(2,1,2);
plot(data.time, cData(:,chanInd));
xlabel('Time (s)');
ylabel('Calibrated Signal (cm)');

%% 2 - Load all files in a group of runs/wgs (ignoring the date)

% Options for a data set,(Format/options)
date = [];          % If you don't know the date, make it an empty cell

wg_setup = 2;           % 1, 2 (any run with a body must be 2)
wg_conn = [];           % Load all wg runs
wave_type = 'div';      % pw, foc, div, rand
wave_freq = 1;          % 0.8, 1, 1.25 (Hz)

body_setup = 'At';      % NB, At, Fl (for No body, Attenuator or Flap)
body_motions = 'Fix';   % NB, Fix, Rad, Fre
body_orient = 'b0';     % bn675, bn45, bn225, b0, b225, b45, b675, b90 
                        % (for -67.5, -45, -22.5, 0, 22.5, 45, 67.5, 90 degrees)
body_damp = 0;          % Should always be 0, was never used

run_num = [];            % 1, 2, or sometimes 3

prac_run = false;       % Practive run was used for practice runs, these end
                        % with the letter p

% Gets the name of a given data file 
name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, wave_freq, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

names = dir([file_loc '\' name]);
names = {names.name};

figure;
Nrun = length(names);
chanInd = 3;

for n = 1:Nrun
    namen = names{n};
    [data] = wfe_load_data_file([file_loc '\' namen]);
    [cData] = wfe_get_cald_data(file_loc, data);
    
    subplot(Nrun, 1, n);
    plot(data.time, cData(:,chanInd));
    title(['WGs Conn: ' data.WGConn ', Run: ' namen(end-4) ', WG: ' data.WGNames{chanInd}]);
    ylabel('(cm)');
    
    if (n == Nrun)
        xlabel('Time (s)');
    end   
end


%% 3.01 - Load a wg cal file directly

date = '04/11/2014'; 
time = '13:17'; 
cal_type = 'WG'; 
wg_setup = 2; 
wg_conn = 'cir'; 

lc_setting = [];
sp_model = [];

run_num = 1;

prac_run = false;

calName = wfe_get_cal_file_name(date, time, cal_type, wg_setup, wg_conn, lc_setting, sp_model, run_num, prac_run);

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';
calData = wfe_load_cal_file([file_loc '\' calName]);

%% 3.02 - or Load wg cal file from a run

date = '27/10/2014';    

wg_setup = 2;          
wg_conn = 'sqr';        
wave_type = 'div';      
wave_freq = 1;          

body_setup = 'At';      
body_motions = 'Fix';   
body_orient = 'b0';    

body_damp = 0;          

run_num = 1;            

prac_run = false;      

% Gets the name of a given data file 
testName = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, wave_freq, ...
    body_setup, body_motions, body_orient, body_damp, run_num, prac_run);


file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

data = wfe_load_data_file([file_loc '\' testName]);
calName = data.WGCalFile;

calData = wfe_load_cal_file([file_loc '\' calName]);



%% 3.1 Plot Cal Values for a particurlar WG - run Section 3.01 or 3.02 first

chanInd = 3;

slope = calData.Slopes(chanInd);
intercept = calData.Intercepts(chanInd);
levels = calData.Levels;
calVals = calData.CalValues(chanInd, :);
stdCalVals = calData.StdCalValues(chanInd, :);

titl = [calData.ChanNames{chanInd} ' (' calData.WGNames{chanInd} ')'];

deltaL = levels(end) - levels(1);

startX = levels(1) - 0.1*deltaL;
stopX = levels(end) + 0.1*deltaL;

x = linspace(startX, stopX, 100);
y = slope*x + intercept;

plot(levels, calVals, 'LineStyle', 'none', 'Marker', '*');
hold on;
plot(x,y, 'k--');
set(gca, 'xlim', [startX stopX]);
title(titl);
ylabel('Voltage (V)');
xlabel('Wave Elevation (cm)');



