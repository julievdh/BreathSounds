% cross-validation 

%% 1 - compare across hydrophones 
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

%% 2 - calculate from one tag on another deployment
% tt13_278a is Lono
% tt13_281a is also Lono, f = 12 

% load in f = 12 allstore
f = 12; 
filename = strcat(DQ{f,2},'_resp');
f12 = load([cd '\PneumoData\' filename '_flowsound.mat']); 

CrossValsubroutine