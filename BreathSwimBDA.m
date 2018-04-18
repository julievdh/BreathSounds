% plot breath sound duration E I before, during, after swim
clear all
%% load data
% load all DQ data currently audited
[~,D] = AllFilesImport(2); % 1 = Sarasota, 2 = DQ. Try to add 3 = both
%%
for i = 3:length(D)
%% calculate exhalation, inhalation duration
D(i).edur = D(i).exp(:,2) - D(i).exp(:,1);
D(i).idur = D(i).ins(:,2) - D(i).ins(:,1);

%% Get indices before, during, after swimming
D(i).swm = find(D(i).Quality >= 20); % during swimming 
D(i).bf = find(D(i).Quality(1:D(i).swm(1)-1) == 0); % good breaths before swim
D(i).af = D(i).swm(end)+find(D(i).Quality(D(i).swm(end)+1:end) == 0); % good breaths after swim
end
% plot, for example
% expiration duration before, during, after
figure(2)
subplot(311), title('Before Swim')
histogram(D(i).idur(D(i).bf))
subplot(312), title('During Swim')
histogram(D(i).idur(D(i).swm))
subplot(313), title('After Swim')
histogram(D(i).idur(D(i).af))

figure(3), clf, hold on
for i = 1:length(D)
plot(D(i).bf,D(i).idur(D(i).bf),'go--')
plot(D(i).swm,D(i).idur(D(i).swm),'bo--')
plot(D(i).af,D(i).idur(D(i).af),'ro--') 

plot(D(i).bf,D(i).edur(D(i).bf),'g.-','MarkerSize',10)
plot(D(i).swm,D(i).edur(D(i).swm),'b.-','MarkerSize',10)
plot(D(i).af,D(i).edur(D(i).af),'r.-','MarkerSize',10)
end
