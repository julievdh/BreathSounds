tag = 'tt14_126b';


loadprh(tag)
R = loadaudit(tag);
[~,breath] = findbreathcues(R);
p = correctdepth(p,fs);

cues = [2600 3000]; %[9100 9300]; % for 127a = [8800 8950];

[s,afs] = d3wavread(cues,d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
s = s(:,1)-mean(s(:,1));
figure(3), subplot('position',[0.1 0.4 0.8 0.5])
bspectrogram(s,afs,[1 length(s)/afs]); ylim([0 60])
set(gca,'fontsize',14), ylabel('Frequency (kHz)')

subplot('position',[0.1 0.1 0.8 0.2])
plot(1:(1/fs):diff(cues)+1,-p(cues(1)*fs:cues(2)*fs), 'linewidth',1), xlim([1 diff(cues)+1])
set(gca,'xtick',0:50:400), xlabel('Time (sec)'), ylabel('Depth (m)')
ylim([-10 1]), set(gca,'fontsize',14)

print([cd '\AnalysisFigures\' tag '_boatpass'], '-dpng', '-r300')

%% make pitch track
[T,pe] = ptrack(A,M,1.5,fs);
figure(4), clf, hold on % plot for this same segment
plot3(T(cues(1)*fs:cues(2)*fs,1),T(cues(1)*fs:cues(2)*fs,2),-p(cues(1)*fs:cues(2)*fs),'linewidth',1)
grid on, view([-153.5000   47.0667])

print([cd '\AnalysisFigures\' tag '_boatpass_ptrack'], '-dpng', '-r300')

%% plot breath spectrograms for the 5 breaths
bs = find(iswithin(breath.cue,cues));

figure(8), clf, hold on
for n = 1:length(bs)
    [s,afs] = d3wavread([breath.cue(bs(n),1)-0.2 breath.cue(bs(n),1)+breath.cue(bs(n),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s = s(:,1)-mean(s(:,1));
    subplot(4,3,n)
    bspectrogram(s,afs,[1 length(s)/afs]);
end
linkaxes

print([tag '_boatpass_breaths'], '-dpng', '-r300')

% and find bs within VTi_swim matrix
load(strcat('C:/tag/tagdata/',tag,'_PQ'))
load([cd '\PneumoData\6May2014_water_tt126b_FB142_resp_surfstore'])
q = find(Quality == 20);
bs = find(iswithin(breath.cue(q,1),cues));
real(VTi_swim(bs));

%% plot all VT and depth and such
t = (1:length(p))/(fs)/60;   % time in minutes
figure(29), clf
hold on
for n = 1:length(q)
    plot(breath.cue(q(n))/60,surfstore(n).VTesti,'kv','markerfacecolor',[0.5 0.5 0.5])
    % plot(breath.cue(q(n))/60,surfstore(n).VTesto,'k^')
end
plot(t,-p,'Linewidth',1)


%%
figure(99), clf, hold on 
plot((cues(1):(1/fs):cues(2))/60,-p(cues(1)*fs:cues(2)*fs), 'linewidth',1)
plot(breath.cue(q(bs),1)/60,real(VTi_swim(bs)),'kv','markerfacecolor',[0.25 0.25 0.25])
iRR = 60./diff(breath.cue(q,1)); 
% plot(breath.cue(q(2:end),1)/60,iRR,'.-','color',[0.5 0.5 0.5])

iVe_ei = iRR.*real(VTi_swim(2:end))'; % instantaneous VE measured inhale
TLC = 0.135*291^0.92; % FB 142 = 291 kg

iVe_constTLC = iRR*0.6*TLC; % 0.6*TLC; 
iVe_constMN = iRR*nanmean(VTi_swim); % 0.6*TLC; % try 0.6 of TLC 

% resample to even grid
[Ve_TLC,TVe] = resample(iVe_constTLC,breath.cue(q(1:end-1),1)/60,2); % 30s intervals, constant, with TLC
Ve_MN = resample(iVe_constMN,breath.cue(q(1:end-1),1)/60,2); % constant, with mean estimated
Ve_i = resample(iVe_ei,breath.cue(q(1:end-1),1)/60,2); % instantaneous VE

plot(TVe+0.25,Ve_i,'.-','color','k')
plot(TVe+0.25,Ve_MN,'.-','color',[0.5 0.5 0.5])
plot(TVe+0.25,Ve_TLC,'.-','color',[0.5 0.5 0.5])

xlim([43.5 50]), ylim([-10 32])
xlabel('Time (min)'), adjustfigurefont

print([cd '\AnalysisFigures\' tag 'depthVT_min'],'-dpng','-r300')

return 

%% breaths with pneumotach and after release depth 
figure(43), clf, hold on 
plot(t,-p,'Linewidth',1)
xlim([20 53])
% tt126b_depth_VTest.fig 

% calculate instantaneous breath rate
tdiff = diff(unique(breath.cue(q,1)));
iRR = 60./tdiff;  iRR(iRR < 0.5) = NaN;
plot(breath.cue(q(1:end-1),1)/60,iRR,'.-','color',[0.5 0.5 0.5])


iVT = iRR.*VTi_swim(1:end-1)'; 
plot(breath.cue(q(1:end-1),1)/60,iVT,'.-','color',[0.25 0.25 0.25])
TLC = 0.135*291^0.92; % FB 142 = 291 kg
iVT_const = iRR*0.6*TLC; % try 0.6 of TLC 
plot(breath.cue(q(1:end-1),1)/60,iVT_const,'.-','color','k')

