clear, close all

for f = 10:16
    
    % make filename
    load('SarasotaFiles'); tag = Sarasota{f,1};
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
    q = find(Quality == 20);
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
    
    for n = 1:length(surfstore)
        plot(breath.cue(q(n))/60,surfstore(n).VTesti,'kv','markerfacecolor',[0.5 0.5 0.5])
    end
    q0 = find(Quality == 0);
    lia = ismember(q0,pon);
    q = q0(lia == 0);
    plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'v')
    
    % load in and plot depth
    loadprh(tag,'p','fs')
    plot((1:length(p))/fs/60,-p)
    xlim([0 round(length(p)/fs/60)])
    grid on 
end

print([cd '\AnalysisFigures\PlotAllVTdepth_6.png'],'-dpng')
