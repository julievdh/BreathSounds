% plot a breath and some other simultaneous tag data 
% other measures to show what could be useful for detector


% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

close all; clear all;

% % Load DQ File Data Structure
% load('SarasotaFiles')
% 
% % set file number
% i = 10; % tt125a
% 
% % set path, tag
% path = strcat('E:/',Sarasota{i,1}(1:4),'/',Sarasota{i,1},'/');
% tag = Sarasota{i,1};
% settagpath('audio',path(1:3));
% settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
%     'audit',[path 'audit\'])
% recdir = d3makefname(tag,'RECDIR');

%% load right wha
path = 'D:\rw11\rw11_015a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\']);
tag = 'rw11_015a';

% load data and cal/deploy information
loadprh(tag)
CAL = loadcal(tag);

%% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);
loadprh(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(Sarasota{i,2},'_resp');
load(filename)

% return to other directory
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\'

%% this works to plot depth with time and add cues on top
figure(1); hold on; warning off
t = (1:length(p))/fs;
plot(t,-p)

for i = 1:length(R.cue)
plot(R.cue(i),0,'r*')
end

%% FIND DIVES
T = finddives(p,fs,0.5,0.4,0);
% plot dives 
% for i = 1:length(T)
%     plot(t(T(i,1)*fs:T(i,2)*fs),-p(T(i,1)*fs:T(i,2)*fs),'g')
% end


%% FIND PERIODS BETWEEN DIVES: matrix of S surfacings
S(1:length(T)-1,1) = T(1:end-1,2);
S(1:length(T)-1,2) = T(2:end,1);
% plot surfacings
for i = 1:length(S)
    plot(t(S(i,1)*fs:S(i,2)*fs),-p(S(i,1)*fs:S(i,2)*fs),'r')
end

%% AUDIT THOSE PERIODS ONLY?
% for each surfacing, was there a surfacing detected by audit?
for i = 1:length(S)
    [X,N] = iswithin(R.cue(:,1),S(i,1:2));
    if sum(X) > 0
    S(i,3) = find(X == 1,1); % index in R.cue of FIRST 
    S(i,4) = R.cue(find(X == 1,1)); % value in R.cue (cue time in seconds)
    end
end

% plot these
plot(S(:,4),zeros(length(S)),'ko')

% or: how many are within all surfacings?
[X,N] = iswithin(R.cue(:,1),[S(:,1) S(:,2)]);
plot(S(N(X == 1),1),zeros(sum(X))+0.5,'bo') % plot the ones that are detected
plot(R.cue(X == 0,1),zeros(length(find(X == 0)))+0.5,'ro','markerfacecolor','r')
