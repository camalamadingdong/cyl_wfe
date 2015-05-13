function [log] = wfe_read_log(file_loc)

log_name = 'wfe_run_log.csv';

fid = fopen([file_loc '\' log_name]);
N = 13;
header = textscan(fid, '%s',N,'Delimiter',',');
header = header{1};

formatSpec = '%s %s %s %s %s %s %s %s %s %s %s %s %s';
runs1 = textscan(fid,formatSpec,'Delimiter',',');
Nrun = length(runs1{1});
runs = cell(Nrun, N);
for m = 1:Nrun
    for n = 1:N
        if ((n == 7) || (n == 8) || (n == 10) || (n == 12))
            runs{m,n} = str2num(runs1{n}{m});
        else
            runs{m,n} = runs1{n}{m};
        end
    end
end

log.header = header';
log.runs = runs;
log.Nrun = Nrun;

fclose(fid);