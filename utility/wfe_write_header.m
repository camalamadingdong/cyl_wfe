function [nline] = wfe_write_header(varargin)

nline = 4;

if(~isempty(varargin))
    fid = varargin{1};
    fprintf(fid, 'J.C. McNatt 2014 Wave Field Experiments\n');
    fprintf(fid, 'Performed in the University of Edinburgh Curved Wave Tank\n');
    fprintf(fid, 'Copyright 2014 by J. Cameron McNatt\n');
    fprintf(fid, 'Licensed under the Creative Commons Attribution License (CC BY)\n');
end
    