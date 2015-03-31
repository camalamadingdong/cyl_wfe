%% wge_analyze_a_run
save_loc = 'S:\RDS\McNatt_wf_experiments\Raw_data';

name1 = 'Test_Fl_Fre_b0_d0_f080_pw_wg2_cir_20141113_2.csv';
name2 = 'Test_NB_f100_pw_wg2_star_20141119_4.csv';

name = name2;

if (strcmp(name(4:6), 'cal'))
    isCal = true;
else
    isCal = false;
end

chans = [];
startT = 0;

if (isempty(chans))
    if (isCal)
        wfe_analyze_cal(save_loc, name)
    else
        wfe_analyze_data(save_loc, name, 'StartTime', startT);
    end
else
    if (isCal)
        wfe_analyze_cal(save_loc, name, 'Chans', chans)
    else
        wfe_analyze_data(save_loc, name, 'Chans', chans, 'StartTime', startT);
    end
end