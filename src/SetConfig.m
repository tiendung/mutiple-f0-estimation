function config = SetConfig( fs, method )
% config = SetConfig( fs, method )
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% set common parameters for all methods and specific parameters for each method
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/08
% -------------------------------------------------------------------------

% find current directory path
path = fileparts(mfilename('fullpath'));
% adding paths contain needed functions
addpath([path '\Common']);      % common functions shared between all methods
addpath([path '\DispStuff']);   % display funtions to show visual information
addpath([path '\' method]);     % specific funtions for each methods

clear config;   % clear the config variable (if exists)
%=============================================
% common parameters
%=============================================

config.frameLength = 0.093;         % frame length in second
config.maxF0Number = 6;             % maximum number of frequencies to be detected, if = 0 => auto detect
config.displayEachT0 = 1;           % if = 1, display visual information of runing steps

config.id = method;
config.fs = fs;                     % sample rate
config.minF0 = 65;                  % minimum fundamental frequency to be detected
config.maxF0 = 2100;                % maximum fundamental frequency to be detected
config.surroundHarmonicBins = 10;   % number of surround bins used in harmonic partial shape estimation

% choose the appropriate setting for each method
WhichMethod;

%=============================================
% derived parameters
%=============================================
config.maxT0 = round(fs / config.minF0);                % minimum fundamental period in sample unit
config.minT0 = round(fs / config.maxF0);                % maximum fundamental period in sample unit
config.frameSize = round(fs * config.frameLength);      % number of sample in a frame
config.window = config.windowFunc(config.frameSize);    % window amplitude

len = 2^nextpow2(2*config.frameSize-1);                 % used in zero-padding
% spectrum magnitude of window used in harmonic partial shape estimation, using hanning window as default
config.windowSpec = abs(fft(hann(config.frameSize), len));

%=============================================
% Set config for Klapuri2005 method
%=============================================
    function ConfigForKlapuri2005
        addpath([path '\HUTear']);              % used HUTear to calculate auditory channel signals
        config.specFunc = @CombineAudiSpecs;    % select auditory Spectrum Combining method
        config.deltaT = 1;                      % space between successive period candidate T
        config.subtractionScale = 0.5;          % scale of substraction used in cancellation step
        config.maxHarmonicNum = 20;             % maximum number of harmonics to be counted on
        config.windowFunc = @hamming;           % window to be applied
        config.frequencyRange = [60 5200];      % Freq range of auditory model
        config.numberOfChannels = 72;
        
        % normalize Salience or not
        if config.frameLength == 0.093
            config.salienceNorm = 1;    % normalize if frame size = 93ms
        else
            config.salienceNorm = 0;    % do not normalize in other cases
        end
    end

%=============================================
% Set config for Klapuri2006 method
%=============================================
    function ConfigForKlapuri2006
        config.specFunc = @SpectrumWhitening;   % select spectrum whitening method
        config.T_prec = 1;                      % T_prec parameter for Klapuri2006 (see his paper)
        config.windowFunc = @hann;              % window to be applied

        % see Klapuri2006 paper for details of  alpha, beta, and subtractionScale parameters
        switch config.frameLength
            case 0.046
                config.alpha = 27;
                config.beta = 320;
                config.subtractionScale = 1;
            case 0.093
                config.alpha = 52;
                config.beta = 320;
                config.subtractionScale = 0.89;
            otherwise
                error('for Klapuri2006, frameLength must be 46ms or 93ms')
        end%of switch config.frameLength
    end

    function WhichMethod
        switch method
            case 'Klapuri2005',
                ConfigForKlapuri2005;
            case 'Klapuri2006',
                ConfigForKlapuri2006;
            otherwise
                error('please choose Klapuri2005 or Klapuri2006 method')
        end%of switch method
    end

end%of file