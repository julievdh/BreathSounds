% Audit Tag
clear 
%% Select tag
tag = 'dl16_134a'; % 'tt17_135b'; %  
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
% X = d3readswv(recdir,prefix);
%%
% load prh
% loadprh(tag,'p','fs')

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

%% perform audit
R = d3tagaudit(tag,R.cue(end,1),R,20000,'envelope');
return
%% save audit
saveaudit(tag,R)

%% check audited cues
figure
plot((1:length(p))/fs,-p)
hold on
[cues,breath] = findbreathcues(R);
plot(breath.cue(:,1),zeros(length(breath.cue),1),'r*') % plot any audited cues

%% if ECG Tag:
% ensure files are renamed
tag = 'tt17_132w';

cd C:\tag\tagdata\ecg
load(strcat(tag,'_ecg'))

R = loadaudit(tag);

figure(11), clf, hold on
t = (1:length(ecgfilt))/ecgfilt_fs;
plot(t,ecgfilt)
plot(R.cue(:,1),zeros(length(R.cue)),'k.')
%%
R = d3tagaudit(tag,R.cue(end,1),R); % and audit will proceed without prh file

