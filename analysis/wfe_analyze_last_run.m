%% wge_analyze_last_run
load wfe_last_run

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