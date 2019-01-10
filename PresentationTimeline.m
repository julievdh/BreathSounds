% File 16 walkthrough presentation
ind = find(~isnan(CUE_R(I)));
[Ix,idx] = sort(I(ind));

figure(111), clf
set(gcf,'position',[1980 109 1140 420])
subplot('position',[0.1 0.1 0.6 0.8]), hold on
plot(breath.cue(CUE_R(1:6),1),abs(all_SUMMARYDATA(1:6,5)),'ko:','markerfacecolor','k')

% load prh 
loadprh(tag,'A','fs')
t = (1:length(A))/fs;
plot(t,A) % plot acceleration signal
ylim([-1 TLC]), xlim([breath.cue(CUE_R(1))-10 breath.cue(CUE_R(6))+10])
xlabel('Time (seconds)'), ylabel('Tidal Volume (L)')


subplot('position',[0.77 0.1 0.2 0.8]), hold on
plot(Sint1(idx(1:6)),abs(all_SUMMARYDATA(1:6,5)),'ko','markerfacecolor',[0    0.4470    0.7410])
plot(Sint2(idx(1:6)),abs(all_SUMMARYDATA(1:6,5)),'ko','markerfacecolor',[0.6350    0.0780    0.1840])
ylim([-1 TLC])
xlabel('Integral of Sound Envelope'), ylabel('Tidal Volume (L)')

subplot('position',[0.1 0.1 0.6 0.8]), hold on
H = plot_ci(breath.cue(CUE_R(1:6),1),ci2(idx(1:6),:),...
    'patchcolor',[0.6350    0.0780    0.1840],'patchalpha',0.5,'linecolor','w');
H = plot_ci(breath.cue(CUE_R(1:6),1),ci1(idx(1:6),:),...
    'patchcolor',[0.3010    0.7450    0.9330],'patchalpha',0.5,'linecolor','w');
plot(breath.cue(CUE_R(1:6),1),pred1(idx(1:6)),'ko','markerfacecolor',[0    0.4470    0.7410])
plot(breath.cue(CUE_R(1:6),1),pred2(idx(1:6)),'ko','markerfacecolor',[0.6350    0.0780    0.1840])
plot(breath.cue(CUE_R(1:6),1),abs(all_SUMMARYDATA(1:6,5)),'ko:','markerfacecolor','k')

%% 
figure(112), clf, hold on
set(gcf,'position',[1980 109 1140 420],'paperpositionmode','auto')
subplot('position',[0.37 0.1 0.6 0.8]), hold on
plot(breath.cue(CUE_R,1),abs(all_SUMMARYDATA(:,5)),'ko:','markerfacecolor','k')
plot(t,A)
ylim([-1 TLC]), xlim([breath.cue(CUE_R(1))-10 breath.cue(CUE_R(end))+10])
xlabel('Time (seconds)'), ylabel('Tidal Volume (L)')

subplot('position',[0.1 0.1 0.2 0.8]), hold on
[ci1_sort] = predint(fit1,sort(Sint1)); 
[ci2_sort] = predint(fit2,sort(Sint2)); 
H = plot_ci(sort(Sint1),ci1_sort,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');
H = plot_ci(sort(Sint2),ci2_sort,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');

plot(fit1,'k'), plot(fit2,'k'), legend off
plot(Sint1(idx),abs(all_SUMMARYDATA(:,5)),'ko','markerfacecolor',[0    0.4470    0.7410])
plot(Sint2(idx),abs(all_SUMMARYDATA(:,5)),'ko','markerfacecolor',[0.6350    0.0780    0.1840])
ylim([-1 TLC])
xlabel('Integral of Sound Envelope'), ylabel('Tidal Volume (L)')
% add fit information to plot
text(0.03,19.2,strcat('R^2 = ',sprintf('%g\n',round(gof1.rsquare,2))))
text(0.03,18.35,strcat('RMSE = ',sprintf('%g\n', round(gof1.rmse,2)),' L'))

text(0.13,19.2,strcat('R^2 = ',sprintf('%g\n',round(gof2.rsquare,2))))
text(0.13,18.35,strcat('RMSE = ',sprintf('%g\n', round(gof2.rmse,2)),' L'))



subplot('position',[0.37 0.1 0.6 0.8]), hold on
plot(breath.cue(CUE_R(I(ind))),VTa(ind),'.-','color',[0.75 0.75 0.75])
plot(breath.cue(CUE_R(I(ind))),VTb(ind),'.-','color',[0.75 0.75 0.75])
H = plot_ci(breath.cue(CUE_R,1),ci2(idx,:),...
    'patchcolor',[0.6350    0.0780    0.1840],'patchalpha',0.25,'linecolor','w');
H = plot_ci(breath.cue(CUE_R,1),ci1(idx,:),...
    'patchcolor',[0.3010    0.7450    0.9330],'patchalpha',0.25,'linecolor','w');
plot(breath.cue(CUE_R,1),pred1(idx),'ko','markerfacecolor',[0    0.4470    0.7410])
plot(breath.cue(CUE_R,1),pred2(idx),'ko','markerfacecolor',[0.6350    0.0780    0.1840])
plot(breath.cue(CUE_R,1),abs(all_SUMMARYDATA(:,5)),'ko:','markerfacecolor','k')

text(1000,15.3,'0.8*TLC')
text(1000,11.8,'0.6*TLC')
text(1000,TLC+0.5,'TLC')

cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
printname = strcat(regexprep(filename,'_resp',''),'TrialVTest');
print(printname,'-r300','-dpng')

%% histogram 

figure(113)
Hphone = vertcat(repmat(1,length(Sint1),1),repmat(2,length(Sint2),1));
h = scatterhist(vertcat(Sint1',Sint2'),vertcat(abs(B),abs(B)),...
    'Group',Hphone,'kernel','on','Location','NorthEast','Direction','Out',...
    'Color',[0    0.4470    0.7410;0.6350    0.0780    0.1840]); 
h(1), hold on
hold on
plot(h(1),[0 0],[1 1],'k*')


figure(114) % only first six breaths
Hphone = vertcat(repmat(1,6,1),repmat(2,6,1));
scatterhist(vertcat(Sint1(idx(1:6))',Sint2(idx(1:6))'),vertcat(abs(all_SUMMARYDATA(1:6,5)),abs(all_SUMMARYDATA(1:6,5))),...
    'Group',Hphone,'kernel','on','Location','NorthEast','Direction','Out',...
    'Color',[0    0.4470    0.7410; 0.6350    0.0780    0.1840])

