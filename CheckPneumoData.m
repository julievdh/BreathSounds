% Check Pneumo Data
% Some pneumo files are x10^8, not sure why. So, check through all of them
% to figure out which may be wrong. If so, correct them. 

% files to load
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
d = dir('*.mat'); % get directory

for i = 1:length(d)
% load file
load(d(i).name)

figure(1)
if exist('RAWDATA') == 1
plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2);
else plot(pre_RAWDATA(:,1),pre_RAWDATA(:,2),'LineWidth',2); hold on
    plot(post_RAWDATA(:,1),post_RAWDATA(:,2),'LineWidth',2); hold off
end
title(regexprep(d(i).name,'_',' '))

figure(2)
if exist('SUMMARYDATA') == 1
plot(SUMMARYDATA);
else plot(pre_SUMMARYDATA);
    plot(post_SUMMARYDATA);
end
title(regexprep(d(i).name,'_',' '))
pause
clear RAWDATA SUMMARYDATA
end
