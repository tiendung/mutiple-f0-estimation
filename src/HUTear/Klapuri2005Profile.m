function model = Klapuri2005Profile(config)
% auditory profile for Klapuri2005
clear model;

% General parameters
model.id = 'Auditory filterbank used in Klapuri Multiple F0 Estimation 2005 paper';
model.ds = 1;     % Outputs downsampled to rate fs/ds
model.fs = config.fs;

% Model for inner ear 
model.cochlea.id='Gammatone filterbank';
model.cochlea.gt.design='gammatone'; 
model.cochlea.gt.nch= config.numberOfChannels;
model.cochlea.gt.frange= config.frequencyRange;

% Mechanical to neural - haircell
model.haircell.id = 'Half-wave rectification, and compression';
% Rectification
model.haircell.rcf.r='half';
% Compression
model.haircell.rcf.c='Klapuri2005' ;
% Smoothing
model.haircell.rcf.f='no';
% Thresholding
model.haircell.rcf.thrhld='no';
