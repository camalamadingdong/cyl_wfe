function [name] = wfe_get_test_file_name(date, wg_setup, wg_conn, wave_type, wave_freq, body_setup, body_motions, body_orient, body_damp, run_num, prac_run)

freqstr = num2str(wave_freq, '%4.2f');
freqstr = ['_f' freqstr(1) freqstr(3:4)];

datestr = [date(7:10) date(4:5) date(1:2)];

wavestr = [freqstr '_' wave_type];
endstr = ['_wg' num2str(wg_setup) '_' wg_conn '_' datestr  '_' num2str(run_num)];

if(prac_run)
    endstr = [endstr 'p'];
end
endstr = [endstr '.csv'];

if (strcmp(body_setup, 'NB'))
    name = ['Test_NB' wavestr endstr];
else
    switch body_motions
        case 'Rad'
            name = ['Test_' body_setup '_Rad' freqstr endstr];
        case 'Fix'
            name = ['Test_' body_setup '_Fix_' body_orient wavestr endstr];
        case 'Fre'
            dampstr = num2str(body_damp, '%3.0f');
            dampstr = ['d' dampstr];
            name = ['Test_' body_setup '_Fre_' body_orient '_' dampstr wavestr endstr];
    end
end