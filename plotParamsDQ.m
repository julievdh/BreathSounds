% plotParamsDQ
ins(:,3) = ins(:,2)-ins(:,1);
exp(:,3) = exp(:,2)-exp(:,1);

figure(3), clf
set(gcf,'position',[86.3333  136.3333  880.6667  420],'paperpositionmode','auto')
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
ax(1) = subplot('position',[0.100    0.6173    0.65    0.3077]); hold on
%plot(breath.cue(pon,1)/60,exp(pon,3),'.')
%plot(breath.cue(pon,1)/60,ins(pon,3),'.')
plot(breath.cue(:,1)/60,exp(:,3),'^','color',[0    0.4470    0.7410])
plot(breath.cue(q,1)/60,exp(q,3),'^','color',[0    0.4470    0.7410],'markerfacecolor',[0    0.4470    0.7410])
plot(breath.cue(:,1)/60,ins(:,3),'v','color',[0.8500    0.3250    0.0980])
plot(breath.cue(q,1)/60,ins(q,3),'v','color',[0.8500    0.3250    0.0980],'markerfacecolor',[0.8500    0.3250    0.0980])


xlabel('Time (sec)'), ylabel('Duration (sec)')
% values for ONR report (tt13_269b)
% [nanmean(exp(pon(1:12),3)) nanstd(exp(pon(1:12),3))]
% [nanmean(ins(pon(1:12),3)) nanstd(ins(pon(1:12),3))]

ax(2) = subplot('position',[0.100    0.1187    0.650    0.3324]); hold on 
% plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
% plot volumes
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v','color',[0.8500    0.3250    0.0980])

% VTisub = VTi(~isnan(CUE_R)); 
% [nanmean(VTisub(1:12)) nanstd(VTisub(1:12))]
% [nanmean(VTisub(13:end)) nanstd(VTisub(13:end))]

% VTestisub = VTesti(1,~isnan(CUE_R));
% [nanmean(VTestisub(1:12)) nanstd(VTestisub(1:12))]
% [nanmean(VTestisub(13:end)) nanstd(VTestisub(13:end))]


q20 = find(Quality == 20);

VTi_swim = extractfield(surfstore,'VTesti');
VTi_swim(VTi_swim < 1) = NaN;
NA = find(isnan(VTi_swim)); % replace NaN with mean and sd

plot(breath.cue(q20)/60,VTi_swim,'kv','markerfacecolor',[0.5 0.5 0.5])

for i = 1:length(NA)
    plot([breath.cue(q20(NA(i)),1)/60 breath.cue(q20(NA(i)),1)/60],[nanmean(VTi_swim)-nanstd(VTi_swim) nanmean(VTi_swim)+nanstd(VTi_swim)],'k')
end
plot(breath.cue(q20(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1),'kv','markerfacecolor','w')
% [nanmean(ins(q20,3)) nanstd(ins(q20,3))]
% [nanmean(ins(pon(13:44),3)) nanstd(ins(pon(13:44),3))]
% [nanmean(extractfield(surfstore,'VTesti')) nanstd(extractfield(surfstore,'VTesti'))]

q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'v','color',[0.8500    0.3250    0.0980],'markerfacecolor',[0.8500    0.3250    0.0980])

mass = assignmass(filename);
TLC = 0.135*mass^0.92; % estimate from Kooyman 1973
plot(ax(2).XLim,[TLC TLC],'k'), text(ax(2).XLim(2),TLC,{'TLC = ',sprintf('%1.2f',TLC)})
ylim([0 TLC])

ylabel('Estimated VT (L)'), xlabel('Time (sec)'), adjustfigurefont
set(gcf,'paperpositionmode','auto')
print([cd '\AnalysisFigures\VTdur_timeseries_' tag],'-dpng','-r300')


%% 
% figure(13), clf, hold on
ax(3) = subplot('position',[0.830    0.1187    0.15    0.3324]); hold on
h = histogram(VTi,'binwidth',0.5,'normalization','count'); % all measured
h.EdgeColor = 'k'; h.FaceAlpha = 0; 
%h = histogram(horzcat(VTesti(1,:),[reststore(:).VTesti],[surfstore(:).VTesti]),'binwidth',0.5,'normalization','count'); % all total estimated
%h.FaceAlpha = 0.2; 
h = histogram(VTesti(1,:),'binwidth',0.5,'normalization','count');
h.EdgeColor = [0.8500    0.3250    0.0980]; h.FaceAlpha = 0.5;
h = histogram([surfstore(:).VTesti],'binwidth',0.5,'normalization','count'); 
h.FaceColor = 'k'; h.FaceAlpha = 0.3;
h = histogram([reststore(:).VTesti],'binwidth',0.5,'normalization','count');
h.FaceColor = [0.8500    0.3250    0.0980]; 
ylim([0 10]), xlim([0 TLC]), plot([TLC TLC],[0 10],'k')
% xlabel('Inhaled Volume (L)'), 
adjustfigurefont
% legend('Measured - Rest, On','Estimated - Rest, On','Estimated - Swimming','Estimated - Rest, Off')
set(gca,'view',[90 -90])

print([cd '\AnalysisFigures\VTdist_' tag],'-dpng','-r300')
% [mean([reststore(:).VTesti]) std([reststore(:).VTesti])]

% plot([nanmean(VTi) nanmean(VTi)],[0 1],'k','linewidth',2)

%% plot VT vs duration through time? 

% make a matrix of breath cues and VT estimates and durations
VTesti_all = [breath.cue(pon)/60 VTesti(1,~isnan(CUE_R))' ins(pon,3); 
    breath.cue(q20)/60 VTi_swim' ins(q20,3); 
    breath.cue(q)/60 extractfield(reststore,'VTesti')' ins(q,3)]; % all together
% sort 
[~,idx] = sort(VTesti_all(:,1)); % sort just the first column
VTesti_allsorted = VTesti_all(idx,:);   % sort the whole matrix using the sort indices