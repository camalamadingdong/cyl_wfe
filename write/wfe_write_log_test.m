function [] = wfe_write_log_test(folder_path, test_name, date, time, wg_setup, wg_conn, wave_type, wave_freq, body_setup, body_motions, body_orient, body_damp, run_num, notes)


name = 'wfe_run_log.csv';
full_name = [folder_path '\' name];

if (~exist(full_name, 'file'))
    wfe_start_log(folder_path);
end

fid = fopen(full_name, 'a');

%fprintf(fid, 'Description, File name, Date, Time, Body setup, Body motions, Body orientation, Body damping, Frequency, Wave type, WG setup, WG connected, Run number, Notes\n');
fprintf(fid, 'Test, %s, %s, %s, %s, %s, %6.2f, %6.2f, %6.2f, %s, %i, %s, %i, %s\n', test_name, date, time, body_setup, body_motions, body_orient, body_damp, wave_freq, wave_type, wg_setup, wg_conn, run_num, notes);

fclose(fid);