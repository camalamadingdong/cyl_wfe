%% 1) Use an analyze data function to analyze a run
% Creates plots of every wave gauge measured in the run, and a summary plot
% Used during the testing as an error check

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

name = 'Test_At_Fix_b0_f125_div_wg2_cir_20141024_2.csv';

% Only begin the analysis after 40 seconds
startT = 40;

wfe_analyze_data(file_loc, name, 'StartTime', startT);

%% 2) Use an analyze data function to analyze a calibration
% Creates plots of every wave gauge measured in the cal
% Used during the testing as an error check

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

name = 'WG_cal_wg2_sqr_20141111_2_1501.csv';

wfe_analyze_cal(file_loc, name)

%% 3) Analyze and plot a specific chanel

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

name = 'Test_At_Fix_b0_f125_div_wg2_cir_20141024_2.csv';

data = wfe_load_data_file([file_loc, '\', name]);
cData = wfe_get_cald_data(file_loc, data);

startT = 40;

t = data.time;
sampleFreq = data.SampleFreq;

iChan = 4;

if (strcmp(data.ChanNames{iChan}, 'Position'))
    wgForPos = 'Pos';
elseif (strcmp(data.ChanNames{iChan}, 'Force'))
    wgForPos = 'For';
else
    wgForPos = 'WG';
end

% f is the measured frequency
% a is the measured amplitude (maginitude, no phase)
% a2 is the measured second order amplitude
% ep is the measured phase
[f, a, a2, ep] = wfe_analyze_chan(cData(:,iChan), t, startT, sampleFreq, data.ChanNames{iChan}, data.WGNames{iChan}, wgForPos);


%% 4) Analyze a chanel - no plots

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

name = 'Test_At_Fix_b0_f125_div_wg2_cir_20141024_2.csv';

data = wfe_load_data_file([file_loc, '\', name]);
cData = wfe_get_cald_data(file_loc, data);
sampleFreq = data.SampleFreq;

startT = 40;

iChan = 4;

% f is the measured frequency
% a is the measured amplitude (maginitude, no phase)
% ep is the measured phase
% off is the offset from 0
% S is the spectrum (Fourier transform)
% freqs are the frequency values of the spectrum
% a2 is the measured second order amplitude
% ep2 is the measured second order phase
[f, a, ep, off, S, freqs, a2, ep2] = wfe_compute_sig_vals(sampleFreq, cData(:,iChan), 'StartTime', startT);


%% 5 Use the TestData
% A TestData object loads all the runs 
% (runs 1,2 (maybe 3), and cir, sqr, str) related to a particular set of
% conditions then find the mean complex amplitudes of the measurements of
% the WG and body motions

file_loc = 'N:\RDS\Cylindrical_wave_field_experiments\Raw_data';

% Required Arguments
body = 'Flap';      % Body Type:        'Flap', 'Atten', 'None'
f = 1;              % Frequency:        0.8, 1, 1.25

% Conditionally optional arguments
% For example, if the body = 'None', then don't need motion or orient
% or if the motion = 'Rad', then don't need orient or wave
% wgSetup is only required for body = 'None'
motion = 'Fix';     % 'Motion' (body motion):       'Fix', 'Rad', 'Free'
orient = 0;         % 'Orient', (body orientation): 0, 22.5, 45, 67.5, 90, -22.5, -45, -67.5
wave = 'Plane';     % 'Wave', (incident wave):      'Plane', 'Diverge', 'Focus', 'Random'
wgSetup = 1;        % 'WGSetup' (wave gauge setup): 1, 2

% Optional arguments
% startT = 40       % 'StartTime', If no, start time, then default is 40


data = TestData(file_loc, body, f, 'Motion', motion, 'Wave', 'Plane', 'Orient', orient);

% Then values of the Force or Wave Gauges can be accessed
F = data.Force;     % Again, this is the complex amplitude of the Force (N) averaged over all runs

% The wave gauge values are accessed by specifying which WGs are desired
eta = data.WaveAmps('all'); % Get all of the wave gauge values (cm) - average
pos = data.WGPos('all');    % Get the position (m) of the wave gauges

figure;
scatter3(pos(:,1), pos(:,2), abs(eta), 'Marker', '.');
xlabel('meters');
ylabel('meters');
zlabel({'Wave Amplitude','centimeters'});
title('Flap fixed, Diffracted wave field, 1 Hz Plane Wave');

hold on;
% Draw body
bx = [-0.04 -0.04 -0.04 -0.04 -0.04];
by = [0.3 -0.3 -0.3 0.3 0.3];
bz = 100*[0.1 0.1 -0.4 -0.4 0.1];
plot3(bx, by, bz);
plot3(-bx, by, bz);
plot3([-0.04 0.04], [0.3 0.3], 100*[0.1 0.1]);
plot3([-0.04 0.04], -[0.3 0.3], 100*[0.1 0.1]);
plot3([-0.04 0.04], [0.3 0.3], -100*[0.4 0.4]);
plot3([-0.04 0.04], -[0.3 0.3], -100*[0.4 0.4]);

view(gca,[-25.5 42]);

annotation('arrow', 'X', [0.2 0.3], 'Y', [0.57 0.6],...
                'HeadWidth', 5, 'HeadLength', 5);
                        
annotation('textbox', 'String', 'Incident Direction', 'Position', [0.1 0.46 0.1 0.1],'LineStyle', 'none');


        