
% liho trial 14 calibration example
load('flowcalLihoTrial14')
warning off 

figure(1), clf, hold on
plot(flow)

figure(2), clf
for i = 1:length(st)
    vol = cumsum(flow(st(i):ed(i)))./400;
    subplot(121), hold on
    plot(vol,flow(st(i):ed(i)))
    xlabel('Volume (L)'), ylabel('Flow (L/s)')
    subplot(122), hold on
    plot(vol)
    xlabel('Time'), ylabel('Volume (L)')
end
