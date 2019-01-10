% ChestBand Figure

close all; clear ; clc

% Load DQ File Data Structure
load('DQFiles2017')
f = 11; % file 11

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

figure(7); clf
subplot('position',[0.1 0.1 0.85 0.4])
[ax,h1,h2] = plotyy(flowt,FilteredFlow,flowt,-ChestBand); hold on
set(ax(1),'xlim',[208 246])
set(ax(2),'xlim',[208 246])

%% import envelope from tag 1
[b17_t1h1,afs] = cleanbreath_fun(tag,breath.cue(17,:),recdir,0,1); % channel 1
[~,~,b17_t1h1_s,fs] = envfilt(b17_t1h1,afs);

figure(7)
subplot('position',[0.1 0.6 0.85 0.3]), hold on
plot((1:length(b17_t1h1_s))/fs,b17_t1h1_s,'color',[0 137/255 55/255]) % dark green
xlim([-2 36])

[b17_t1h2,afs] = cleanbreath_fun(tag,breath.cue(17,:),recdir,0,2); % channel 2
[E2,E22,b17_t1h2_s,fs] = envfilt(b17_t1h2,afs);

figure(7)
plot((1:length(b17_t1h2_s))/fs,b17_t1h2_s,'color',[166/255 219/255 160/255]) % light green

%% plot envelopes for second breath
[b18_t1h1,afs] = cleanbreath_fun(tag,breath.cue(18,:),recdir,0,1); % channel 1
[~,~,b18_t1h1_s,fs] = envfilt(b18_t1h1,afs);

figure(7)
plot(17+(1:length(b18_t1h1_s))/fs,b18_t1h1_s,'color',[0 137/255 55/255])

[b18_t1h2,afs] = cleanbreath_fun(tag,breath.cue(18,:),recdir,0,2); % channel 2
[~,~,b18_t1h2_s,fs] = envfilt(b18_t1h2,afs);

figure(7)
plot(17+(1:length(b18_t1h2_s))/fs,b18_t1h2_s,'color',[166/255 219/255 160/255])

%% save a down-sampled envelope for each breath audited
for i = 1:length(breath.cue)
[b412(i).clean(:,1),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,1); % channel 1
[~,~,b412(i).env(:,1),fs] = envfilt(b412(i).clean(:,1),afs);

[b412(i).clean(:,2),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,2); % channel 2
[~,~,b412(i).env(:,2),fs] = envfilt(b412(i).clean(:,2),afs);

% figure(21), clf, hold on
% plot(b(i).env(:,1))
% plot(b(i).env(:,2))

end
%%
figure(41),clf
for i = 1:length(breath.cue)
subplot(6,7,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
plot((1:length(b412(i).env))/fs,b412(i).env(:,1),'color',[0 137/255 55/255]) % dark green
plot((1:length(b412(i).env))/fs,b412(i).env(:,2),'color',[166/255 219/255 160/255]) % dark green
end

%% add second tag
tag = DQ2017{f-1,1};
recdir = d3makefname(tag,'RECDIR');
R = loadaudit(tag);
[~,breath] = findaudit(R,'breath'); % get only breaths from audit

[b17_t2h1,afs] = cleanbreath_fun(tag,breath.cue(17,:),recdir,0,1); % channel 1
[~,~,b17_t2h1_s,fs] = envfilt(b17_t2h1,afs);

figure(7)
plot(0.1+(1:length(b17_t2h1_s))/fs,b17_t2h1_s,'color',[194/255 165/255 207/255])

[b17_t2h2,afs] = cleanbreath_fun(tag,breath.cue(17,:),recdir,0,2); % channel 2
[~,~,b17_t2h2_s] = envfilt(b17_t2h2,afs);

figure(7)
plot(0.1+(1:length(b17_t2h2_s))/fs,b17_t2h2_s,'color',[123/255 50/255 148/255])

%% plot envelopes for second breath
[b18_t2h1,afs] = cleanbreath_fun(tag,breath.cue(18,:),recdir,0,1); % channel 1
[~,~,b18_t2h1_s,fs] = envfilt(b18_t2h1,afs);

figure(7)
plot(17+(1:length(b18_t2h1_s))/fs,b18_t2h1_s,'color',[194/255 165/255 207/255])

[b18_t2h2,afs] = cleanbreath_fun(tag,breath.cue(18,:),recdir,0,2); % channel 2
[~,~,b18_t2h2_s,fs] = envfilt(b18_t2h2,afs);

figure(7)
plot(17+(1:length(b18_t2h2_s))/fs,b18_t2h2_s,'color',[123/255 50/255 148/255])

%% plot all envelopes to compare
% breath 1
figure(8),clf,  hold on
plot((1:length(b17_t1h2_s))/fs,b17_t1h2_s,'color',[166/255 219/255 160/255]) % light green
plot((1:length(b17_t1h1_s))/fs,b17_t1h1_s,'color',[0 137/255 55/255]) % dark green
plot(0.5+(1:length(b17_t2h2_s))/fs,b17_t2h2_s,'color',[123/255 50/255 148/255])
plot(0.5+(1:length(b17_t2h1_s))/fs,b17_t2h1_s,'color',[194/255 165/255 207/255])


%% save a down-sampled envelope for each breath audited
for i = 1:length(breath.cue)
[b119(i).clean(:,1),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,1); % channel 1
[~,~,b119(i).env(:,1),fs] = envfilt(b119(i).clean(:,1),afs);

[b119(i).clean(:,2),afs] = cleanbreath_fun(tag,breath.cue(i,:),recdir,0,2); % channel 2
[~,~,b119(i).env(:,2),fs] = envfilt(b119(i).clean(:,2),afs);

% figure(21), clf, hold on
% plot(b(i).env(:,1))
% plot(b(i).env(:,2))

end
%%
% figure(42),clf
for i = 1:length(breath.cue)
subplot(6,7,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
plot((1:length(b119(i).env))/fs,b119(i).env(:,1),'color',[194/255 165/255 207/255]) % dark green
plot((1:length(b119(i).env))/fs,b119(i).env(:,2),'color',[123/255 50/255 148/255]) % dark green
end
