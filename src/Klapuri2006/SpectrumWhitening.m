function U = SpectrumWhitening( d, range, window )
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% calculate and whiten spectrum magnitude
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------

% init and do fft
len = length(range);
K = 2^nextpow2(2*len - 1);
halfK = round(K/2);
x = d.waveIn(range).*window;
X = abs(fft(x, K))';

cbBins = CriticalBankCenterBins(d.fs, K);
compCoefs = SubbandCompresionCoefs(cbBins, X);

% whitening
len = length(cbBins);
U = zeros(1, cbBins(len));
for j = 1 : len - 1
    [first last range] = IntervalParameters(j);
    compCoefs(range) = linspace(compCoefs(first), compCoefs(last), length(range));
    U(range) = X(range).*compCoefs(range);
end
U = U(1:halfK);

    function [first last range] = IntervalParameters(j)
        first = cbBins(j);
        last = cbBins(j + 1);
        range = first : last;
    end
% -------------------------------------------------------------------------
% END OF MAIN CODE
% -------------------------------------------------------------------------
% DisplayInfor; pause;
% Display visual information
    function DisplayInfor
        maxAmp = max(compCoefs);
        % plot whitened spectrum
        subplot(2,1,2); plot(NormalizeAmp(U)); xlim([1 length(U)]);
        
        subplot(2,1,1); plot(0,0);
        xlim([1 length(U)]); hold on;
        % plot triangular subband responses
        for i = 2 : len - 1
            [first, center, last, range] = SubbandParameters(i);
            Hb = TriangleFilter(first, center, last, halfK);
            plot(range,NormalizeAmp(Hb(range),maxAmp),'g');
        end
        
        % plot original spectrum
        halfX = (X(1:halfK));
        plot(NormalizeAmp(halfX, maxAmp),'b');

        % plot compression coefficients
        plot(NormalizeAmp(compCoefs,maxAmp),'r');
        hold off;
        zoom xon;

        function [first, center, last, range] = SubbandParameters(i)
            first = cbBins(i-1);
            center = cbBins(i);
            last = cbBins(i+1);
            range = first : last;
        end
    end
end