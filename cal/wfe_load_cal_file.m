function [calData] = wfe_load_cal_file(file_path)

fid = fopen(file_path, 'r');

headlen = wfe_write_header();
delim = ',';

for n = 1:(headlen+1)
    fgetl(fid);
end

inds = strfind(file_path, '\');
type = file_path(inds(end)+(1:2));

switch type
    case 'WG'
        calData.Description = 'Wave Gauge Calibration Data';
    case 'LC'
        calData.Description = 'Load Cell Calibration Data';
    case 'PO'
        calData.Description = 'Position Calibration Data';
    otherwise
        error('Cal file not recognized');
end

C = textscan(fgetl(fid),'%s','delimiter',delim);
calData.Date = C{1}{2};
C = textscan(fgetl(fid),'%s','delimiter',delim);
calData.Time = C{1}{2};

C1 = textscan(fgetl(fid),'%s','delimiter',delim);
C2 = textscan(fgetl(fid),'%s','delimiter',delim);

switch type
    case 'WG'
        calData.WGSetup = str2double(C1{1}{2});
        calData.WGConn = C2{1}{2};
    case 'LC'
        calData.Setting = C1{1}{2};        
        calData.SupplyVoltage = str2double(C2{1}{2});
    case 'PO'
        calData.Model = C1{1}{2};
        calData.SupplyVoltage = str2double(C2{1}{2});
end

C = textscan(fgetl(fid),'%s','delimiter',delim);
Nnote = length(C{1}) - 1;
for n = 1:Nnote
    calData.RunNotes{n} = C{1}{n+1};
end

val = textscan(fgetl(fid),'%s','delimiter',',');
M = str2double(val{1}{2});
calData.ChannelCount = M;

val = textscan(fgetl(fid),'%s','delimiter',',');
N = str2double(val{1}{2});

slopes = zeros(1, M);
intercepts = zeros(1, M);

lin = fgetl(fid);
val = textscan(lin,'%s','delimiter',',');
levels = zeros(1, N);
for n = 1:N
    levels(n) = str2double(val{1}{n+1});
end

fgetl(fid);
fgetl(fid);
calVals = zeros(M, N);
stdCalVals = zeros(M, N);

for m = 1:M;
    lin = fgetl(fid);
    vals = textscan(lin,'%s','delimiter',',');
    vals = vals{1};
    calData.ChanNames{m} = vals{1};
    calData.WGNames{m} = vals{2};
    slopes(m) = str2double(vals{3});
    intercepts(m) = str2double(vals{4});
    for n = 1:N
       calVals(m,n) = str2double(vals{4+n});
       stdCalVals(m,n) = str2double(vals{4+N+n});
    end
end

calData.Slopes = slopes;
calData.Intercepts = intercepts;
calData.Levels = levels;
calData.CalValues = calVals;
calData.StdCalValues = stdCalVals;

fclose(fid);
end
