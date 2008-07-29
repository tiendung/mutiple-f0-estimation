function F0Set = IterativeEAC(UR, config)
% function F0Set = IterativeEAC(UR, config)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Iterative Estimation and Cancellation
% INPUT
%   U: short-time spectrum
%   fs: sampling F0Setuency
% OUTPUT
%   F0Set: multiple F0 of spectrum U
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/06
% -------------------------------------------------------------------------

count = 1;
F0Set = zeros(1, config.maxF0Number);

while count <= config.maxF0Number
% estimation
    [T0, maxSa, UD] = DetectT0(UR, config);
    F0Set(count) = config.fs / T0;
    count = count + 1;
% cancellation
    UR = UR - config.subtractionScale*UD;
    UR( UR < 0 ) = 0;
end
