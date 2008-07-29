function F0Set = Klapuri2006(fileIn, numberOfF0s)
% F0Set = Klapuri2006(fileIn, numberOfF0s)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% return the set of detected frequencies using Klapuri 2006 method
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/22
% -------------------------------------------------------------------------

% Read the input wave file
[data.waveIn, data.fs] = wavread(fileIn);
data.waveLength = length(data.waveIn);
% set config for Klapuri2006 method
config = SetConfig(data.fs, 'Klapuri2006');
% force algorithm extract exactly numberOfF0s F0 values
config.maxF0Number = numberOfF0s;
% Apply Spectrum Whitening
U = config.specFunc(data, 1 : config.frameSize, config.window);
% Use Iteractive Estimation and Cancellation to estimate F0s
F0Set = IterativeEAC(U, config);
