function DispDetectedT0(T0, fs, maxSa, ha, U, UD)
% Display detected T0 visual information
disp(sprintf('T=%d Sa=%f F0=%4.2f', T0, maxSa, fs/T0));
% plot UD
colormap summer;
area(Amp2Log(UD));
xlim([1 length(U)]); hold on;
% plot spectrum
X = Amp2Log(U); plot(X);
haSpec = zeros(size(U));
% plot harmonic partial's search regions
for i = 1 : length(ha)
    haSpec(ha(i).pos) = ha(i).amp;
    vicinity = ha(i).vicLow : ha(i).vicUp;
    plot(vicinity, X(vicinity), 'g');
end
% plot ideal harmonic positions
% plot harmonic positions
plot(Amp2Log((haSpec > 0)).*max(X),'g');
% plot harmonic partials
plot(Amp2Log(haSpec),'r');

hold off;
zoom xon;
end
