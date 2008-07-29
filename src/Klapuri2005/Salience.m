function [sa, ha] = Salience(T, U, config)
% [sa, ha] = Salience(T, U, config)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Calculate salience value of period T defined in formula (4)
% Klapuri, "A Perceptually Motivated Multiple-F0 Estimation Method", 2005
% INPUT
%   T: period (in samples)
%   U: short-time spectrum magnitude
%   config: config parameters
% OUTPUT
%   sa: salience value of period T
%   ha: corresponding harmonic partials
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/06
% -------------------------------------------------------------------------

%% init paramters
halfK = length(U);          % number of useful frequency bins
K = 2*halfK;                % number of frame samples after zero-padding
F = config.fs / T;          % frequency correspond to period T

lower = K/(T + config.deltaT / 2);	% lower bound of search region
upper = K/(T - config.deltaT / 2);	% upper bound of search region
haNum = min(config.maxHarmonicNum, floor(halfK/upper));	% number of harmonic partials
ha = struct('pos',{},'amp',{},'vicLow',{},'vicUp',{}); 	% init harmornic information pool
sa = 0;	%init salience value to zero

%% find harmonic partials
% Numbering showing corresponding formula in the paper
for j = 1 : haNum
    ha(j).vicLow = floor(j*lower) + 1;                          % (5) vicLow: lower bound of vicinity
    ha(j).vicUp = max( floor(j*upper), ha(j).vicLow);           % (6) vicUp: upper bound of vicinity
    vicinity = ha(j).vicLow : ha(j).vicUp;
    
    H_LP = ((0.108 * config.fs / K)* vicinity  + 24.7).^-1;     % (7)

    % calculate salience value of T in formula (4)
    [value, index] = max(H_LP.*U(vicinity));
    ha(j).pos = ha(j).vicLow + index(1) - 1;
    ha(j).amp = value * F;
    sa = sa + ha(j).amp;
end

%% normalize salience function if necessary (in case of 93ms window length)
if config.salienceNorm
    b = -0.04;
    sa = (1 + b*log(F))*sa; % (8)
end
