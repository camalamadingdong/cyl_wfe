function [wgs] = wfe_load_wg_pos(file_path)
% Loads the names and coordinates of the wave gauges from a .csv file.

fid = fopen(file_path, 'r');
delim = ',';

headlen = wfe_write_header();

for n = 1:headlen+3
    fgetl(fid);
end

n = 1;
while (~feof(fid))
    C = textscan(fgetl(fid),'%s','delimiter',delim);
    C = C{1};
    
    wgs.Names{n} = C{1};
    
    x = str2double(C{4});
    y = str2double(C{5});
    wgs.Pos1(n,:) = [x y];
    
    x = str2double(C{8});
    y = str2double(C{9});
    wgs.Pos2(n,:) = [x y];
    n = n + 1;
end