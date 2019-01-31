clear, close all

addpath('\\uni.au.dk\Users\au575532\Documents\MATLAB\RespDetector')
load('SarasotaFiles');
letters = {'A','B','C','D','E','F','G'};

alltab = nan(1,5);

for f = 10:16
    q = []; % clear q
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
    
    % R = loadaudit(tag);
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
    
    VTi_swim = extractfield(surfstore,'VTesti');
    VTi_swim(VTi_swim < 1) = NaN;
    
    VTi_rest = extractfield(reststore,'VTesti');
    q0 = find(Quality == 0);
    lia = ismember(q0,pon);
    q = q0(lia == 0);
    plot(breath.cue(q,1)/60,VTi_rest,'v')
    % sort resting into order
    [outCue,outOrigin] = merge_sorted(breath.cue(q),breath.cue(pon),0,1);
    outVT = nan(length(outCue),1);
    outVT(find(outOrigin == 0)) = VTi_rest; % tidal volume when no pneum
    outVT(find(outOrigin == 1)) = VTesti(1,~isnan(CUE_R)); % tidal volume when pneum on
    
    expdur = exp(:,2)-exp(:,1); insdur = ins(:,2)-ins(:,1); 
    outeDur = nan(length(outCue),1); outiDur = nan(length(outCue),1);
    outeDur(find(outOrigin == 0)) = expdur(q); % exhaled duration when p off
    outeDur(find(outOrigin == 1)) = expdur(pon); % exhaled duration when p on
    outiDur(find(outOrigin == 0)) = insdur(q); % inhaled duration when p off
    outiDur(find(outOrigin == 1)) = insdur(pon); % inhaled duration when p on
    
    plot(outCue/60,outVT,'*')
    
    ii = find(iswithin(outCue,[breath.cue(pon(1))-5*60 breath.cue(pon(end))+5*60]));
    plot(outCue(ii)/60,outVT(ii),'k*')
    
    alltab = vertcat(alltab,[outCue(ii) outVT(ii) outOrigin(ii) outeDur(ii) outiDur(ii)]);
    
    xlim([floor(breath.cue(1)/60)-2 (outCue(end)/60)+2])
    ylim([0 ceil(max(real(VTi_rest)))])
    grid on
    
end

% save all VT/timing/quality data
writetable(array2table(real(alltab)), 'all_VTesti.txt')
fixNaN % fix NaNs in .txt

print([cd '\AnalysisFigures\PlotAllVTrest_7.png'],'-dpng')

