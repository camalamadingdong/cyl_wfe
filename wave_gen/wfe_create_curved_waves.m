% This script is used to create the curved wave for the wave field 
% experiments. It uses the EDesign's Njordr wave synthesizer software's
% 'Wave fronts' specification, which creates a wave by combining plane wave
% components with different: amplitude, frequency, direction, and phase. In
% this case, all component will have the same frequency. 

%% 0 - User define parameters
freq = 1.25;                        % frequency (Hz);
origin = [0 0];                 % position of the origin
randPhase = false;                   % random phase?
if (any(origin ~= [0 0]))
    randPhase = false;
end

% 0-1 other pertinent parameters
a = 0.08;                            % wave amplitude
s = 10;                         % spreading parameter (cos^2s)

freqstr = num2str(freq);
idot = strfind(freqstr, '.');
if (~isempty(idot))
    freqstr = [freqstr(1:(idot-1)) freqstr(idot+1:end)];
end

xstr = num2str(origin(1));
idot = strfind(xstr, '.');
if (~isempty(idot))
    xstr = [xstr(1:(idot-1)) xstr(idot+1:end)];
end

ystr = num2str(origin(2));
idot = strfind(ystr, '.');
if (~isempty(idot))
    ystr = [ystr(1:(idot-1)) ystr(idot+1:end)];
end

fileName = ['wave_front_f' freqstr '_x' xstr '_y' ystr];       % name of the wave fronts file
if (randPhase)
    fileName = [fileName '_rand'];
end

% 1 - define the spreading function

Ntheta = 4096;   
dtheta = 2*pi/Ntheta;
theta = -pi:dtheta:(pi-dtheta); % directions

% Based on a cos^2s spread, which is for the energy density spectrum. We
% want to the amplitude spectrum, which is sqrt(cos^2s) = cos^s
S = cos(1/2*(theta)).^(s);
normS = trapz(theta,S);
S = S./normS;

S = a*S;

% If ypos ~= 0, modify the spectrum so that its origin is at another
% location

if (any(origin ~= [0 0]))
    h = 1.18;
    k = solveForK(2*pi*freq, h);
    L = sqrt(origin(1)^2 + origin(2)^2);
    alpha = atan2(origin(2), -origin(1));  
    
    S = S.*exp(-1i*k*L*cos(alpha - theta));
end

% 2 - discrtize the spread into plane waves
Nbeta = 25;
angLim = pi/180*80;
dbeta = 2*angLim/Nbeta;               % only directions from -pi/3:pi/3;
beta = (-angLim+dbeta/2):dbeta:(angLim-dbeta/2);    % mid points

AsC = interp1(theta, S, beta);          % complex amplitude
AsC = AsC*dbeta;
As = abs(AsC);                          % real amplitudes
if (randPhase)
    phases = 2*pi*rand(size(As));
else
    phases = angle(AsC);                    % phases
    ineg = find(phases < 0);
    phases(ineg) = 2*pi + phases(ineg);
end

% Plot
figure;
subplot(3,1,1);
plot(theta/pi*180, abs(S));
set(gca, 'xlim', [-180 180]);
xlabel('degrees')
ylabel('Abs(S)');

subplot(3,1,2);
stem(beta/pi*180, As);
set(gca, 'xlim', [-180 180]);
xlabel('degrees');
ylabel('abs(As)');

subplot(3,1,3);
stem(beta/pi*180, phases);
set(gca, 'xlim', [-180 180]);
xlabel('degrees')
ylabel('phase(As)');

% 3 - write file

fileloc = ['C:\Users\s1213969\Dropbox\matlab\experiment\wave_gen\' fileName '.csv'];

freqs = freq*ones(size(As));

write_Njord_fronts_file(fileloc, freqs, As, beta, phases);

