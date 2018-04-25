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

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

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

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

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

% compare variances: F test
[~,pv(1),~,statv(1)] = vartest2(VTest(2,:),VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(VTesti(2,:),VTesti(1,:)); 

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
[ax1,ax2,ax3] = scatterhist3(VTest(1,:),VTest(2,:),'^'); % exhale H1 vs H2
scatterhist3(VTesti(1,:),VTesti(2,:),'v'); % inhale H1 vs H2
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