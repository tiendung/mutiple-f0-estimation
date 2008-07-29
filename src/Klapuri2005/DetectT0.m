function [T0, maxSa, UD] = DetectT0(U, config)
% [T0, maxSa, UD] = DetectT0(U, config)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Detect predominant T0 in polyphonic spectrum. Return fundamental period
% T0, coresponding harmonic spectrum and salience value of T0
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/06
% -------------------------------------------------------------------------

maxSa = 0;  % will contain maximum salience value
for T = config.minT0 : config.maxT0
    [curSa, curHa] = Salience(T, U, config);
    % Choose T which maximize salience value
    if curSa > maxSa
        maxSa = curSa;
        T0 = T;
        ha = curHa;
    end
end

% UD is the spectrum of estimated note, will be used in cancellation step
UD = EstimateHarmonicPartials(U, ha, config);

% -------------------------------------------------------------------------
% END OF MAIN CODE
% -------------------------------------------------------------------------
% Display visual information
if config.displayEachT0 == 1
    DispDetectedT0(T0, config.fs, maxSa, ha, U, UD); 
    pause;
end

end