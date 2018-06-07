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

% save .csv with start-end of surfacing/breath
allsrfint = [allsrf(:,1) allsrf(:,1)+allsrf(:,2) allsrf(:,2)]; 
csvwrite([cd '\BreathCounts\' tag '_surfs.csv'],allsrfint); 

end

figure(3), set(gcf,'paperpositionmode','auto')
print([cd '\BreathCounts\RespSurfInterval_all'],'-dpng','-r300')

figure(4), set(gcf,'paperpositionmode','auto')
print([cd '\BreathCounts\RespSurfDuration_all'],'-dpng','-r300')

%% for 2016 tags with good depth 
tags = {'dl16_133a','dl16_134a','dl16_135a','dl16_136a','dl16_138a'}; 

for k = 1:length(tags)
    tag = tags{k};
% load prh
loadprh(tag)
p = correctdepth(p,fs); 

%figure(10); clf, hold on; warning off
%t = (1:length(p))/fs;   % time in seconds
%plot(t,-p)
%% FIND DIVES
T = finddives(p,fs,.25,0.25,0);
% plot dives 
%for i = 1:size(T,1)
%    plot(t(T(i,1)*fs:T(i,2)*fs),-p(T(i,1)*fs:T(i,2)*fs),'g')
%end

%% FIND PERIODS BETWEEN DIVES: matrix of S surfacings
S = nan(length(T),2);
S(1,1) = 1; S(1,2) = T(1,1); % assume tag begins at surface before first dive
S(2:length(T),1) = T(1:end-1,2);
S(2:length(T),2) = T(2:end,1);
S(:,3) = S(:,2)-S(:,1); % calculate surfacing duration
ii = find(S(:,3) > 0); 
S = S(ii,:); 

% % plot surfacings
% for i = 1:length(S)
%     plot(t(S(i,1)*fs:S(i,2)*fs),-p(S(i,1)*fs:S(i,2)*fs),'r')
% end

% time between each surfacing 
figure(6), set(gcf,'position',[2.4883    0.0457    1.2527    0.4200]*1E3)
h2 = subplot(2,3,k); hold on
histogram(S(:,3),0:0.5:10)
xlabel('Duration (s)')
title(regexprep(tag,'_','  '))
text(0.5*h2.XLim(2),0.8*h2.YLim(2),['mean: ' sprintf('%1.2f',mean(S(:,3)))])
text(0.5*h2.XLim(2),0.65*h2.YLim(2),['median: ' sprintf('%1.2f',median(S(:,3)))])

end

