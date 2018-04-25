% distance effect

f = 1; 
AlignData
FlowSoundPlot
FlowSoundAssess
% FlowSoundApply 

loadprh(tag)
t = (1:length(p))/(fs)/60;
%%
figure(29), hold on 
plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTest(1,~isnan(CUE_R)),'^')
plot(breath.cue(pon)/60,VTest(2,~isnan(CUE_R)),'^')
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v')
plot(breath.cue(pon)/60,VTesti(2,~isnan(CUE_R)),'v')
plot(t,A)

xlim([breath.cue(pon(1))/60-1 breath.cue(pon(end))/60+1]), ylim([-4 10])
xlabel('Time (min)'), ylabel('Tidal Volume (L)')
