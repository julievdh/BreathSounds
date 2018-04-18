% Import MasterBreathTable for PCA

close all
load('AllBreaths_noPEAK')

% headers = {'e 95 duration','e EFD','e RMS','e PP','e Fcent',...
%     'i 95 duration','i EFD','i RMS','i PP','i Fcent',...
%     'End Tidal O2','End Tidal CO2','Max Insp Flow','Max Exp Flow','VT'};

%% PCA
%% SET UP INDICES
kolohe = find(BREATHONLY(:,11) == 1);
liko = find(BREATHONLY(:,11) == 2);
lono = find(BREATHONLY(:,11) == 3);
nainoa = find(BREATHONLY(:,11) == 4);

before = find(BREATHONLY(:,12) == 1);
after = find(BREATHONLY(:,12) == 2);
deck = find(BREATHONLY(:,12) == 3);
water = find(BREATHONLY(:,12) == 4);
swim = find(BREATHONLY(:,12) == 5);

ON = find(BREATHONLY(:,14) == 1);
OFF = find(BREATHONLY(:,14) == 0);

BOAT = find(BREATHONLY(DQO,13) > 14 & BREATHONLY(DQO,13) < 17);
NOBOAT = find(BREATHONLY(DQO,13) < 15 | BREATHONLY(DQO,13) > 16);

SARASOTA = find(BREATHONLY(:,15) == 2);
DQO = find(BREATHONLY(:,15) == 1);

[U,summary,AR,SR] = pca2(BREATHONLY(DQO,1:10),1);

% Determine how many factors to use
% Summary suggests how much of variance is explained by how many factors
% What about the cumulative communalities across factors? 
% Each column in CC is the cumulative communality of each factor for
% each property
for i=1:length(AR)
    for j=1:length(AR)
        CC(i,j)=sum(AR(i,1:j).^2);
    end
end
CC

% Varimax
Ar = AR(:,1:2); % select first 2 factors
Arot = varimax(Ar);

% plot factor scores
figure
hold on
plot(Arot); plot(Ar,'--')
legend('PC1','PC2')
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent','i.time window','i.EFD','i.RMS','i.PP','i.Fcent'}';
set(gca,'Xticklabel',vlbs)

% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

figure
biplot(Arot(:,1:2),'scores',SR(:,1:2),'varlabels',vlbs)



% Plot Factor-Factor
figure(3)
plot(SR(before,1),SR(before,2),'.'); hold on
plot(SR(after,1),SR(after,2),'g.');
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)'));
legend('Before swim','After swim')

% PLOT BY INDIVIDUAL
figure(10)

plot(SR(kolohe,1),SR(kolohe,2),'b.'); hold on
plot(SR(liko,1),SR(liko,2),'g.');
plot(SR(lono,1),SR(lono,2),'k.'); 
plot(SR(nainoa,1),SR(nainoa,2),'r.'); 
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
legend('Kolohe','Liko','Lono','Nainoa')

%% PLOT BY BEFORE/AFTER
figure(11)
plot(SR(before,1),SR(before,2),'b.'); hold on
plot(SR(after,1),SR(after,2),'g.')
plot(SR(deck,1),SR(deck,2),'r.')
plot(SR(water,1),SR(water,2),'k.')
plot(SR(swim,1),SR(swim,2),'c.')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
legend('Before Swim','After Swim','Deck','Water','Swim')

% PLOT BOAT
figure(13)
plot(SR(BOAT,1),SR(BOAT,2),'c.'); hold on
plot(SR(NOBOAT,1),SR(NOBOAT,2),'k.');
legend('No Boat','Boat')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 


% PLOT SARASOTA vs DQ
figure(14)
plot(SR(DQO,1),SR(DQO,2),'c.'); hold on
plot(SR(SARASOTA,1),SR(SARASOTA,2),'k.');
legend('Dolphin Quest','Sarasota')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 

return 

%% PLOT BY FILE?
filec = rand(17,3);
figure(12)
for file = 1:17
    ind = find(BREATHONLY(ON,15) == file);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file,:)); hold on
end
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));

%% ANIMATE PLOT WITH SINGLE INDIVIDUALS AS THEY GO THROUGH BEFORE AND AFTER

for file = 1:17
    point = 1;
    ind = find(BREATHONLY(ON,15) == file);
    while point < length(ind)
        plot3(SR(ind(point:point+1),1),SR(ind(point:point+1),2),SR(ind(point:point+1),3),'-','color',filec(file,:)); hold on
        point = point+1;
 pause
    end
end
