% Audit Tag
clear 
%% Select tag
path = 'D:\eg06\eg06_028a\';
settagpath('audio','D:\');
rmpath('\\uni.au.dk\Users\au575532\Documents\MATLAB\tag\d3matlab_2015')
addpath('\\uni.au.dk\Users\au575532\Documents\MATLAB\tag\d2matlab')

tag = 'eg06_028a' % 'eg14_049a' 
prefix = strcat(tag(1:2),tag(6:9));
% recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
recdir = 'D:\eg06\eg06_028a';
[s,fs]=swvread(tag);

%%
% load prh
loadprh(tag)

% load calibration and deployment info, tag audit
R = loadaudit(tag);

%% perform audit
R = tagaudit_fhj(tag,1,R);
return
%% save audit
saveaudit(tag,R)

%% check audited cues
figure
plot((1:length(p))/fs,-p)
hold on
[cues,breath] = findbreathcues(R);
plot(breath.cue(:,1),zeros(length(breath.cue),1),'r*') % plot any audited cues

