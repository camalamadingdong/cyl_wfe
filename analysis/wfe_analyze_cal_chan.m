function [] = wfe_analyze_cal_chan(slope, intercept, levels, calVals, stdCalVals, varargin)
% Analyzes (plots) a single chanel of a linear calibration (points with 
% error bars, and the calibration line). 

[opts, args] = checkOptions({{'ChanName', 1}, {'WGName', 1}, {'xlabel', 1}}, varargin);

titl = [];
if (opts(1))
    titl = args{1};
end

if (opts(2))
    if (isempty(titl))
        titl = args{2};
    else
        titl = [titl ' (' args{2} ')'];
    end
end

xlab = '';
if (opts(3))
    xlab = args{3};
end

deltaL = levels(end) - levels(1);

startX = levels(1) - 0.1*deltaL;
stopX = levels(end) + 0.1*deltaL;

x = linspace(startX, stopX, 100);
y = slope*x + intercept;

errorbar(levels, calVals, stdCalVals, 'LineStyle', 'none', 'Marker', '.');
hold on;
plot(x,y, 'k--');
set(gca, 'xlim', [startX stopX]);
title(titl);
ylabel('Voltage (V)');
xlabel(xlab);