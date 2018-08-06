% cross-validation 

%% 1 - compare across hydrophones 
f = 10; 
AlignData_DQ2017
FlowSoundPlot_DQ2017
FlowSoundAssess

%% 
figure(23), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')
ax3.XLim = ax1.XLim; ax2.YLim = ax1.YLim;

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')

% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% correct for difference in means 
scl = nanmean(VTest(2,:)./VTest(1,:));
scli = nanmean(VTesti(2,:)./VTesti(1,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(1,:),VTest(2,:)/scl); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(1,:),VTesti(2,:)/scli); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm1 = fitlm(VTest(1,:),VTest(2,:));
lmi1 = fitlm(VTesti(1,:),VTesti(2,:));
%% 
f = 11; 
AlignData_DQ2017
FlowSoundPlot_DQ2017
FlowSoundAssess

%% 
figure(23), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')
ax3.XLim = ax1.XLim; ax2.YLim = ax1.YLim;

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')

% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% correct for difference in means 
scl = nanmean(VTest(2,:)./VTest(1,:));
scli = nanmean(VTesti(2,:)./VTesti(1,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(1,:),VTest(2,:)/scl); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(1,:),VTesti(2,:)/scli); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm2 = fitlm(VTest(1,:),VTest(2,:));
lmi2 = fitlm(VTesti(1,:),VTesti(2,:));

% [nanmean(VTest(2,:) - VTest(1,:)) nanstd(VTest(2,:)-VTest(1,:))]
% nanmean(VTest(2,:) - VTest(1,:))/nanmean(VTest(1,:))
% [nanmean(VTesti(2,:) - VTesti(1,:)) nanstd(VTesti(2,:)-VTesti(1,:))]
% nanmean(VTesti(2,:) - VTesti(1,:))/nanmean(VTesti(1,:))

%% 
f = 9; 
AlignData_DQ2017
FlowSoundPlot_DQ2017
FlowSoundAssess

%% 
figure(23), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')
ax3.XLim = ax1.XLim; ax2.YLim = ax1.YLim;

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')

% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% correct for difference in means 
scl = nanmean(VTest(2,:)./VTest(1,:));
scli = nanmean(VTesti(2,:)./VTesti(1,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(1,:),VTest(2,:)/scl); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(1,:),VTesti(2,:)/scli); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm2 = fitlm(VTest(1,:),VTest(2,:));
lmi2 = fitlm(VTesti(1,:),VTesti(2,:));

%%
f = 28; 
AlignData_DQ2017
FlowSoundPlot_DQ2017
FlowSoundAssess

%% 
figure(23), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')
ax3.XLim = ax1.XLim; ax2.YLim = ax1.YLim;

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')

% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm2 = fitlm(VTest(1,:),VTest(2,:));
lmi2 = fitlm(VTesti(1,:),VTesti(2,:));

%% 
f = 19; 
AlignData_DQ2017
FlowSoundPlot_DQ2017
FlowSoundAssess

%% 
figure(23), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')

% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm3 = fitlm(VTest(1,:),VTest(2,:));
lmi3 = fitlm(VTesti(1,:),VTesti(2,:));

%% 
f = 10; 
AlignData
FlowSoundPlot
FlowSoundAssess

figure(24), clf, hold on 
set(gcf,'paperpositionmode','auto')
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^',1,0.5,1); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v',1,0.5,1); % inhale H1 vs H2
plot(ax1,[0 12],[0 12],'k:')
ax3.XLim = ax1.XLim;

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')


% compare values: paired t test
[~,pt(1),~,statt] = ttest(VTest(1,:),VTest(2,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),VTesti(2,:));

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

print([cd '/AnalysisFigures/' tag '_Hcompare.png'],'-dpng')
% have hydrophone clip level calculation for this tag

lm4 = fitlm(VTest(1,:),VTest(2,:));
lmi4 = fitlm(VTesti(1,:),VTesti(2,:));

% [nanmean(VTest(2,:) - VTest(1,:)) nanstd(VTest(2,:)-VTest(1,:))]
% nanmean(VTest(2,:) - VTest(1,:))/nanmean(VTest(1,:))
% [nanmean(VTesti(2,:) - VTesti(1,:)) nanstd(VTesti(2,:)-VTesti(1,:))]
% nanmean(VTesti(2,:) - VTesti(1,:))/nanmean(VTesti(1,:))
%% plot difference in slopes vs. difference in hydrophone sensitivities
tag119hydrophones 
exhslope = [1.2 0.91 0.34 1.33 0.85 2.45]; inhslope = [0.81 0.80 0.97 0.97 0.92 1.23];

figure(92), clf, hold on
plot(mean(CL2'),exhslope,'^')
plot(mean(CL2'),inhslope,'v')
% db factor 
rng = -2:12;
factor = 10.^(rng/20); 
plot(rng,factor,'k:')
xlabel('Difference in Hydrophone Clip Level (dB)'), ylabel('H2/H1')
legend('Exhale','Inhale','Expected')
%% 2 - calculate from one tag on another deployment
% tt13_278a is Lono, f = 10 
% tt13_281a is also Lono, f = 12 

% load in f = 12 allstore
f = 12; 
filename = strcat(DQ{f,2},'_resp');
f12 = load([cd '\PneumoData\' filename '_flowsound.mat']); 

CrossValsubroutine
figure(3), print([cd '\AnalysisFigures\CrossVal_f10f12'],'-dpng','-r300')

%% apply to a different animal
f = 9; 
filename = strcat(DQ{f,2},'_resp');
f12 = load([cd '\PneumoData\' filename '_flowsound.mat']); % variable still called f12, but for file 9

CrossValsubroutine
print([cd '\AnalysisFigures\CrossVal_hist_f10f' num2str(f)],'-dpng','-r300')

%%
figure(3), clf
set(gcf,'position',1E3*[1.9563    0.0897    1.1147    0.3427], 'paperpositionmode','auto')
subplot(131), hold on 
[ax1, ax2, ax3] = scatterhist3(f12.VTest(1,:),VTest(1,:),'^',1,0.5,1);
[ax1, ax2, ax3] = scatterhist3(f12.VTesti(1,:),VTesti(1,:),'v',1,0.5,1);
set(ax1,'position',[0.08 0.1245 0.2 0.6])
set(ax2,'position',[0.3 0.1245 0.05 0.6])
set(ax3,'position',[0.08 0.8 0.2 0.15])
%plot(VTest(1,:),[f12(:).VTest(1,:)],'^')
%plot(VTesti(1,:),[f12(:).VTesti(1,:)],'v')

xlabel(ax1,'VT Estimate - Crossed'), ylabel(ax1,'VT Estimate - Own')
plot(ax1,[0 20],[0 20],'k:')
text(0.5,9.5,'A','FontSize',16,'FontWeight','Bold')

subplot(132), hold on 
plot(VTest(1,:),[f12(:).VTe],'k^')%,'markerfacecolor','k')
plot(VTesti(1,:),[f12(:).VTi],'kv')%,'markerfacecolor','k')
plot([f12(:).VTest(1,:)],[f12(:).VTe],'^')
plot([f12(:).VTesti(1,:)],[f12(:).VTi],'v')
ylabel('Measured Volume (L)'), xlabel('Estimated Volume (L)')
plot([0 10],[0 10],'k:')
text(0.5,9.5,'B','FontSize',16,'FontWeight','Bold')

subplot(133), hold on 
plot([f12(:).VTesti(1,:)],[f12(:).VTi],'v')
plot([f12(:).VTest(1,:)],[f12(:).VTe],'^')
plot(VTest(1,:)*scl,[f12(:).VTe],'k^')
plot(VTesti(1,:)*scl,[f12(:).VTi],'kv')
plot([0 10],[0 10],'k:')
ylabel('Measured Volume (L)'), xlabel('Estimated Volume (L)')
text(0.5,9.5,'C','FontSize',16,'FontWeight','Bold')

print([cd '\AnalysisFigures\CrossVal_f10f' num2str(f)],'-dsvg','-r300')

