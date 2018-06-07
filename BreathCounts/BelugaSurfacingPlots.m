%% beluga audit data example for manolo

close all

tags = {'dl16_133a','dl16_134a','dl16_135a','dl16_136a','dl16_138a',...
    'dl14_237a','dl14_238a','dl14_240a'}; 
for k = 1:length(tags)
% load audit
tag = tags{k}; 
R = loadaudit(tag);

% find surfacings 
surf = findaudit(R,'surf'); 
resph = findaudit(R,'resph');

% find any resphs within surfacings
wthn = iswithin(resph(:,1),[surf(:,1) surf(:,1)+surf(:,2)]);
uresph = resph(~wthn,:); % unique resps (not those within surfs)

% requested from Manolo: interval between midpoints of consecutive surfacings
allsrf = vertcat(surf,uresph); % combine
allsrf = sortrows(allsrf,1); % sort

% calculate midpoints
mdpt = allsrf(:,1)+allsrf(:,2)/2; 

% calculate interval between midpoints 
intrvl = diff(mdpt); 


figure(1), clf
% plot mean inter-surface interval
h1 = subplot(121);
histogram(diff(allsrf(:,1)),0:10:400)
xlabel('Interval (s)')
ylabel('Count')
title(regexprep(tag,'_','  '))
text(0.6*h1.XLim(2),0.9*h1.YLim(2),['mean: ' sprintf('%1.2f',mean(diff(allsrf(:,1))))])
text(0.6*h1.XLim(2),0.85*h1.YLim(2),['median: ' sprintf('%1.2f',median(diff(allsrf(:,1))))])


% plot duration of breaths and surfacings 
h2 = subplot(122); hold on
histogram(resph(:,2),0:0.5:10)
histogram(surf(:,2),0:0.5:10)
legend('Breath','Surfacing')
xlabel('Duration (s)')
ylabel('Count')
text(0.6*h2.XLim(2),0.8*h2.YLim(2),['mean: ' sprintf('%1.2f',mean(resph(:,2)))])
text(0.6*h2.XLim(2),0.75*h2.YLim(2),['median: ' sprintf('%1.2f',median(resph(:,2)))])
text(0.6*h2.XLim(2),0.7*h2.YLim(2),['mean: ' sprintf('%1.2f',mean(surf(:,2)))])
text(0.6*h2.XLim(2),0.65*h2.YLim(2),['median: ' sprintf('%1.2f',median(surf(:,2)))])

print([cd '\BreathCounts\RespSurfDistribution_' tag],'-dpng','-r300')


% plot
figure(3), set(gcf,'position',[2.4883    0.0457    1.2527    0.4200]*1E3)
h2 = subplot(2,4,k);
histogram(intrvl,0:10:400)
xlabel('Interval (s)') % interval between all surfacings/breaths
title(regexprep(tag,'_','  '))
text(0.5*h2.XLim(2),0.8*h2.YLim(2),['mean: ' sprintf('%1.2f',mean(intrvl))])
text(0.5*h2.XLim(2),0.65*h2.YLim(2),['median: ' sprintf('%1.2f',median(intrvl))])

figure(4), set(gcf,'position',[2.4883    0.0457    1.2527    0.4200]*1E3)
h2 = subplot(2,4,k); hold on
%histogram(resph(:,2),0:0.5:10)
histogram(allsrf(:,2),0:0.5:10)
xlabel('Duration (s)')
title(regexprep(tag,'_','  '))
text(0.5*h2.XLim(2),0.8*h2.YLim(2),['mean: ' sprintf('%1.2f',mean(allsrf(:,2)))])
text(0.5*h2.XLim(2),0.65*h2.YLim(2),['median: ' sprintf('%1.2f',median(allsrf(:,2)))])

end

figure(3), set(gcf,'paperpositionmode','auto')
print([cd '\BreathCounts\RespSurfInterval_all'],'-dpng','-r300')

figure(4), set(gcf,'paperpositionmode','auto')
print([cd '\BreathCounts\RespSurfDuration_all'],'-dpng','-r300')
