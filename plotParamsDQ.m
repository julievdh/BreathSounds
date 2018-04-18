% plotParamsDQ
ins(:,3) = ins(:,2)-ins(:,1);
exp(:,3) = exp(:,2)-exp(:,1);

figure(3), clf
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
subplot(3,1,1:2), hold on
plot(breath.cue(pon,1),exp(pon,3),'.')
plot(breath.cue(pon,1),ins(pon,3),'.')
plot(breath.cue(:,1),exp(:,3),'^')
plot(breath.cue(:,1),ins(:,3),'v')

xlabel('Time (sec)'), ylabel('Duration (sec)')

subplot(3,1,3), hold on 
for n = 1:length(CUE_R)
    if isnan(CUE_R(n)) == 0
plot(breath.cue(CUE_R(n),1),VTesti(n),'kv')
plot(breath.cue(CUE_R(n),1),VTe(n),'k.')
plot(breath.cue(CUE_R(n),1),VTi(n),'r.')
    end
end
q = find(Quality == 20);
plot(breath.cue(q,1),extractfield(surfstore,'VTesti'),'bv')

q = find(Quality == 0);
plot(breath.cue(q,1),extractfield(surfstore,'VTesti'),'bv')

ylabel('Estimated VT (L)'), xlabel('Time (sec)')

%% 
clf, hold on
h = histogram(VTi,'binwidth',0.5,'normalization','count'); % all measured
h.FaceAlpha = 0.2; 
h = histogram(horzcat(VTesti(1,:),[reststore(:).VTesti],[surfstore(:).VTesti]),'binwidth',0.5,'normalization','count'); % all total estimated
h.FaceAlpha = 0.2; 
histogram([reststore(:).VTesti],'binwidth',0.5,'normalization','count')
histogram([surfstore(:).VTesti],'binwidth',0.5,'normalization','count')
histogram(VTesti(1,:),'binwidth',0.5,'normalization','count')


plot([nanmean(VTi) nanmean(VTi)],[0 1],'k','linewidth',2)