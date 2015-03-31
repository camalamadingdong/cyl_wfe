function [name] = wfe_get_cal_file_name(date, time, cal_type, wg_setup, wg_conn, lc_setting, sp_model, run_num, prac_run)

datestr = [date(7:10) date(4:5) date(1:2)];

switch cal_type
    case 'WG'
        name = ['WG_cal_wg' num2str(wg_setup) '_' wg_conn '_' datestr '_' num2str(run_num) '_' time(1:2) time(4:5)];
    case 'LC'
        name = ['LC_cal_' lc_setting '_' datestr '_' num2str(run_num)];
    case 'PO'
        name = ['PO_cal_mod' sp_model '_' datestr '_' num2str(run_num)];
    otherwise
        error('Calibration type not recognized');
end

if (prac_run)
    name = [name 'p'];
end

name = [name '.csv'];