clear, close all

addpath('\\uni.au.dk\Users\au575532\Documents\MATLAB\RespDetector')
load('SarasotaFiles');
% letters = {'B','C','D','E','F','G','H'};
IDs = {'FB276'}; 

% alltab = nan(1,6); % preallocate
% subplot settings and positions 
%ha = tight_subplot(4,2,[.06 .03],[.1 .05],[.05 .05]);
%pos = [ha.Position];
%pos = reshape(pos,4,8); 

for f = 13
    q = []; % clear q
    % make filename
    tag = Sarasota{f,1};
    % recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
    filename = strcat(Sarasota{f,2},'_resp');
    load([cd '\PneumoData\' filename])
    load([cd '\PneumoData\' filename '_flowsound.mat'])
    CUE_S = find(CUE); CUE_R = CUE(find(CUE)); CH = 2;
    pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
    
    % load PQ audit for quality
    load(strcat('C:\Users\au575532\Dropbox (Personal)\tag\tagdata\',tag,'_PQ'))
    
    % R = loadaudit(tag);
    [~,breath] = findbreathcues(R);
    if f == 10 % remove duplicates of breath cues
        removeDupes
    end
    
    % load in data
    load([cd '\PneumoData\' filename '_surfstore.mat'])
    
    % calculate exp and insp duration 
    expdur = exp(:,2)-exp(:,1); 
    insdur = ins(:,2)-ins(:,1);
    
    % plot data
    figure(99), clf, hold on 
    plot(breath.cue(2:end,1)/60,60./diff(breath.cue(:,1)),'.-','color',[0.9290    0.6940    0.1250]) % plot first so behind everything else
    plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v','color',[230    159    0]/255)    
    plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
    % tabulate cue, quality, VTest
    % alltab = vertcat(alltab,[repmat(f,length(pon),1) breath.cue(pon) VTesti(1,~isnan(CUE_R))' expdur(pon) insdur(pon) repmat(1,length(pon),1)]); % Quality 1 is now pneum on
    
    % add release time
    [CAL,DEPLOY] = d3loadcal(tag);
    if f == 13;
        DEPLOY.TAGON.RELEASE = [2014  5  6  18  25  18];
    end
    release = etime(DEPLOY.TAGON.RELEASE,DEPLOY.TAGON.TIME);
    plot([release/60 release/60],[-10 20],'k--')
    
    % add NaNs
    q = find(Quality == 20); % free-swimming, good quality
    
    VTi_swim = extractfield(surfstore,'VTesti');
    VTi_swim(VTi_swim < 1) = NaN;
    NA = find(isnan(VTi_swim)); % replace NaN with mean and sd
    for i = 1:length(NA)
        plot([breath.cue(q(NA(i)),1)/60 breath.cue(q(NA(i)),1)/60],[nanmean(VTi_swim)-nanstd(VTi_swim) nanmean(VTi_swim)+nanstd(VTi_swim)],'k')
    end
    plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1),'kv','markerfacecolor',[0.5 0.5 0.5])
    plot(breath.cue(q)/60,VTi_swim,'v','color',[86 180 223]/255) 
    
    
    VTi_rest = extractfield(reststore,'VTesti');
    q0 = find(Quality == 0);
    lia = ismember(q0,pon);
    q = q0(lia == 0);
    plot(breath.cue(q,1)/60,VTi_rest,'v','color',[153    153    153]/255)
    NA = find(isnan(VTi_rest)); % replace NaN with mean and sd
    for i = 1:length(NA)
        plot([breath.cue(q(NA(i)),1)/60 breath.cue(q(NA(i)),1)/60],[nanmean(VTi_rest)-nanstd(VTi_rest) nanmean(VTi_rest)+nanstd(VTi_rest)],'k')
    end
    plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_rest),length(NA),1),'kv','markerfacecolor',[0.5 0.5 0.5])
    % also find breaths that are not 0 and not 20722 
    ot = find(0 < Quality & Quality < 20);
    for i = 1:length(ot)
        plot([breath.cue(ot(i),1)/60 breath.cue(ot(i),1)/60],[nanmean(VTi_rest)-nanstd(VTi_rest) nanmean(VTi_rest)+nanstd(VTi_rest)],'k')
    end
    plot(breath.cue(ot,1)/60,repmat(nanmean(VTi_rest),length(ot),1),'kv','markerfacecolor',[0.5 0.5 0.5])
    
    
    % find quality > after release time
    ii = find(breath.cue(q,1) > release);
    if ~isempty(ii)
        plot(breath.cue(q(ii),1)/60,VTi_rest(ii),'color',[86 180 233]/255)
    end
    [outCue,outOrigin] = merge_sorted(breath.cue(Quality == 20),breath.cue(q),20,0);
    outVT = nan(length(outCue),1); % refresh
    outeDur = nan(length(outCue),1); 
    outiDur = nan(length(outCue),1); 
    outVT(find(outOrigin == 0)) = VTi_rest; % tidal volume when resting
    outVT(find(outOrigin == 20)) = VTi_swim; % tidal volume when swimming
    outeDur(find(outOrigin == 0)) = expdur(q); % exhaled duration when resting
    outeDur(find(outOrigin == 20)) = expdur(Quality == 20); % exhaled duration when swimming
    outiDur(find(outOrigin == 0)) = insdur(q); % inhaled duration when resting
    outiDur(find(outOrigin == 20)) = insdur(Quality == 20); % inhaled duration when swimming
    
    % set pre/post release indicator
    outQuality =  nan(length(outCue),1); % refresh
    ii = find(outCue > release);
    outQuality(ii) = 20;
    ii = find(outCue <= release);
    outQuality(ii) = 0; % after release, all Quality become 20
    
    % tabulate after fixing quality rest-swim
    % alltab = vertcat(alltab,[repmat(f,length(outCue),1) outCue outVT(:) outeDur(:) outiDur(:) outQuality]);
    
    % add TLCest
    TLC = 0.135*Sarasota{f,3}^0.92; % estimate from Kooyman 1973
    
    % load in and plot depth
    loadprh(tag,'p','fs')
    p = correctdepth(p,fs);
    plot((1:length(p))/fs/60,-p,'k')
    xlim([floor(breath.cue(1)/60)-2 round(breath.cue(end,1)/60)+2])
    ylim([-10 ceil(max(VTi_swim))+1])
    grid on
    
    % add text in top corners:
    % axletter(gca,letters{f-9},9,0.02)
    % animal ID
    axletter(gca,regexprep(IDs,'_','-'),10,0.91,0.12)
    % weight
    axletter(gca,[num2str(Sarasota{f,3}) ' kg'],10,0.91,0.05)
   
    xlabel('Time (min)')
    ylabel('Depth (m)     Volume (L)')
    adjustfigurefont('Helvetica',12)
    
    plotMassVT
    VTcontourRR
    
end
figure(99)
set(gcf,'Units','inches','position',[0.1250    1.1875   11.4792    4.4236],'paperpositionmode','auto')
print([cd '\AnalysisFigures\PlotAllVTdepth_PRES.png'],'-dpng')

return

% make table, test lm 
tab = array2table(real(alltab),'variableNames',{'ID','cue','VTi','edur','idur','Quality'});
restTab = tab(tab.Quality < 2,:); 
tab.ID = categorical(tab.ID); tab.Quality = categorical(tab.Quality); 
lme = fitlme(tab,'VTi~Quality+(1|ID)+(Quality-1|ID)');
lme2 = fitlme(tab,'VTi~Quality+(Quality|ID)');
F = fitted(lme2); 
figure, hold on 
plot(tab.Quality,tab.VTi,'ro')
plot(tab.Quality,F,'bx')

restTab.ID = categorical(restTab.ID); restTab.Quality = categorical(restTab.Quality); 
lmRest = fitlme(restTab,'VTi~idur+Quality+(Quality|ID)')
F = fitted(lmRest); 
figure, hold on 
plot(restTab.Quality,restTab.VTi,'ro')
plot(restTab.Quality,F,'bx')

%% plot one with %TLC


for f = 10:16
    
    % make filename
    tag = Sarasota{f,1};
    recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
    filename = strcat(Sarasota{f,2},'_resp');
    load([cd '\PneumoData\' filename])
    load([cd '\PneumoData\' filename '_flowsound.mat'])
    CUE_S = find(CUE); CUE_R = CUE(find(CUE)); CH = 2;
    pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
    
    % load PQ audit for quality
    load(strcat('C:\Users\au575532\Dropbox (Personal)\tag\tagdata\',tag,'_PQ'))
    
    R = loadaudit(tag);
    [~,breath] = findbreathcues(R);
    if f == 10 % remove duplicates of breath cues
        removeDupes
    end
    
    % load in data
    load([cd '\PneumoData\' filename '_surfstore.mat'])
    % add TLCest
    TLC = 0.135*Sarasota{f,3}^0.92; % estimate from Kooyman 1973
    
    % plot data
    figure(98)
    subplot(4,2,f-9), hold on
    plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R))/TLC*10,'v')
    plot(breath.cue(pon)/60,VTi(~isnan(CUE_R))/TLC*10,'k.','markersize',10)
    
    % add release time
    [CAL,DEPLOY] = d3loadcal(tag);
    if f == 13;
        DEPLOY.TAGON.RELEASE = [2014  5  6  18  25  18];
    end
    release = etime(DEPLOY.TAGON.RELEASE,DEPLOY.TAGON.TIME);
    plot([release/60 release/60],[-10 100],'k--')
    
    % add NaNs
    q = find(Quality == 20); % free-swimming, good quality
    
    VTi_swim = extractfield(surfstore,'VTesti');
    VTi_swim(VTi_swim < 1) = NaN;
    NA = find(isnan(VTi_swim)); % replace NaN with mean and sd
    for i = 1:length(NA)
        plot([breath.cue(q(NA(i)),1)/60 breath.cue(q(NA(i)),1)/60],[nanmean(VTi_swim)-nanstd(VTi_swim) nanmean(VTi_swim)+nanstd(VTi_swim)]/TLC*10,'k')
    end
    plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1)/TLC*10,'kv','markerfacecolor','w')
    plot(breath.cue(q)/60,VTi_swim/TLC*10,'kv') %,'markerfacecolor',[0.5 0.5 0.5])
    
    VTi_rest = extractfield(reststore,'VTesti');
    q0 = find(Quality == 0);
    lia = ismember(q0,pon);
    q = q0(lia == 0);
    plot(breath.cue(q,1)/60,VTi_rest/TLC*10,'v')
    % find quality > after release time
    ii = find(breath.cue(q,1) > release);
    if ~isempty(ii)
        plot(breath.cue(q(ii),1)/60,VTi_rest(ii)/TLC*10,'kv')
    end
    
    % load in and plot depth
    loadprh(tag,'p','fs')
    p = correctdepth(p,fs);
    plot((1:length(p))/fs/60,-p,'k')
    xlim([floor(breath.cue(1)/60)-2 round(breath.cue(end,1)/60)+2])
    ylim([-10 10])
    grid on
    
    % add text in top corners:
    axletter(gca,letters{f-9},12,0.02)
    % animal ID
    axletter(gca,regexprep(Sarasota{f,1},'_','-'),8,0.9,0.12)
    % weight
    axletter(gca,[num2str(Sarasota{f,3}) '  Kg'],8,0.9,0.05)
    
    
    if ismember(f,15:16)
        xlabel('Time (min)')
    end
    if ismember(f,10:2:16)
        ylabel('Depth (m)     % TLC_{est}')
    end
end

print([cd '\AnalysisFigures\PlotAllVTdepth_TLC.png'],'-dpng')

%% do VO2estEffect on this one
mass = Sarasota{f,3}; 

figure, hold on
% CHANGE TO DO THIS WITH THE EXPORT FROM PLOTALLVTDEPTH INSTEAD OF VTESTALL
VTestall = nan(length(pon)+length(q),3); 
VTestall(:,1) = vertcat(breath.cue(pon,1),breath.cue(q,1)); % time of breath
VTestall(:,2) = vertcat(VTest(~isnan(CUE_R))',nan(length(surfVT),1)); % exhaled VT estimate
VTestall(:,3) = vertcat(VTesti(~isnan(CUE_R))',surfVT'); 
VTestall = sortrows(VTestall,1); % sort by breath cue
VTb = repmat(0.6*0.135*mass^0.92,length(VTestall),1); % litres

plot(VTestall(:,1),VTb,'o-')
plot(VTestall(:,1),VTestall(:,3),'v')

iRR = 60./diff(VTestall(:,1));
iVe = iRR.*VTestall(2:end,3); % instantaneous VE measured inhale
iV_const = iRR*0.6*TLC;

figure, hold on
plot(VTestall(2:end,1),iVe,'v')
plot(VTestall(2:end,1),iV_const,'v')

% resample
[Ve_c,TVe] = resample(iV_const,VTestall(2:end,1),1); % 1-min intervals
Ve_e = resample(iVe,VTestall(2:end,1),1); % 
plot(TVe,Ve_c)
plot(TVe,Ve_e)

nanmean((Ve_c-Ve_e)./Ve_c) % on average a 32% difference in minute volume estimation