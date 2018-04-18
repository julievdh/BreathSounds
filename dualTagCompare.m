% dualTag Comparisons
% Trial 73 and Trial 61
% f = 9,10,11,28

% load DQ files
load('DQFiles2017')

f = [9 28];
% f = [10 11];

% load in data for both files 
tag1 = load([cd '\PneumoData\' DQ2017{f(1),2} '_resp_flowsound.mat']);
tag2 = load([cd '\PneumoData\' DQ2017{f(2),2} '_resp_flowsound.mat']);
load([cd '\PneumoData\' DQ2017{f(1),2} '_resp.mat']); 

% plot error comparison 
minflow = all_SUMMARYDATA(:,4); 
mxflow = all_SUMMARYDATA(:,3);
CUE_S = find(CUE); CUE_R = CUE(find(CUE));
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on

% fill empty cells 
tag1.erroro = fillemptycells({tag1.allstore(:).erroro});
tag1.erroro2 = fillemptycells({tag1.allstore(:).erroro2});
tag1.errori = fillemptycells({tag1.allstore(:).errori});
tag1.errori2 = fillemptycells({tag1.allstore(:).errori2});

tag2.erroro = fillemptycells({tag2.allstore(:).erroro});
tag2.erroro2 = fillemptycells({tag2.allstore(:).erroro2});
tag2.errori = fillemptycells({tag2.allstore(:).errori});
tag2.errori2 = fillemptycells({tag2.allstore(:).errori2});
%% 
% figure(27), clf, hold on
% plot(-mxflow,[tag1.erroro],'^')
% plot(-mxflow,[tag1.errori],'v')
% plot(-minflow,[tag1.erroro2],'^')
% plot(-mxflow,[tag1.errori2],'v')
% plot(-minflow,[tag2.erroro2],'^')
% plot(-mxflow,[tag2.errori2],'v')
% plot(-minflow,[tag2.erroro],'^')
% plot(-mxflow,[tag2.errori],'v')
% 
% plot(-minflow,tag1.VTerre,'k^')
% plot(-mxflow,tag1.VTerri,'kv')
% plot(-minflow,tag2.VTerre,'k^')
% plot(-mxflow,tag2.VTerri,'kv')

%% plot within tags, between tags 
figure(21), clf, hold on 
% set(gcf,'position',1000*[2.0637    0.0990    1.1680    0.4280])
set(gcf,'paperpositionmode','auto')
% subplot(121), hold on %% note hydrophones are 'numbered' arbitrarily and this way plots look better with inset
% title('Within Tags')
[ax1,ax2,ax3] = scatterhist3(tag1.VTesti(1,:),tag1.VTesti(2,:),'v'); % inhale T1
scatterhist3(tag2.VTesti(1,:),tag2.VTesti(2,:),'v'); % inhale T2
scatterhist3(tag1.VTest(1,:),tag1.VTest(2,:),'^'); % exhale T1
scatterhist3(tag2.VTest(1,:),tag2.VTest(2,:),'^'); % exhale T2
lgd = legend(ax3,'Inhale T1','Inhale T2','Exhale T1', 'Exhale T2');
lgd.Position = [0.65 0.79 0.1976 0.1635];

xlabel(ax1,'VT Estimate - Hydrophone 1'), ylabel(ax1,'VT Estimate - Hydrophone 2')
plot(ax1,[0 10],[0 10],'k:')

xlim(ax3,[0 10]), ylim(ax2,[0 10])
print([cd '\AnalysisFigures\' DQ2017{f(1),1} 'dualtag_within_FlowSound'], '-dsvg', '-r300')

%% 
figure(22), clf, hold on 
% title('Between Tags')

[ax1,ax2,ax3] = scatterhist3(tag1.VTesti(1,:),tag2.VTesti(1,:),'v'); % inhale hydrophone 1 
scatterhist3(tag1.VTesti(2,:),tag2.VTesti(2,:),'v'); % inhale hydrophone 2
scatterhist3(tag1.VTest(1,:),tag2.VTest(1,:),'^'); % exhale hydrophone 1
scatterhist3(tag1.VTest(2,:),tag2.VTest(2,:),'^'); % exhale hydrophone 2 
lgd = legend(ax3,'Inhale H1','Inhale H2','Exhale H1', 'Exhale H2'); 
lgd.Position = [0.65 0.79 0.1976 0.1635];

xlabel(ax1,'VT Estimate - Tag 1'), ylabel(ax1,'VT Estimate - Tag 2')
plot(ax1,[0 10],[0 10],'k:')
xlim(ax3,[0 10]), ylim(ax2,[0 10])

print([cd '\AnalysisFigures\' DQ2017{f(1),1} 'dualtag_between_FlowSound'], '-dsvg', '-r300')

%% stats
% is there a difference between VT estimates from H1, H2 from the same tags
% values for table = [nanmean(tag1.VTest(1,:)) nanstd(tag1.VTest(1,:))]
% (nanmean(tag1.VTest(2,:))-nanmean(tag1.VTest(1,:)))/nanmean(tag1.VTest(1,:))
% max(tag2.VTest(2,:) - tag2.VTest(1,:))

[~,p(1),~,stat(1)] = ttest(tag1.VTest(1,~isnan(tag1.VTest(1,:))),tag1.VTest(2,~isnan(tag1.VTest(2,:))));
[~,p(2),~,stat(2)] = ttest(tag1.VTesti(1,~isnan(tag1.VTesti(1,:))),tag1.VTesti(2,~isnan(tag1.VTesti(2,:))));

[~,p(3),~,stat(3)] = ttest(tag2.VTest(1,~isnan(tag2.VTest(1,:))),tag2.VTest(2,~isnan(tag2.VTest(2,:))));
[~,p(4),~,stat(4)] = ttest(tag2.VTesti(1,~isnan(tag2.VTesti(1,:))),tag2.VTesti(2,~isnan(tag2.VTesti(2,:))));

% is there a difference between VT estimates from Tag 1 vs Tag 2
[~,p(5),~,stat(5)] = ttest(tag1.VTest(1,~isnan(tag1.VTest(1,:))),tag2.VTest(1,~isnan(tag2.VTest(2,:))));
[~,p(6),~,stat(6)] = ttest(tag1.VTesti(1,~isnan(tag1.VTesti(1,:))),tag2.VTesti(1,~isnan(tag2.VTesti(2,:))));

[~,p(7),~,stat(7)] = ttest(tag1.VTest(2,~isnan(tag1.VTest(2,:))),tag2.VTest(2,~isnan(tag2.VTest(2,:))));
[~,p(8),~,stat(8)] = ttest(tag1.VTesti(2,~isnan(tag1.VTesti(2,:))),tag2.VTesti(2,~isnan(tag2.VTesti(2,:))));

%% compare variances 
[~,pv(1),~,statv(1)] = vartest2(tag1.VTest(2,:),tag1.VTest(1,:)); 
[~,pv(2),~,statv(2)] = vartest2(tag1.VTesti(2,:),tag1.VTesti(1,:)); 

[~,pv(3),~,statv(3)] = vartest2(tag2.VTest(2,:),tag2.VTest(1,:)); 
[~,pv(4),~,statv(4)] = vartest2(tag2.VTesti(2,:),tag2.VTesti(1,:)); 


%% plot error against each other? 
% within tags, between tags 
figure(23), clf, hold on 
% set(gcf,'position',1000*[2.0637    0.0990    1.1680    0.4280])
set(gcf,'paperpositionmode','auto')
subplot(121), hold on %% note hydrophones are 'numbered' arbitrarily and this way plots look better with inset
title('Within Tags')
plot([-2 4],[-2 4],'k:')
[ax1,ax2,ax3] = scatterhist3(tag1.VTerri(1,:),tag1.VTerri(2,:),'v'); % inhale T1
scatterhist3(tag2.VTerri(1,:),tag2.VTerri(2,:),'v'); % inhale T2
scatterhist3(tag1.VTerre(1,:),tag1.VTerre(2,:),'^'); % exhale T1
scatterhist3(tag2.VTerre(1,:),tag2.VTerre(2,:),'^'); % exhale T2
lgd = legend(ax3,'Inhale T1','Inhale T2','Exhale T1', 'Exhale T2');
lgd.Position = [0.65 0.79 0.1976 0.1635];
plot(ax1,[-2 8],[-2 8],'k:')
xlim(ax3,[-2 8]), ylim(ax2,[-2 8])

xlabel(ax1,'VT Error - Hydrophone 1'), ylabel(ax1,'VT Error - Hydrophone 2')
%%
figure(24), clf, hold on 
title('Between Tags')
[ax1,ax2,ax3] = scatterhist3(tag1.VTerri(1,:),tag2.VTerri(1,:),'v'); % inhale hydrophone 1 
scatterhist3(tag1.VTerri(2,:),tag2.VTerri(2,:),'v'); % inhale hydrophone 2
scatterhist3(tag1.VTerre(1,:),tag2.VTerre(1,:),'^'); % exhale hydrophone 1
scatterhist3(tag1.VTerre(2,:),tag2.VTerre(2,:),'^'); % exhale hydrophone 2 
lgd = legend(ax3,'Inhale H1','Inhale H2','Exhale H1', 'Exhale H2');
lgd.Position = [0.65 0.79 0.1976 0.1635];
plot(ax1,[-2 8],[-2 8],'k:')
xlim(ax3,[-2 8]), ylim(ax2,[-2 8])

xlabel(ax1,'VT Error - Tag 1'), ylabel(ax1,'VT Error - Tag 2')

% or can do difference between measured and estimated values
% h1 = plot(tag1.VTesti,tag1.VTi,'v'); % inhale T1
% plot(tag1.VTesti(1,1:5),tag1.VTi(1:5),'kv','markerfacecolor','k') % those used for fit
% 
% h2 = plot(tag2.VTesti,tag2.VTi,'v'); % inhale T2
% 
% h3 = plot(tag1.VTest,tag1.VTe,'^'); % exhale T1
% plot(tag1.VTest(1,1:5),tag1.VTe(1:5),'kv','markerfacecolor','k') % those used for fit
% 
% h4 = plot(tag2.VTest,tag2.VTe,'^'); % exhale T2
% legend([h1(1) h1(2) h2(1) h2(2) h3(1) h3(2) h4(1) h4(2)],'Inhale T1 H1','Inhale T1 H2',...
%     'Inhale T2 H1','Inhale T2 H2','Exhale T1 H1', 'Exhale T1 H2',...
%     'Exhale T2 H1', 'Exhale T2 H2','Location','NW')
% 
% xlabel('Estimated VT (L)'), ylabel('Measured VT (L)')
