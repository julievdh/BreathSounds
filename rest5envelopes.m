% lono 5' rest sound flow analysis
warning off

load('DQFiles2017')
f = 14; 
filename = strcat(DQ2017{f,2},'_resp');
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load(filename)

% load tag audit
tag = DQ2017{f,1}; R = loadaudit(tag); recdir = d3makefname(tag,'RECDIR');

% make exhales only?
[~,breath] = findaudit(breath,'breath');

% get cues
CUE_S = find(CUE); % cues in pneumotach summary file
CUE_R = CUE(find(CUE)); % cues in R audit structure

%% plot all envelopes in subplot
for i = 1:length(CUE_R)
    [b(i).clean(:,1),afs] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,1); % channel 1
    [~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);
    
    [b(i).clean(:,2),afs] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,2); % channel 2
    [~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);
    
    figure(21),
    subplot(ceil(length(CUE_R)/3),3,i), hold on, % ylim([0 2E-3]), xlim([0 1])
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
end

%% summary data
% what is mean/SD of measured VT, flow rates?

figure(3); clf, hold on
plot(breath.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,3:6),'.','markersize',10)
errorbar(repmat(1000,1,4),mean(all_SUMMARYDATA(CUE_S,3:6)),std(all_SUMMARYDATA(CUE_S,3:6)),'ko','markerfacecolor','k')
legend('Max Insp Flow','Max Exp Flow','Tidal Volume E','Tidal Volume I','Location','WestOutside')
title(regexprep(tag,'_',' ')), xlabel('Time (s)')
adjustfigurefont


%% calculate 95% energy duration
for i = 1:length(CUE_R)
    [start1(i),stop1(i),time_window1(i)] = energy95(b(i).env(:,1),fs);
    [start2(i),stop2(i),time_window2(i)] = energy95(b(i).env(:,2),fs);
    
    figure(21),
    subplot(ceil(length(CUE_R)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
    plot(start1(i):(1/fs):stop1(i),b(i).env(start1(i)*fs:round(stop1(i)*fs),1),'k')
    plot(start2(i):(1/fs):stop2(i),b(i).env(start2(i)*fs:round(stop2(i)*fs),2),'k')
   
    [mx1,ind1] = max(b(i).env(start1(i)*fs:round(stop1(i)*fs),1)); plot(ind1/fs + start1(i),mx1,'*')
    [mx2,ind2] = max(b(i).env(start2(i)*fs:round(stop2(i)*fs),2)); plot(ind2/fs + start2(i),mx2,'*')
end

%% correlate
