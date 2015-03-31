function [inds] = meanUpCross(y)

y0 = y - mean(y);

N = length(y0);

inds = -1;

m = 1;
for n = 2:N
    if ((y0(n) > 0) && (y0(n-1) <=0))
        inds(m) = n;
        m = m + 1;
    end
end
    

