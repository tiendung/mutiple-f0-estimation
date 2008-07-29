function [T0, maxSa, UD] = DetectT0(U, config)
% [T0, ha] = DetectT0(U, config)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Detect predominant T0 in polyphonic spectrum. Return fundamental period
% T0, coresponding harmonic spectrum and salience value of T0
% Using fast search algorithm in page 6
% Klapuri, "Multiple Fundamental Frequency Estimation by Summing Harmonic Amplitudes", 2006
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------

fs = config.fs;
best = 1;
count = 1;
T_lo(1:2) = config.minT0;
T_up(1:2) = config.maxT0;
sa(1:2) = 0;

while T_up(best) - T_lo(best) > config.T_prec
    count = count + 1;
    T_lo(count) = (T_lo(best) + T_up(best))/2;
    T_up(count) = T_up(best);
    T_up(best) = T_lo(count);
    
    sa(count) = MaxSalience(count);
    sa(best) = MaxSalience(best);

    [maxSa best] = max(sa);
end%of while

[maxSa, T0, ha] = MaxSalience(best);
UD = EstimateHarmonicPartials(U, ha, config);

    function [sa, T, ha, deltaT, g_range] = MaxSalience(q)
        T = (T_lo(q) + T_up(q))/2;
        deltaT = T_up(q) - T_lo(q);
        g_range = g(1:length(U));
        [sa, ha] = Salience(T, U, deltaT, g_range);
        % g function defined in Klapuri2006 paper
        function g_range = g(range)
            g_range = (range*fs/T_up(q) + config.beta).^-1;
            g_range = (fs/T_lo(q) + config.alpha) * g_range;
        end%of g
    end%of MaxSalience
% -------------------------------------------------------------------------
% END OF MAIN CODE
% -------------------------------------------------------------------------
if config.displayEachT0 == 1
    DispDetectedT0(T0, config.fs, maxSa, ha, U, UD); 
    pause;
end

end%of file