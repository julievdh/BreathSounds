% VO2 Estimate Effect

% There are a few different ways to estimate VO2 from breathing frequency
% (e.g., as described in Fahlman et al. 2016)
% VO2 = VT x O2 extraction
% The methods vary in our assumptions of VT and of O2 extraction

n = max(pon); % number of breaths - try this
mass = assignmass(filename); 
TLC = 0.135*mass^0.92; % estimate from Kooyman 1973 

% Method A: VT = 80% of TLC, O2 extraction = 10%
% following e.g. Armstrong and Siegfried 1991, Dolphin 1987a
%VTa = repmat(0.8*0.0567*mass^1.03,n,1); % litres
O2a = 0.10; % percent
%VO2_a = VTa.*O2a; % L O2 per breath

% Method 2: 60% of TLC, using Kooyman 0.135*Mb^0.92
VTb = repmat(0.6*0.135*mass^0.92,n,1); % litres
VO2_b = VTb.*O2a; % L O2 per breath

VTmn = repmat(nanmean(VTe),n,1); % litres

%% add estimated (poff) breaths
if exist('pred_off1')
    VTs_off(:,1) = pred_off1; % (CUE_R(I)); % from channel 1 *** figure out how to transform back to order of actual breaths
    %VTs_off(:,2) = pred_off2; % (CUE_R(I)); % from channel 2
    VO2_s10_off = VTs_off*O2a(1);
end

%% determine effect on VO2 - sum O2 consumption / time
% This will be less straightforward as there are missing breaths in the
% time series


%% plot tidal volume through time 
figure(38), clf, hold on
% when stationed, pneumotach on
plot(breath.cue(pon)/60,VTb(pon),'o-','color',[0.75 0.75 0.75])

% when free-swimming
plot(breath.cue(q)/60,VTb(q),'o-','color',[0.75 0.75 0.75])

plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTest(1,~isnan(CUE_R)),'^')
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v')
xlim([breath.cue(pon(1))/60-1 breath.cue(pon(end))/60+1])
set(gca,'ylim',[0 TLC])

for n = 1:length(q)
plot(breath.cue(q(n))/60,surfstore(n).VTesti,'kv')
end


% plot(breath.cue(poff),VTs_off,'o','markeredgecolor',[0.6350    0.0780    0.1840])
% errorbar(breath.cue(poff),VTs_off(:,1),yci_off(:,1)-VTs_off,'o','color',[0.6350    0.0780    0.1840])
plot(xlim,[TLC TLC],'k--')
xlabel('Time (min)'), ylabel('Tidal Volume (L)')

%% 
figure(30), clf, hold on
VTe(find(isnan(VTe))) = nanmean([VTe,VTi]);
VTi(find(isnan(VTi))) = nanmean([VTe,VTi]); 
plot(breath.cue(pon),cumsum(VTe(~isnan(CUE_R))),'k.-')
plot(breath.cue(pon),cumsum(VTi(~isnan(CUE_R))),'k.-')

% plot(breath.cue(pon),cumsum(VTs(pnum,2)),'.-','color',[0    0.4470
% 0.7410]) % other hydrophone 
% replace NaNs in VTest with MEAN FOR NOW
VTest = VTest(1,:); VTesti = VTesti(1,:); 
VTest(find(isnan(VTest))) = nanmean([VTest,VTesti]);
VTesti(find(isnan(VTesti))) = nanmean([VTest,VTesti]);

VTestall(:,1) = vertcat(breath.cue(pon,1),breath.cue(q,1)); % time of breath
surfVT = extractfield(surfstore,'VTesti'); % all surf values
surfVT(isnan(surfVT)) = nanmean(surfVT); 
VTestall(:,2) = vertcat(VTest(~isnan(CUE_R))',nan(length(surfVT),1)); % exhaled VT estimate
VTestall(:,3) = vertcat(VTesti(~isnan(CUE_R))',surfVT'); 
VTestall = sortrows(VTestall,1); % sort by breath cue

plot(breath.cue(pon,1),cumsum(VTest(~isnan(CUE_R))),'.-','color',[0    0.4470    0.7410])
plot(breath.cue(pon,1),cumsum(VTesti(~isnan(CUE_R))),'.-','color',[0.8500    0.3250    0.0980])

plot(breath.cue(pon,1),cumsum(VTb(pon)),'color',[0.75 0.75 0.75]) % based on VT estimate from TLC
xlabel('Time (sec)'), ylabel('Cumulative Volume (L)')

% how good are we at estimating tidal volume? 
% difference between sound and measured 
diff_sm_ex = max(cumsum(VTe(~isnan(CUE_R))) - max(cumsum(VTest)));
diff_sm_in = max(cumsum(VTe(~isnan(CUE_R))) - max(cumsum(VTesti)));

tdiff = (breath.cue(pon(end)) - breath.cue(pon(1)))/60; % duration of trial, in minutes

% between estimated constant Method, and measured
diff_em_bex = max(cumsum(VTest)) - max(cumsum(VTb(pon)));
diff_em_bin = max(cumsum(VTesti)) - max(cumsum(VTb(pon)));

%% calculate minute ventilation
% when stationed
iRR = 60./diff(breath.cue(pon,1)); % instantaneous respiratory rate
iVe_me = iRR.*real(VTe(~isnan(CUE_R(2:end))))'; % instantaneous VE measured exhale
iVe_mi = iRR.*real(VTi(~isnan(CUE_R(2:end))))'; % instantaneous VE measured inhale
iVe_ee = iRR.*real(VTest(~isnan(CUE_R(2:end))))'; % instantaneous VE measured inhale
iVe_ei = iRR.*real(VTesti(~isnan(CUE_R(2:end))))'; % instantaneous VE measured inhale
iVe_const = iRR*0.6*TLC; % 0.6*TLC; 

% resample to even grid
[Ve_c,TVe] = resample(iVe_const,breath.cue(pon(2:end),1)/60,2); % 30s intervals
Ve_me = resample(iVe_me,breath.cue(pon(2:eclf'; % instantaneous VE
iVe_const = iRR*0.6*TLC; % 0.6*TLC; 

% resample to even grid
[Ve_c,TVe_c] = resample(iVe_const,breath.cue(q(2:end),1)/60,2); % 30s intervals
[Ve,TVe] = resample(iVe_me,breath.cue(q(2:end),1)/60,2); % so this is at 30s intervals


figure(39), clf, hold on 
allb = sort(vertcat(q,pon)); 
plot(breath.cue(allb,1)/60,cumsum(VTa(allb)),'color',[0.75 0.75 0.75])
plot(breath.cue(allb,1)/60,cumsum(VTb(allb)),'color',[0.75 0.75 0.75])

% plot(breath.cue(pon),cumsum(VTe(~isnan(CUE_R))),'k.-')
% plot(VTestall(:,1),cumsum(VTestall(:,2)),'.-','color',[0.6350    0.0780    0.1840])
plot(VTestall(:,1)/60,cumsum(VTestall(:,3)),'.-','color',[0.8500    0.3250    0.0980]) 
xlabel('Time (min)'), ylabel('Cumulative Volume (L)')
adjustfigurefont
print([cd '/AnalysisFigures/' tag '_cumVolEst.png'],'-dpng')

return 

%% distributions
pdmeas = fitdist(VTe(~isnan(CUE_R))','Kernel','BandWidth',2);
pdsound1 = fitdist(VTesti','Kernel','Bandwidth',2);
% pdsound2 = fitdist(pred2,'Kernel','Bandwidth',2);
pdoff1 = fitdist(surfVT','Kernel','Bandwidth',2);
% pdoff2 = fitdist(pred_off2,'Kernel','Bandwidth',2);

x = 0:0.1:ceil(max(VTe(~isnan(CUE_R))))';
ymeas = pdf(pdmeas,x);
ysound1 = pdf(pdsound1,x);
% ysound2 = pdf(pdsound2,x);

yoff1 = pdf(pdoff1,x);
% yoff2 = pdf(pdoff2,x);

figure(39), clf
ax1 = subplot('position',[0.1 0.1 0.5 0.6]); hold on; 
h = scatter(Sint1(pon),abs(all_SUMMARYDATA(pnum,5)),'kv','markerfacecolor','r'); 
h.MarkerFaceAlpha = 0.5;
plot(xlim,[TLC TLC],'k--')
%h = scatter(Sint2,abs(B),'kv','markerfacecolor','b'); % prominence and exhaled volume
% h.MarkerFaceAlpha = 0.5;
xlabel('Integral of Filtered Sound'), ylabel('Exhaled Tidal Volume (L)')

h = scatter(Sint1(poff),pred_off1,'kv','markerfacecolor',[0 146 146]/255); h.MarkerFaceAlpha = 0.5; 
% h = scatter(Sint2_off,pred_off2,'kv','markerfacecolor',[0 146 146]/255); h.MarkerFaceAlpha = 0.5; 

% side: densities of tidal volumes measured and estimated
ax2 = subplot('position',[0.65 0.1 0.3 0.6]); hold on
ax2.YLim = ax1.YLim; 
plot(ymeas,x,'k-','LineWidth',2) 
plot(ysound1,x,'color',[0    0.4470    0.7410],'LineWidth',2)
%plot(ysound2,x,'color',[0.6350    0.0780    0.1840],'LineWidth',2)
plot(yoff1,x,'y-','LineWidth',2) % pneumotach off
%plot(yoff2,x,'y-','LineWidth',2) % pneumotach off 

% top: densities of sounds on-off 
ax3 = subplot('position',[0.1 0.8 0.5 0.15]); hold on
pd_pneumon1 = fitdist(Sint1(pon)','Kernel','Bandwidth',.01); % pneumotach on
pd_pneumoff1 = fitdist(Sint1(poff)','Kernel','Bandwidth',.01); % pneumotach off
%pd_pneumon2 = fitdist(Sint2','Kernel','Bandwidth',.01); % pneumotach on
%pd_pneumoff2 = fitdist(Sint2_off','Kernel','Bandwidth',.01); % pneumotach off

x = 0:0.005:max([Sint1]); 

y_pneumon1 = pdf(pd_pneumon1,x); %y_pneumon2 = pdf(pd_pneumon2,x);
y_pneumoff1 = pdf(pd_pneumoff1,x); %y_pneumoff2 = pdf(pd_pneumoff2,x);

plot(x,y_pneumon1,'k-','LineWidth',2),% plot(x,y_pneumon2,'k-','LineWidth',2),
plot(x,y_pneumoff1,'color',[0 146 146]/255,'LineWidth',2)
% plot(x,y_pneumoff2,'color',[0 146 146]/255,'LineWidth',2)

ax3.XLim = ax1.XLim; 


return 
% %% plot VT and resp rate and minute volume
% figure(40), clf, hold on
% rrate = 60./diff(breath.cue(CUE_R(Ix))); 
% minvol = abs(B(ind(ix(2:end)))).*rrate; 
% %plot(breath.cue(CUE_R(Ix(2:end))),rrate,'o-') % ventilation rate
% plot(breath.cue(CUE_R(Ix)),abs(B(ind(ix))),'ko:','markerfacecolor','k') % VT measured
% legend('Ventilation rate','Measured VT')
% % plot(breath.cue(CUE_R(Ix(2:end))),minvol,'.:')
% xlabel('Time )sec)')
% 
% 
% 
% return 
% 
% %% calculate VO2rate
% delt = (max(breath.cue(CUE_R(I(ind)))) - min(breath.cue(CUE_R(I(ind)))))/60; % this is the time over which we estimate VO2 (min)
% VdotO2_a = sum(VO2_a)/delt;
% VdotO2_b = sum(VO2_b)/delt;
% VdotO2_s10 = nansum(VO2_s10)/delt;
% VdotO2_s11 = nansum(VO2_s11)/delt;
% 
% VdotO2_m10 = nansum(VO2_m10)/delt; % L/min
% VdotO2_m11 = nansum(VO2_m11)/delt;
% VdotO2_m05 = nansum(VO2_m05)/delt;
% 
% VdotO2_mm = all_SUMMARYDATA(end,7)/delt;
% 
% %% plot
% figure(46), clf, hold on
% plot(1:2,[VdotO2_a VdotO2_b],'o','color',[0.75 0.75 0.75])
% plot([3 3 5 5 4 6 7],[VdotO2_s10 VdotO2_s11 VdotO2_m10 VdotO2_m11 VdotO2_m05],'o')
% plot(8,VdotO2_mm,'*')
% xlabel('Estimation Method'), ylabel('Metabolic Rate (L/min)')
% 
% % How much does sound improve from constant VT assumption?
% improve_a = (VdotO2_a-VdotO2_s10)/VdotO2_a; 
% diff_sm_a = (VdotO2_s10-VdotO2_m10)/VdotO2_s10; % difference between sound and measured
% 
% improve_b = (VdotO2_b-VdotO2_s11)/VdotO2_b;
% diff_sm_b = (VdotO2_s11-VdotO2_m11)/VdotO2_s11;
% 
% 
% figure(47), clf, hold on
% plot(ind,all_SUMMARYDATA(ind,7),'.-')
% plot(ind,cumsum(VO2_m10(ind)),'.-') % if we assume every breath = 10% O2, use measured VT
% plot(ind,cumsum(VO2_m05(ind)),'.-')
% plot(ind,cumsum(VO2_s10(ind)),':')
% plot(ind,cumsum(VO2_a(ind)))
% 
% xlabel('Breath Number'), ylabel('Cumulative O2 (L)')
% legend('Measured with Pneumotach','Estimated O2 = 10%','Estimated O2 = 11.6%','Estimated O2 = 5%',...
%     'Location','NW')
% 
% %% add tag data to VT time series
% loadprh(tag)
% t = (1:length(p))/fs;   % time in seconds
% figure(29)
% plot(t,A)
% 

%% histogram
figure(87), hold on
histogram(VTest,'binwidth',1,'facecolor','k')
histogram(VTest,'binwidth',1,'facecolor',[0    0.4470    0.7410])
histogram(VTesti,'binwidth',1,'facecolor',[0.8500    0.3250    0.0980])
adjustfigurefont

