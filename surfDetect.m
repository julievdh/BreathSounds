% Run tag audit only during surface periods of tag
% Works on Tag 2 and 3 deployments

% Julie van der Hoop jvanderhoop@bios.au.dk // 7 March 2017

close all, clear

tag = 'dl16_138a';
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);

%% load calibration and deployment info, tag audit
% CAL = loadcal(tag); % if Dtag2
[CAL,DEPLOY] = d3loadcal(tag); % if Dtag3
R = loadaudit(tag);
loadprh(tag);

%% this works to plot depth with time and add cues on top
figure(10); clf, hold on; warning off
t = (1:length(p))/fs;   % time in seconds
plot(t,-p)
xlabel('Time(sec)'), ylabel('Depth (m)')
[cues,breaths] = findbreathcues(R);
plot(breaths.cue(:,1),zeros(length(breaths.cue),1),'r*') % plot any audited cues

%% FIND DIVES
T = finddives(p,fs,1,1,0);
% plot dives 
for i = 1:size(T,1)
    plot(t(T(i,1)*fs:T(i,2)*fs),-p(T(i,1)*fs:T(i,2)*fs),'g')
end

% FIND PERIODS BETWEEN DIVES: matrix of S surfacings
S = nan(length(T),2);
S(1,1) = 1; S(1,2) = T(1,1); % assume tag begins at surface before first dive
S(2:length(T),1) = T(1:end-1,2);
S(2:length(T),2) = T(2:end,1);
% plot surfacings
for i = 1:length(S)
    plot(t(S(i,1)*fs:S(i,2)*fs),-p(S(i,1)*fs:S(i,2)*fs),'r')
end

%% FIND PERIODS AFTER LAST DIVE AND BEFORE TAGOFF
if T(end,2) > S(end,2)
[tagoff,~] = findaudit(R,'tagoff'); 
S(end+1,:) = [T(end,2) tagoff(1)];
end
%% AUDIT THOSE PERIODS ONLY
%% for DTAG2
for i = 1:length(S)
    R = tagaudit_surf(tag,S(i,1)-2,R,S(i,:));
end

% saveaudit(tag,R)
%% or for DTAG3
for i = 2:3 % 1:length(S)
   R = d3tagaudit_surf(tag,S(i,1),R,S(i,:));
% try: R = d3tagaudit_surf(tag,S(i,1),R,S(i,:),'prh','jerk');
%     % R = d3tagaudit_surf(tag,R.cue(end,1),R,S(i,:));
 end
