function [] = wfe_write_log_cal(folder_path, cal_name, date, time, wg_setup, wg_conn, run_num, notes)

name = 'wfe_run_log.csv';
full_name = [folder_path '\' name];

if (~exist(full_name, 'file'))
    wfe_start_log(folder_path);
end

fid = fopen(full_name, 'a');

fprintf(fid, 'Calibration, %s, %s, %s, , , , , , , %i, %s, %i, %s\n', cal_name, date, time, wg_setup, wg_conn, run_num, notes);

fclose(fid);