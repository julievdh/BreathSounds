% load tag deployment

% load count data // or: run countdataload.m
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\BreathCounts
load('countdata')
%%
for i = 59 % length(files) -- only files that didn't initially have resp vectors
    % recdir = d3makefname(files(i).tag,'RECDIR');
    
    % load calibration and deployment info, tag audit
    [CAL,DEPLOY] = d3loadcal(files(i).tag);
    R = loadaudit(files(i).tag);
    
    % find breath cues only
    [cues,R] = findbreathcues(R);
    % find release time
    if isempty(DEPLOY) == 0
        if any(strcmp('TAGON',fieldnames(DEPLOY))) == 1; 
        if any(strcmp('RELEASE',fieldnames(DEPLOY.TAGON))) == 1;
            if size(DEPLOY.TAGON.RELEASE,2) < 6
                releasecue = etime([DEPLOY.TAGON.TIME(1:3) DEPLOY.TAGON.RELEASE], DEPLOY.TAGON.TIME);
            else
            releasecue = etime(DEPLOY.TAGON.RELEASE, DEPLOY.TAGON.TIME);
            end
        end
        end
    else releasecue = R.cue(1);
    end
    
    % plot to check
    %     t = (1:length(p))/fs;
    %     figure(1), clf, plot(t,-p), hold on, plot([releasecue releasecue],[-1 1],'k','LineWidth',2)
    
    % put resps in structure
    files(i).resp = unique(R.cue(R.cue(:,1) > releasecue)); % some files have duplicate resp entries?
    
    % calculate waiting times between breaths
    files(i).tdiff = diff(unique(R.cue(R.cue(:,1) > releasecue,1)));
    exth = find(files(i).tdiff > th); % find those above threshold, keep only those ones
    files(i).tdiff = files(i).tdiff(exth); files(i).resp = files(i).resp([exth(1) exth'+1]); 
    
    % calculate minute respiratory rate before release
    % rest_ct = resprate(R,[0 releasecue]);
    % calculate minute repiratory rate after release
    % swim_ct = resprate(R,[releasecue R.cue(end,1)]);
    
    % figure(1), clf, hold on
    % histogram(swim_ct), % histogram(rest_ct)
    % files(i).swim_ct = swim_ct; % store swim resp rate values
end

%%
for i = [100:103] % Greenland Humpback Whales
    
    R = loadaudit(files(i).tag);
    
    % find breath cues only
     [~,breath] = findaudit(R,'r'); 
     if isempty(breath.cue) == 1
          [~,breath] = findaudit(R,'b'); 
     end
     
    
    % plot to check
    %     t = (1:length(p))/fs;
    %     figure(1), clf, plot(t,-p), hold on, plot([releasecue releasecue],[-1 1],'k','LineWidth',2)
    
    % put resps in structure
    files(i).resp = unique(breath.cue(:,1)); % some files have duplicate resp entries?
    
    % calculate waiting times between breaths
    files(i).tdiff = diff(unique(breath.cue(:,1)));
    files(i).tdiff = files(i).tdiff(find(files(i).tdiff > th));
end

cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\BreathCounts
save('countdata','files')



return 
%% plot all
figure(2), clf, hold on
for i = 1:length(files)
plot(files(i).lnth-rand(1,length(files(i).swim_ct)),files(i).swim_ct-rand(1,length(files(i).swim_ct)),'o','color',files(i).col)
end
xlabel('Body Length (m)'), ylabel('Minute Respiration')
% save
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\BreathCounts
print -dpng -r300 BreathCounts_All
%%
figure(3), clf, hold on
for i = 1:length(files)
plot(files(i).lnth,mean(files(i).swim_ct),'o','color',files(i).col,'markerfacecolor',files(i).col)
plot(files(i).lnth,median(files(i).swim_ct),'*','color',files(i).col)
errorbar(files(i).lnth,mean(files(i).swim_ct),std(files(i).swim_ct),'o','color',files(i).col)
end
xlabel('Body Length (cm)'), ylabel('Minute Respiration')
xlim([100 600]), % ylim([0.5 4.5])




print -dpng -r300 BreathCounts_MeanMedian

figure(4), clf, hold on
for i = 1:length(files)
    plot(sort(files(i).tdiff),(1:length(files(i).tdiff))/length(files(i).tdiff),'color',files(i).col)
end
xlabel('Waiting Time (sec)'), ylabel('Proportion of Samples')

print -dpng -r300 BreathCounts_CDF