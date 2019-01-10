% tt127z Sarasota Tag Alignment

% Tag and pneumotach on in water, then on deck, all in one file. 


% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

close all; clear all;

% Load DQ File Data Structure
load('SarasotaFiles')

% set file number
i = 4; % tt127z

% set path, tag
path = strcat('D:/',Sarasota{i,1}(1:4),'/',Sarasota{i,1},'/');
tag = Sarasota{i,1};
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(Sarasota{i,2},'_resp');
load(filename)

% return to other directory
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\'

return

%% breath cues from Pneumotach data files
breaths = [23000;27500;33200;48600;60600;72500;97800;106000;110000;];

%% FOR file A:
tcue = 32;

% CORRECTED FILE B TIMING TO ALIGN WITH tcue = 32; 

%% Plot Pneumotach and breath cues, and times we know files start/end
figure(1); clf
plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2); hold on
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

plot([642 642],[-20 50],'g')
plot(RAWDATA(breaths(:,1),1),RAWDATA(breaths(:,1),2),'g*')
plot([3282 3282],[-20 50],'g')

