% Import MasterBreathTable for PCA

close all
load('AllBreaths')

% headers = {'e 95 duration','e EFD','e RMS','e PP','e Fcent','e Fmax',...
%     'i 95 duration','i EFD','i RMS','i PP','i Fcent','i Fmax',...
%     'End Tidal O2','End Tidal CO2','Max Insp Flow','Max Exp Flow','VT'};

%% PCA
ON = find(BREATHONLY(:,16) == 1);
OFF = find(BREATHONLY(:,16) == 0);

[U,summary,AR,SR] = pca2(BREATHONLY(:,1:12),1);

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
Ar = AR(:,1:3); % select first 3 factors
Arot = varimax(Ar);

% plot factor scores
figure
hold on
plot(Arot); plot(Ar,'--')
legend('PC1','PC2','PC3')

% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

figure
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent','e.Fpeak','i.time window','i.EFD','i.RMS','i.PP','i.Fcent','i.Fpeak'}';
biplot(Arot(:,1:3),'scores',SR(:,1:3),'varlabels',vlbs)

%% FIND INDICES
kolohe = find(BREATHONLY(:,13) == 1);
liko = find(BREATHONLY(:,13) == 2);
lono = find(BREATHONLY(:,13) == 3);
nainoa = find(BREATHONLY(:,13) == 4);

before = find(BREATHONLY(:,14) == 1);
after = find(BREATHONLY(:,14) == 2);
deck = find(BREATHONLY(:,14) == 3);
water = find(BREATHONLY(:,14) == 4);
swim = find(BREATHONLY(:,14) == 5);

BOAT = find(BREATHONLY(:,15) > 14 & BREATHONLY(:,15) < 17);
NOBOAT = find(BREATHONLY(:,15) < 15 | BREATHONLY(:,15) > 16);

SARASOTA = find(BREATHONLY(:,17) == 2);
DQO = find(BREATHONLY(:,17) == 1);

% Plot Factor-Factor
figure
plot(SR(before,1),SR(before,2),'.'); hold on
plot(SR(after,1),SR(after,2),'g.');
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 

% PLOT BY INDIVIDUAL
figure(10)

plot3(SR(kolohe,1),SR(kolohe,2),SR(kolohe,3),'b.'); hold on
plot3(SR(liko,1),SR(liko,2),SR(liko,3),'g.');
plot3(SR(lono,1),SR(lono,2),SR(lono,3),'k.'); 
plot3(SR(nainoa,1),SR(nainoa,2),SR(nainoa,3),'r.'); 
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));
legend('Kolohe','Liko','Lono','Nainoa')

% PLOT BY BEFORE/AFTER
figure(11)
plot3(SR(before,1),SR(before,2),SR(before,3),'b.'); hold on
plot3(SR(after,1),SR(after,2),SR(after,3),'g.')
plot3(SR(deck,1),SR(deck,2),SR(deck,3),'r.')
plot3(SR(water,1),SR(water,2),SR(water,3),'k.')
plot3(SR(swim,1),SR(swim,2),SR(swim,3),'c.')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'));
legend('Before Swim','After Swim','Deck','Water')

% PLOT BOAT
figure(13)
plot3(SR(BOAT,1),SR(BOAT,2),SR(BOAT,3),'c.'); hold on
plot3(SR(NOBOAT,1),SR(NOBOAT,2),SR(NOBOAT,3),'k.');
legend('No Boat','Boat')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));

% PLOT SARASOTA vs DQ
figure(14)
plot3(SR(DQO,1),SR(DQO,2),SR(DQO,3),'c.'); hold on
plot3(SR(SARASOTA,1),SR(SARASOTA,2),SR(SARASOTA,3),'k.');
legend('Dolphin Quest','Sarasota')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));

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
