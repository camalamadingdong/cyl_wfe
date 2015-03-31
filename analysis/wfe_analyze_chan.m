function [f, a, a2, ep] = wfe_analyze_chan(data, t, startT, sampleFreq, chanName, wgName, wgForPos, varargin)

[opts, args] = checkOptions({{'NoPlot'}, {'TestName',1}}, varargin);

% compute values
[f, a, ep, off, S, freqs, a2, ep2] = wfe_compute_sig_vals(sampleFreq, data, 'StartTime', startT, varargin{:});

if (~opts(1))
    figure;

    % get proper labels
    if (strcmp(wgForPos, 'Pos'))
        unit = ' deg';
        timeLabl = 'Position (deg)';
        specLabl = 'Amplitude Spectrum (deg)';
    elseif (strcmp(wgForPos, 'For'))
        unit = ' N';
        timeLabl = 'Forces (N)';
        specLabl = 'Amplitude Spectrum (N)';
    else
        unit = ' cm';
        timeLabl = 'Elevation (cm)';
        specLabl = 'Amplitude Spectrum (cm)';
    end


    % write out values
    subplot(2,2,1)

    box on;
    set(gca, 'xlim', [0 1], 'ylim', [0 1], 'xtick', [], 'ytick', [])

    if (opts(2))
        textLab = {[args{2}],[]};
    else
        textLab = {};
    end
    textLab = {textLab{:}, [chanName ' (' wgName ')'],...
        [], ...
        ['f = ' num2str(f, '%5.2f\n') ' Hz'], ...
        [],...
        ['a = ' num2str(a, '%5.2f\n') unit], ...
        [],...
        ['a2/a = ' num2str(a2/a, '%3.3f\n')], ...
        [],...
        ['epsilon = ' num2str(180/pi*ep, '%3.0f\n') ' deg']};
    text(0.1, 0.5, textLab,...
        'FontSize', 14, 'FontWeight', 'bold');
        axis off

    % envelope
    origSig = data.';

    subplot(2,2,2)
    plot(t, origSig);
    hold on;
    [iUp, iDown] = meanCrossPeaks(origSig);

    plot(t(iUp), origSig(iUp), 'k');
    plot(t(iDown), origSig(iDown), 'k');
    xlabel('Time (s)');
    ylabel(timeLabl);

    % plot close up of signal with linear and second order fit
    linSig = a*cos(2*pi*f*t + ep);
    secSig = linSig + a2*cos(2*2*pi*f*t + ep2);

    % just 2 seconds in the middle of the run
    trun = 2;
    startT2 = (t(end) - startT)/2;
    [~, startI] = min(abs(t - startT2));
    stopT = startT2 + trun; 
    if (stopT > t(end))
        stopT = t(end);
    end
    [~, stopI] = min(abs(t - stopT));

    subplot(2,2,3)
    plot(t(startI:stopI), origSig(startI:stopI), 'Linewidth', 2);
    hold on;
    plot(t(startI:stopI), linSig(startI:stopI), 'Color', [0 0.5 0]);
    plot(t(startI:stopI), secSig(startI:stopI), 'k--');

    legend({'Data', 'Linear', 'Second Order'});
    xlabel('Time (s)');
    ylabel(timeLabl);
    set(gca, 'xlim', [t(startI) t(stopI)]);

    % plot Spectrum
    subplot(2,2,4)
    plot(freqs, abs(S));

    xlabel('Frequency (Hz)');
    ylabel(specLabl);
    set(gca, 'xlim', [0 5]);
end