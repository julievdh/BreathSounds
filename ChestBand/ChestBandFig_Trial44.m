% ChestBand Figure

close all; clear ; clc

% Load DQ File Data Structure
load('DQFiles2017')
f = 5; % file 5 is Kolohe Trial 44 chest band

tag = DQ2017{f,1};
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag); 
[~,breath] = findaudit(R,'breath'); % get only breaths from audit

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
filename = strcat(DQ2017{f,2});
load(filename)
% parse
for i = 1:size(titles,1)
    v = genvarname(titles(i,:));
    eval(strcat(v, ' = data(datastart(', num2str(i), '):dataend(', num2str(i), '));'));
end
flowt = (1:length(FilteredFlow))/tickrate; % time in seconds for flow 

% return to other directory
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\
%%
figure(7); clf
subplot('position',[0.1 0.1 0.85 0.4])
[ax,h1,h2] = plotyy(flowt,FilteredFlow,flowt,-ChestBand); hold on
set(ax(1),'xlim',[66 90])
set(ax(2),'xlim',[66 90])

%% save a down-sampled envelope for each breath audited
for i = 1:length(breath.cue)
[b(i).clean(:,1),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,1); % channel 1
[~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);

[b(i).clean(:,2),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,2); % channel 2
[~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);

% figure(21), clf, hold on
% plot(b(i).env(:,1))
% plot(b(i).env(:,2))

end

return 

%% plot specific envelopes
figure(7)
subplot('position',[0.1 0.6 0.85 0.3]), hold on
plot((1:length(b(25).env(:,1)))/fs,b(25).env(:,1),'color',[0 137/255 55/255]) % dark green
plot((1:length(b(25).env(:,1)))/fs,b(25).env(:,2),'color',[166/255 219/255 160/255]) % light green
xlim([-2 36])

% second breath
plot(16.5+(1:length(b(26).env(:,1)))/fs,b(26).env(:,1),'color',[0 137/255 55/255])
plot(16.5+(1:length(b(26).env(:,1)))/fs,b(26).env(:,2),'color',[166/255 219/255 160/255])

% third breath
plot(30.25+(1:length(b(27).env(:,1)))/fs,b(27).env(:,1),'color',[0 137/255 55/255])
plot(30.25+(1:length(b(27).env(:,1)))/fs,b(27).env(:,2),'color',[166/255 219/255 160/255])

% %%
% figure(41),clf
% for i = 1:length(breath.cue)
% subplot(6,7,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
% plot((1:length(breath(i).env))/fs,breath(i).env(:,1),'color',[0 137/255 55/255]) % dark green
% plot((1:length(breath(i).env))/fs,breath(i).env(:,2),'color',[166/255 219/255 160/255]) % dark green
% end

figure(42),clf, hold on
for i = 26
ylim([-0.1E-4 2E-3]), xlim([0 1])
plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[0 137/255 55/255]) % dark green
plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[166/255 219/255 160/255]) % dark green
plot((1:length(b(i+1).env))/fs,b(i+1).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
plot((1:length(b(i+1).env))/fs,b(i+1).env(:,2),'color',[123/255 50/255 148/255]) % light purple
end

%% load pneumotach data
SUMfname = strcat(regexprep(filename,'.mat',''),'-DATA_SUMMARY.txt');
all_SUMMARYDATA = importDATASUMMARY(SUMfname);
%%
CUE_S = find(CUE); 
CUE_R = CUE(find(CUE)); % sound cues
figure(3); clf, hold on
plot(R.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,3:6),'.','markersize',10)
errorbar(repmat(300,1,4),mean(all_SUMMARYDATA(CUE_S,3:6)),std(all_SUMMARYDATA(CUE_S,3:6)),'ko','markerfacecolor','k')
legend('Max Insp Flow','Max Exp Flow','Tidal Volume E','Tidal Volume I','Location','WestOutside')
title(regexprep(tag,'_',' ')), xlabel('Time (s)')
adjustfigurefont