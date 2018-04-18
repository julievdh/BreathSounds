% Audit Tag

%% Select tag
tag = 'tt17_132y';
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
X = d3readswv(recdir,prefix);

%% load prh
% loadprh(tag)

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

%%
if isempty(R.cue) == 1 % if there is no audit information already
%% plot sensors to see when tag was put on
figure(2), clf, hold on
plott(X.x{7,:},X.fs(7)) % plot accelerometer channels 
plott(X.x{8,:},X.fs(8))
plott(X.x{9,:},X.fs(9))
ginput(1)

% perform audit starting at that cue
R = d3tagaudit(tag,ans,R);
end

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
% tag = 'tt15_135a';
R = loadaudit(tag);
R = d3tagaudit(tag,1,R); and audit will proceed without prh file