clear, close all

addpath('\\uni.au.dk\Users\au575532\Documents\MATLAB\RespDetector')
load('SarasotaFiles');
letters = {'A','B','C','D','E','F','G'};

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
    % plot data
    figure(99)
    subplot(4,2,f-9), hold on
    plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v')
    plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
    
    % add release time
    [CAL,DEPLOY] = d3loadcal(tag);
    if f == 13;
        DEPLOY.TAGON.RELEASE = [2014           5           6          18          25          18];
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
    plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1),'kv','markerfacecolor','w')
    plot(breath.cue(q)/60,VTi_swim,'kv') %,'markerfacecolor',[0.5 0.5 0.5])
    
    VTi_rest = extractfield(reststore,'VTesti');
    q0 = find(Quality == 0);
    lia = ismember(q0,pon);
    q = q0(lia == 0);
    plot(breath.cue(q,1)/60,VTi_rest,'v')
    % find quality > after release time
    ii = find(breath.cue(q,1) > release);
    if ~isempty(ii)
        plot(breath.cue(q(ii),1)/60,VTi_rest(ii),'kv')
    end
    
    % add TLCest
    TLC = 0.135*Sarasota{f,3}^0.92; % estimate from Kooyman 1973
    
    % load in and plot depth
    loadprh(tag,'p','fs')
    p = correctdepth(p,fs);
    plot((1:length(p))/fs/60,-p,'k')
    xlim([floor(breath.cue(1)/60)-2 round(breath.cue(end,1)/60)+2])
    ylim([-10 ceil(max(VTi_swim))])
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
        ylabel('Depth (m)     Volume (L)')
    end
    
    plotMassVT
end

print([cd '\AnalysisFigures\PlotAllVTdepth_7.png'],'-dpng')

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