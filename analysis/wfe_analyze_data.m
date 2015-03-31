function [fs, as, a2s, eps, alerts] = wfe_analyze_data(folder_path, name, varargin)

[opts, args] = checkOptions({{'StartTime',1}, {'Chans',1}, {'NoPlot'}}, varargin);
noPlot = opts(3);

data_file = [folder_path, '\', wfe_get_subpath(name), '\', name];
data = wfe_load_data_file(data_file);

N = data.ChannelCount;
t = data.time;
sampleFreq = data.SampleFreq;

% get the start time
if (opts(1))
    startT = args{1};
else
    startT = t(1);
end

if(startT >= t(end))
    error('Start time is longer that run time');
end

% use only selected channels (or all channels)
if (opts(2))
    ichans = zeros(1,N);
    ichans(args{2}) = 1;
else
    ichans = ones(1,N);
end

% calibrate data
cData = wfe_get_cald_data(folder_path, data);

% Analyze data
M = sum(ichans);
fs = zeros(1,M);
as = zeros(1,M);
eps = zeros(1,M);
a2s = zeros(1,M);

m = 1;
for n = 1:N
    if (ichans(n))
        if (strcmp(data.ChanNames{n}, 'Position'))
            wgForPos = 'Pos';
        elseif (strcmp(data.ChanNames{n}, 'Force'))
            wgForPos = 'For';
        else
            wgForPos = 'WG';
        end
        if (noPlot)
            [f, a, a2, ep] = wfe_analyze_chan(cData(:,n), t, startT, sampleFreq, data.ChanNames{n}, data.WGNames{n}, wgForPos, 'NoPlot');
        else
            [f, a, a2, ep] = wfe_analyze_chan(cData(:,n), t, startT, sampleFreq, data.ChanNames{n}, data.WGNames{n}, wgForPos);
        end
        fs(m) = f;
        as(m) = a;
        a2s(m) = a2;
        eps(m) = ep;
        m = m + 1;
    end
end

alerts = zeros(1,M);
meanF = mean(fs);
meanA = mean(as);
for m = 1:M
   if ((fs(m) < 0.9*meanF) || (fs(m) > 1.1*meanF))
      alerts(m) = 1;
   end
   if ((as(m) < 0.4*meanA) || (as(m) > 1.6*meanA))
      alerts(m) = 1;
   end
   if (a2s(m)/as(m) > 0.3)
     alerts(m) = 1;
   end
end

wgNames = data.WGNames;
pos = wfe_get_wg_pos(data.WGSetup, wgNames);

minX = min(pos(:,1));
maxX = max(pos(:,1));
delX = maxX - minX;
xlim = [minX-0.2*delX maxX+0.2*delX];

minY = min(pos(:,2));
maxY= max(pos(:,2));
delY = maxY - minY;
ylim = [minY-0.2*delY maxY+0.2*delY];

minA = min(as);
maxA = max(as);
meanA = mean(as);
delA = maxA - minA;
alim = [minA-0.1*delA maxA+0.1*delA];

figure;
if (delY == 0)
    stem(pos(:,1), as);
    hold on;
    plot(pos(:,1), as, 'k--');
    axis equal
    xlabel('x (m)');
    ylabel('Wave Amp (cm)');
    if (delX ~= 0)
        set(gca, 'xlim', xlim, 'ylim', alim);
    end
else
    % find lines
    lines = 1;
    n = 2;
    lastWG = wgNames{1};
    for m = 2:M
        thisWG = wgNames{m};
        if (~strcmp(thisWG(1), lastWG(1)))
            % compare the first letter, if not the same, then new line
            lines(n) = m;
            n = n + 1;
        elseif (strcmp(thisWG(1), 's'))
            % if the first letter is s, then need to check the second
            % too
            if (~strcmp(thisWG(1:2), lastWG(1:2)))
                % if first two letters not the same, then new line
                lines(n) = m;
                n = n + 1;
            end
        end
        lastWG = thisWG;
    end
    lines(end+1) = M + 1;
    stem3(pos(:,1), pos(:,2), as);
    hold on;
    for n = 2:length(lines)
        line = lines(n-1):(lines(n)-1);
        plot3(pos(line, 1), pos(line, 2), as(line), 'k--');
    end
    surf([xlim(1) xlim(1); xlim(2) xlim(2)], [ylim(1) ylim(2); ylim(1) ylim(2)], [meanA meanA; meanA meanA])
    alpha(0.4);
    axis equal
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('Wave Amp (cm)');
    set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', alim);
end

