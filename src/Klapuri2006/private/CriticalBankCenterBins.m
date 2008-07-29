function cbBin = CriticalBankCenterBins(fs, K)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% calculate critial bank center bins
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------
halfK = round(K/2);
cbBin = [];
bin = 1;
count = 0;
cb = 0;

while (bin <= halfK)
    count = count + 1;
    cbBin(count) = bin;
    while bin <= cbBin(count)
        cb = cb + 1;
        f = CriticalBankCenterFreq(cb);
        bin = Freq2Bin(f, fs, K);
    end
end

cbBin(count + 1) = bin;
