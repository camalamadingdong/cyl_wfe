function [pos] = wfe_get_wg_pos(wgSetup, wgNames)
% Returns the (x,y) position(s) of the wave gauges specified by the name or
% list of names. 
%
%   wgSetup - integer, 1 or 2 to indicate the experimental setup
%   wgNames - cell array of strings to indicate the names
%       e.g. {'s1','c2','s0'}

file_path = 'wave_gauge_locs.csv';
wgs = wfe_load_wg_pos(file_path);

if (wgSetup == 1)
    posAll = wgs.Pos1;
elseif (wgSetup == 2)
    posAll = wgs.Pos2;
else
    error('WG setup value not valid');
end

N = length(wgNames);
pos = zeros(N, 2);

for n = 1:N
    isWG = cellfun(@(x) strcmp(wgNames{n}, x), wgs.Names);
    if (sum(isWG) == 1)
        pos(n,:) = posAll(isWG,:);
    end
end

