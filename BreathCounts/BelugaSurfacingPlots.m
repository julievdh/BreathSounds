%% beluga audit data example for manolo

% load tag
tag = 'dl16_135a';
R = loadaudit(tag);

% find surfacings 
surf = findaudit(R,'surf'); 
resph = findaudit(R,'resph');

figure(1), clf
% plot mean inter-surface interval
h1 = subplot(121);
histogram(diff(resph(:,1)))
xlabel('Interval (s)')
ylabel('Count')
text(0.6*h1.XLim(2),0.9*h1.YLim(2),['mean: ' num2str(mean(diff(resph(:,1))))])
text(0.6*h1.XLim(2),0.85*h1.YLim(2),['median: ' num2str(median(diff(resph(:,1))))])


% plot duration of those surfacings 
h2 = subplot(122); hold on
histogram(resph(:,2))
histogram(surf(:,2))
legend('Breath','Surfacing')
xlabel('Duration (s)')
ylabel('Count')
text(0.6*h2.XLim(2),0.8*h2.YLim(2),['mean: ' num2str(mean(resph(:,2)))])
text(0.6*h2.XLim(2),0.75*h2.YLim(2),['median: ' num2str(median(resph(:,2)))])
text(0.6*h2.XLim(2),0.7*h2.YLim(2),['mean: ' num2str(mean(surf(:,2)))])
text(0.6*h2.XLim(2),0.65*h2.YLim(2),['median: ' num2str(median(surf(:,2)))])

print([cd '\BreathCounts\RespSurfDistribution_' 'tag'],'-dpng','-r300')

%% requested from Manolo: interval between midpoints of consecutive surfacings

tags = {'dl16_135a'}; 
for k = 1:length(tags)
% load audit
tag = tags{k}; 
R = loadaudit(tag);

% find resph or surf 
[cues,R] = findbreathcues(R); 

% calculate midpoints
mdpt = cues(:,1)+cues(:,2)/2; 

% calculate interval between midpoints 
intrvl = diff(mdpt); 

% plot
figure(3), subplot(k,2,k)
histogram(intrvl)

end
