% plotParamsDQ
ins(:,3) = ins(:,2)-ins(:,1);
exp(:,3) = exp(:,2)-exp(:,1);

figure(3), clf
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
ax(1) = subplot(3,1,1:2); hold on
plot(breath.cue(pon,1)/60,exp(pon,3),'.')
plot(breath.cue(pon,1)/60,ins(pon,3),'.')
plot(breath.cue(:,1)/60,exp(:,3),'^')
plot(breath.cue(:,1)/60,ins(:,3),'v')

xlabel('Time (sec)'), ylabel('Duration (sec)')
% values for ONR report (tt13_269b)
% [nanmean(exp(pon(1:12),3)) nanstd(exp(pon(1:12),3))]
% [nanmean(ins(pon(1:12),3)) nanstd(ins(pon(1:12),3))]

ax(2) = subplot(3,1,3); hold on 
% plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
% plot volumes
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v')

% VTisub = VTi(~isnan(CUE_R)); 
% [nanmean(VTisub(1:12)) nanstd(VTisub(1:12))]
% [nanmean(VTisub(13:end)) nanstd(VTisub(13:end))]

% VTestisub = VTesti(1,~isnan(CUE_R));
% [nanmean(VTestisub(1:12)) nanstd(VTestisub(1:12))]
% [nanmean(VTestisub(13:end)) nanstd(VTestisub(13:end))]


q20 = find(Quality == 20);
plot(breath.cue(q20,1)/60,extractfield(surfstore,'VTesti'),'bv')
% [nanmean(ins(q20,3)) nanstd(ins(q20,3))]
% [nanmean(ins(pon(13:44),3)) nanstd(ins(pon(13:44),3))]
% [nanmean(extractfield(surfstore,'VTesti')) nanstd(extractfield(surfstore,'VTesti'))]

q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'bv')

ylabel('Estimated VT (L)'), xlabel('Time (sec)'), adjustfigurefont
set(gcf,'paperpositionmode','auto')
print([cd '\AnalysisFigures\VTdur_timeseries_' 'tag'],'-dpng','-r300')


%% 
figure(13), clf, hold on
h = histogram(VTi,'binwidth',0.5,'normalization','count'); % all measured
h.FaceAlpha = 0.3; 
%h = histogram(horzcat(VTesti(1,:),[reststore(:).VTesti],[surfstore(:).VTesti]),'binwidth',0.5,'normalization','count'); % all total estimated
%h.FaceAlpha = 0.2; 
h = histogram(VTesti(1,:),'binwidth',0.5,'normalization','count');
h.FaceAlpha = 0.3;
h = histogram([surfstore(:).VTesti],'binwidth',0.5,'normalization','count'); 
h.FaceAlpha = 0.3;
histogram([reststore(:).VTesti],'binwidth',0.5,'normalization','count')

xlabel('Inhaled Volume (L)'), adjustfigurefont
legend('Measured - Rest, On','Estimated - Rest, On','Estimated - Swimming','Estimated - Rest, Off')
print([cd '\AnalysisFigures\VTdist_' 'tag'],'-dpng','-r300')
% [mean([reststore(:).VTesti]) std([reststore(:).VTesti])]

% plot([nanmean(VTi) nanmean(VTi)],[0 1],'k','linewidth',2)