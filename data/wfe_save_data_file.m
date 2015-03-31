function [] = wfe_save_data_file(folder_path, date, time, wg_setup, wg_conn, wave_type, wave_freq, body_setup, body_motions, body_orient, body_damp, run_num, chan_names, wg_names, sample_freq, run_time, wg_cal_file, notes, data, varargin)

opts = checkOptions({{'WriteLog'}, {'Practice'}}, varargin);

writeLog = opts(1);
prac_run = opts(2);

name = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, wave_freq, body_setup, body_motions, body_orient, body_damp, run_num, prac_run);
fid = fopen([folder_path '\', wfe_get_subpath(name), '\' name], 'W');

if (strcmp(body_setup, 'NB'))
    body_motions = '';
    body_orient = '';
    body_damp = 0;
end

switch (body_orient)
    case 'b0'
        body_orient = 0;
    case 'b225'
        body_orient = 22.5;
    case 'b45'
        body_orient = 45;
    case 'b675'
        body_orient = 67.5;
    case 'b90'
        body_orient = 90;
    case 'bn225'
        body_orient = -22.5;
    case 'bn45'
        body_orient = -45;
    case 'bn675'
        body_orient = -67.5;
    otherwise
        body_orient = [];
end

switch body_motions
    case 'Rad'
        body_orient = 0;
        body_damp = 0;
    case 'Fix'
        body_damp = 0;
end

if (writeLog && ~prac_run)
    wfe_write_log_test(folder_path, name, date, time, wg_setup, wg_conn, wave_type, wave_freq, body_setup, body_motions, body_orient, body_damp, run_num, notes);
end

[M, N] = size(data);

wfe_write_header(fid);

fprintf(fid, 'Test Results File\n');
fprintf(fid, 'date, %s\n', date);
fprintf(fid, 'time, %s\n', time);

fprintf(fid, 'WG setup, %i\n', wg_setup);
fprintf(fid, 'WG connected, %s\n', wg_conn);
fprintf(fid, 'WG calibration file, %s,\n', wg_cal_file);

fprintf(fid, 'body setup, %s\n', body_setup);
fprintf(fid, 'body motions, %s\n', body_motions);
fprintf(fid, 'body orientation, %4.1f\n', body_orient);
fprintf(fid, 'body damping, %3.0f\n', body_damp);

fprintf(fid, 'wave type, %s\n', wave_type);
fprintf(fid, 'wave frequency, %4.2f\n', wave_freq);

fprintf(fid, 'sample frequency (Hz), %6.2f\n', sample_freq);
fprintf(fid, 'run time (s), %6.2f\n', run_time);

fprintf(fid, 'run notes, %s,\n', notes);

fprintf(fid, 'number of channels, %i,\n', M);
fprintf(fid, 'number of data points, %i,\n', N);

chan_names = textscan(chan_names,'%s','delimiter',',');
chan_names = chan_names{1};
wg_names = textscan(wg_names,'%s','delimiter',',');
wg_names = wg_names{1};

fprintf(fid, 'channels (below)\n');
for m = 1:M
    fprintf(fid, ' %s,', chan_names{m});
end
fprintf(fid, '\nwg names (below)\n');
for m = 1:M
    fprintf(fid, ' %s,', wg_names{m});
end

fprintf(fid, '\ndata (V) (below)\n');

for n = 1:N
    for m = 1:M
        fprintf(fid, ' %6.4f,', data(m, n));
    end
    fprintf(fid, '\n');
end

fclose(fid);
end

