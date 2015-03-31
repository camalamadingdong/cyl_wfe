function [sub_path] = wfe_get_subpath(name)

body_setup = name(6:7);
if (strcmp(body_setup, 'NB'))
    sub_path = 'No_body';
else
    if (strcmp(body_setup, 'Fl'))
        sub_path = 'Flap';
    elseif (strcmp(body_setup, 'At'))
        sub_path = 'Attenuator';
    else
        error('Body type not recognized');
    end
    
     body_motions = name(9:11);
     
     if (strcmp(body_motions, 'Fix'))
         sub_path = [sub_path '\Fixed'];
    elseif (strcmp(body_motions, 'Rad'))
        sub_path = [sub_path '\Radiating'];
     elseif (strcmp(body_motions, 'Fre'))
         sub_path = [sub_path '\Free'];
    else
        error('Body motions not recognized');
    end
end