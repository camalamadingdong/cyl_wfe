function [data] = wfe_load_data_file(file_path)

data.Description = 'Test Data';

headlen = wfe_write_header();
delim = ',';

try 
    dataVals = importdata(file_path, delim, headlen + 22);
catch
    data = -1;
    return
end

C = textscan(dataVals.textdata{headlen+2},'%s','delimiter',delim);
data.Date = C{1}{2};
C = textscan(dataVals.textdata{headlen+3},'%s','delimiter',delim);
data.Time = C{1}{2};

C = textscan(dataVals.textdata{headlen+7},'%s','delimiter',delim);
bodyset = C{1}{2};
data.BodySetup = C{1}{2};
if (strcmp(bodyset, 'NB'))
    data.BodyMotions = '';
    data.BodyOrient = [];
    data.BodyDamping = [];
else
    C = textscan(dataVals.textdata{headlen+8},'%s','delimiter',delim);
    data.BodyMotions = C{1}{2};
    C = textscan(dataVals.textdata{headlen+9},'%s','delimiter',delim);
    data.BodyOrient = str2double(C{1}{2});
    C = textscan(dataVals.textdata{headlen+10},'%s','delimiter',delim);
    data.BodyDamping = str2double(C{1}{2});
end

C = textscan(dataVals.textdata{headlen+11},'%s','delimiter',delim);
data.WaveType = C{1}{2};
C = textscan(dataVals.textdata{headlen+12},'%s','delimiter',delim);
data.WaveFreq = str2double(C{1}{2});

C = textscan(dataVals.textdata{headlen+4},'%s','delimiter',delim);
data.WGSetup = str2double(C{1}{2});
C = textscan(dataVals.textdata{headlen+5},'%s','delimiter',delim);
data.WGConn = C{1}{2};
C = textscan(dataVals.textdata{headlen+6},'%s','delimiter',delim);
data.WGCalFile = C{1}{2};

C = textscan(dataVals.textdata{headlen+13},'%s','delimiter',delim);
data.SampleFreq = str2double(C{1}{2});
C = textscan(dataVals.textdata{headlen+14},'%s','delimiter',delim);
data.RunTime = str2double(C{1}{2});

C = textscan(dataVals.textdata{headlen+15},'%s','delimiter',delim);
Nnote = length(C{1}) - 1;
for n = 1:Nnote
    data.RunNotes{n} = C{1}{n+1};
end

C = textscan(dataVals.textdata{headlen+16},'%s','delimiter',delim);
Nchan = str2double(C{1}{2});
data.ChannelCount = Nchan;
C1 = textscan(dataVals.textdata{headlen+19},'%s','delimiter',delim);
C2 = textscan(dataVals.textdata{headlen+21},'%s','delimiter',delim);
for n = 1:Nchan
    data.ChanNames{n} = C1{1}{n};
    data.WGNames{n} = C2{1}{n};
end

C = textscan(dataVals.textdata{headlen+17},'%s','delimiter',delim);
data.SampleCount = str2double(C{1}{2});

data.dt = 1/data.SampleFreq;
time = 0:data.dt:(data.SampleCount - 1)*data.dt;
data.time = time;

data.Data = dataVals.data;


if (strcmp(data.Date, '06/11/2014'))
    if (strcmp(data.BodySetup, 'Fl'))
        if (strcmp(data.BodyMotions, 'Fix'))
            warning('Data may not be good - rig was oscillating during testing. The problem was fixed later. Look for test on different day');
        end
    end
end

clear dataVals;