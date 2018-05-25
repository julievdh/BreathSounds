%% beluga audit data example for manolo

% load tag
tag = 'dl16_135a';
R = loadaudit(tag);

% find surfacings 
surf = findaudit(R,'surf'); 
resph = findaudit(R,'resph');

figure(1)
% plot mean inter-surface interval
subplot(121),
histogram(diff(resph(:,1)))
xlabel('Interval (s)')
ylabel('Count')

% plot duration of those surfacings 
subplot(122), hold on
histogram(resph(:,2))
histogram(surf(:,2))
xlabel('Duration (s)')

