% Audit Tag
clear 
%% Select tag
tag = 'sw17_196a' % 'tt17_135b'; %  
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
% fs = 50; 

% X = d3readswv_commonfs(recdir,prefix);

return
%%
% load prh
% loadprh(tag)

% load calibration and deployment info, tag audit
% [CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

%% perform audit
R = d3tagaudit(tag,1,R);
return
%% save audit
saveaudit(tag,R)

%% check audited cues
figure
plot((1:length(p))/fs,-p)
hold on
plot(R.cue(:,1),zeros(length(R.cue),1),'r*') % plot any audited cues

%% if ECG Tag:
% ensure files are renamed
tag = 'tt15_135a';
R = loadaudit(tag);
R = d3tagaudit(tag,1,R); and audit will proceed without prh file