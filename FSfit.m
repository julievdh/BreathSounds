function [a,b] = FSfit(snd,flw,proportion)

% inputs
%   sound envelope, flow (L/s)
%   proportion is the proportion of all of the points used in the fit
% outputs


snd(snd == 0) = NaN; 
flw = flw(~isnan(snd)); % remove NaNs in snVTdi 
snd = snd(~isnan(snd)); % remove Nans in snd

figure(2), clf, hold on
plot(snd,flw,'o')

% choose random proportion of data
chs = randi([1 length(snd)],1,floor(length(snd)*proportion)); 

plot(snd(chs),flw(chs),'.')

[curve,gof] = fit(snd(chs)',flw(chs)','a*x^b','robust','bisquare');
h = plot(curve); legend off
h.LineWidth = 2; 

a = curve.a;
b = curve.b;
end 


