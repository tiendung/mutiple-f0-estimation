function y = Amp2Log(x)
%convert to log domain
y = log2(x+2)-1;

% y = x;
% r = x ~= 0;
% y(r) = log2(x(r));
