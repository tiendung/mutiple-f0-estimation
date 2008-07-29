function coefs = SubbandCompresionCoefs(cbBins, X)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% calculate subband compression coefficients
% INPUT
%   cbBins: center bank bins
%   X: spectrum magnitude
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------
E = X.^2;           % spectrum energy
K = length(E);
halfK = round(K/2);
len = length(cbBins);
coefs = zeros(1, cbBins(len));
v = 0.33;
for i = 2 : len - 1
    [first, center, last, range] = SubbandParameters(i);
    Hb = TriangleFilter(first, center, last, halfK);
    subbandE = Hb(range).*E(range);
    std = (1/K * sum(subbandE))^0.5; % standard deviation of subband energy
    coefs(center) = std^(v - 1);
end
    
    function [first, center, last, range] = SubbandParameters(i)
        first = cbBins(i-1);
        center = cbBins(i);
        last = cbBins(i+1);
        range = first : last;
    end

end