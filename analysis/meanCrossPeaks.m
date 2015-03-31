function [iUp, iDown] = meanCrossPeaks(y)

iMeanX = meanUpCross(y);

N = length(iMeanX);

iUp = zeros(1, N-1);
iDown = zeros(1, N-1);

for n = 2:N
    [~, iMax] = max(y(iMeanX(n-1):iMeanX(n)));
    iUp(n-1) = iMeanX(n-1) + iMax - 1;
    [~, iMin] = min(y(iMeanX(n-1):iMeanX(n)));
    iDown(n-1) = iMeanX(n-1) + iMin - 1;
end