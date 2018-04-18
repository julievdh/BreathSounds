function [Pnorm] = normPress(Unorm)
% CONVERT TO NORMALIZED PRESSURE
% DTAG has volts, must correct based on sensitivity (-178 dB re 1V/uPa)

Snorm = 10^(-178/20);
Pnorm = Unorm/Snorm;
end
