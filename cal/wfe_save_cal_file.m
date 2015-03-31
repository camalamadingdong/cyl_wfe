function [] = wfe_save_cal_file(folder_path, date, time, cal_type, wg_setup, wg_conn, lc_setting, sp_model, supply_volt, run_num, chan_names, wg_names, notes, levels, cal_vals, cal_vals_std, slopes, intercepts, varargin)

opts = checkOptions({{'WriteLog'}, {'Practice'}}, varargin);

writeLog = opts(1);
prac_run = opts(2);

name = wfe_get_cal_file_name(date, time, cal_type, wg_setup, wg_conn, lc_setting, sp_model, run_num, prac_run);

switch cal_type
    case 'WG'
        fid = fopen([folder_path '\Cal_files\WG\' name], 'w');
        level_type = 'depths';
        level_unit = 'cm';
        top_line = 'Wave Gauge Calibration File';
    case 'LC'
        fid = fopen([folder_path '\Cal_files\Load_cell\' name], 'w');
        level_type = 'forces';
        level_unit = 'N';
        top_line = 'Load Cell Calibration File';
        writeLog = false;
    case 'PO'
        fid = fopen([folder_path '\Cal_files\Position\' name], 'w');
        level_type = 'lengths';
        level_unit = 'cm';
        top_line = 'Position Calibration File';
        writeLog = false;
    otherwise
        error('Calibration type not recognized');
end

if (writeLog && ~prac_run)
    wfe_write_log_cal(folder_path, name, date, time, wg_setup, wg_conn, run_num, notes);
end

[M, N] = size(cal_vals);

wfe_write_header(fid);

fprintf(fid, '%s\n', top_line);
fprintf(fid, 'date, %s\n', date);
fprintf(fid, 'time, %s\n', time);
switch cal_type
    case 'WG'
        fprintf(fid, 'WG setup, %i\n', wg_setup);
        fprintf(fid, 'WG connected, %s\n', wg_conn);
    case 'LC'
        fprintf(fid, 'setting, %s\n', lc_setting);
        fprintf(fid, 'supply voltage, %6.4f\n', supply_volt);
    case 'PO'
        fprintf(fid, 'model, %s\n', sp_model);
        fprintf(fid, 'supply voltage, %6.4f\n', supply_volt);
end
fprintf(fid, 'run notes, %s,\n', notes);
fprintf(fid, 'number of channels, %i,\n', M);
fprintf(fid, 'number of levels, %i,\n', N);

chan_names = textscan(chan_names,'%s','delimiter',',');
chan_names = chan_names{1};
wg_names = textscan(wg_names,'%s','delimiter',',');
wg_names = wg_names{1};

fprintf(fid, '%s (%s),', level_type, level_unit);
for n = 1:N
    fprintf(fid, ' %6.4f,', levels(n));
end
fprintf(fid, '\n');

fprintf(fid, 'channel, name, slope (V/%s), intercept (V), calibration values (V)', level_unit);
for n = 1:N
    fprintf(fid, ' ,');
end
fprintf(fid, 'standard deviation of calibration values (V) \n');

fprintf(fid, ', , , ,');
for n = 1:N
    fprintf(fid, ' %6.4f,', levels(n));
end
for n = 1:N
    fprintf(fid, ' %6.4f,', levels(n));
end
fprintf(fid, '\n');

for m = 1:M
    fprintf(fid, ' %s,', chan_names{m});
    fprintf(fid, ' %s,', wg_names{m});
    fprintf(fid, ' %6.4f, ', slopes(m));
    fprintf(fid, ' %6.4f, ', intercepts(m));
    for n = 1:N
        fprintf(fid, ' %6.4f,', cal_vals(m, n));
    end
    for n = 1:N
        fprintf(fid, ' %6.4f,', cal_vals_std(m, n));
    end
    fprintf(fid, '\n');
end

fclose(fid);
end

