function [] = write_Njord_fronts_file(fileloc, freqs, amps, angles, phases)
% writes the fronts data to a file, which is simply one line for each front
% and 4 values: frequency, amplitude, angle, and phase

Nf = length(freqs);
if ((length(amps) ~= Nf) || (length(angles) ~= Nf) || (length(phases) ~= Nf))
    error('All input vectors must have the same length');
end

fid = fopen(fileloc, 'w');

for n = 1:Nf
    fprintf(fid, '%7.4f, %8.5f, %7.4f, %7.4f\n', freqs(n), amps(n), angles(n), phases(n));
end

fclose(fid);



