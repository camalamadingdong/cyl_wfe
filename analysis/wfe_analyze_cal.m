function [] = wfe_analyze_cal(folder_path, name, varargin)

[opts, args] = checkOptions({{'Chans',1}}, varargin);

type = name(1:2);

switch type
    case 'WG'
        xlab = 'Depth (cm)';
    case 'LC'
        xlab = 'Force (N)';
    case 'PO'
        xlab = 'Length (cm)';
    otherwise
        error('Cal file not recognized');
end

cal_file = [folder_path, '\', name];

calData = wfe_load_cal_file(cal_file);

slopes = calData.Slopes;
intercepts = calData.Intercepts;
levels = calData.Levels;
calVals = calData.CalValues;
stdCalVals = calData.StdCalValues;

N = length(slopes);

if (opts(1))
    ichans = zeros(1,N);
    ichans(args{1}) = 1;
else
    ichans = ones(1,N);
end

M = sum(ichans);

m = 1;
for n = 1:N
    if (ichans(n))
        if (M < 3)
            figure;
        else
            im = mod(m,4);
            if (im == 0)
                im = 4;
            end
            if (im == 1)
                figure;
            end
            subplot(2,2,im);
            m = m + 1;
        end
        wfe_analyze_cal_chan(slopes(n), intercepts(n), levels, calVals(n,:), stdCalVals(n,:), 'ChanName', calData.ChanNames{n}, 'WGName', calData.WGNames{n}, 'xlabel', xlab);
    end
end
