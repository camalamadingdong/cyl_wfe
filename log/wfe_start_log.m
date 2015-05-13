function [] = wfe_start_log(folder_path)

name = 'wfe_run_log.csv';
full_name = [folder_path '\' name];

if (~exist(full_name, 'file'))
    fid = fopen(full_name, 'w');
    fprintf(fid, 'Description, File name, Date, Time, Body setup, Body motions, Body orientation, Body damping, Frequency, Wave type, WG setup, WG connected, Run number, Notes\n');
    fclose(fid);
end
