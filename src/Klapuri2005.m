function F0Set = Klapuri2005(fileIn, numberOfF0s)
% F0Set = Klapuri2005(fileIn, numberOfF0s)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% return the set of detected frequencies using Klapuri 2005 method
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/22
% -------------------------------------------------------------------------

% Read the input wave file
[data.waveIn, data.fs] = wavread(fileIn);
data.waveLength = length(data.waveIn);
% set config for Klapuri2005 method
config = SetConfig(data.fs, 'Klapuri2005');
% force algorithm extract exactly numberOfF0s F0 values
config.maxF0Number = numberOfF0s;
% set HUTear model for Klapuri2005 Profile
data.model = Klapuri2005Profile(config);
% Apply the Auditory Filterbank
[data.au, data.model] = AudMod(data.waveIn, data.model);
% Obtain the summary magnitude spectrum of the first frame
U = config.specFunc(data, 1 : config.frameSize, config.window);
% Use Iteractive Estimation and Cancellation to estimate F0s
F0Set = IterativeEAC(U, config);
