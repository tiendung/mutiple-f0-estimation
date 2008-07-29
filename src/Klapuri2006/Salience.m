function [sa, ha] = Salience(T, U, deltaT, g)
% [sa, ha] = Salience(T, U, deltaT, g)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Calculate salience value of period T defined in formula (3)
% Klapuri, "Multiple Fundamental Frequency Estimation by Summing Harmonic Amplitudes", 2006
% INPUT
%   T: period (in samples)
%   U: short-time spectrum magnitude
%   g: g function in the paper
% OUTPUT
%   sa: salience value of period T
%   ha: corresponding harmonic partials
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------

% init paramters
halfK = length(U);  % number of frequency bins
K = 2*halfK;        % number of sample after zero-padding

lower = K/(T + deltaT / 2);
upper = K/(T - deltaT / 2);
haNum = floor(T/2);
ha = struct('pos',{},'amp',{},'vicLow',{},'vicUp',{});
sa = 0;

% find harmonic partials
for j = 1 : haNum
    ha(j).vicLow = round(j*lower);
    ha(j).vicUp = min(round(j*upper), halfK);
    vicinity = ha(j).vicLow : ha(j).vicUp;
    
    % calculate salience value of T in formula (3)
    [value, index] = max(U(vicinity));
    ha(j).pos = ha(j).vicLow + index(1) - 1;
    ha(j).amp = value * g(j);
    sa = sa + ha(j).amp;
end%of for

end%of file