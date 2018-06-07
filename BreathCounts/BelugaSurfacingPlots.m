%% beluga audit data example for manolo

% load tag
tag = 'dl16_138a';
R = loadaudit(tag);

% find surfacings 
surf = findaudit(R,'surf'); 
resph = findaudit(R,'resph');

% find any resphs within surfacings
wthn = iswithin(resph(:,1),[surf(:,1) surf(:,1)+surf(:,2)]);
uresph = resph(~wthn,:); % unique resps (not those within surfs)

allsrf = vertcat(surf,uresph); % combine
allsrf = sortrows(allsrf,1); % sort

figure(1), clf
% plot mean inter-surface interval
h1 = subplot(121);
histogram(diff(allsrf(:,1)))
xlabel('Interval (s)')
ylabel('Count')
title(regexprep(tag,'_','  '))
text(0.6*h1.XLim(2),0.9*h1.YLim(2),['mean: ' num2str(mean(diff(allsrf(:,1))))])
text(0.6*h1.XLim(2),0.85*h1.YLim(2),['median: ' num2str(median(diff(allsrf(:,1))))])


% plot duration of breaths and surfacings 
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

print([cd '\BreathCounts\RespSurfDistribution_' tag],'-dpng','-r300')

%% requested from Manolo: interval between midpoints of consecutive surfacings

tags = {'dl16_133a','dl16_134a','dl16_135a','dl16_136a','dl16_138a',...
    'dl14_237a','dl14_238a','dl14_240a'}; 
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
figure(3), h2 = subplot(2,4,k);
histogram(intrvl,0:10:400)
title(regexprep(tag,'_','  '))
text(0.5*h2.XLim(2),0.8*h2.YLim(2),['mean: ' num2str(mean(intrvl))])
text(0.5*h2.XLim(2),0.65*h2.YLim(2),['median: ' num2str(median(intrvl))])

end
