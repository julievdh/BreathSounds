% Import MasterBreathTable for PCA

close all
load('AllBreaths_noPEAK')

% headers = {'e 95 duration','e EFD','e RMS','e PP','e Fcent','e Fmax',...
%     'i 95 duration','i EFD','i RMS','i PP','i Fcent','i Fmax',...
%     'End Tidal O2','End Tidal CO2','Max Insp Flow','Max Exp Flow','VT'};

%% PCA

%% SET UP INDICES
kolohe = find(MATCHED(:,17) == 1);
liko = find(MATCHED(:,17) == 2);
lono = find(MATCHED(:,17) == 3);
nainoa = find(MATCHED(:,17) == 4);

before = find(MATCHED(:,18) == 1);
after = find(MATCHED(:,18) == 2);
deck = find(MATCHED(:,18) == 3);
water = find(MATCHED(:,18) == 4);

DQO = find(MATCHED(:,20) == 1);
SARASOTA = find(MATCHED(:,20) == 2);

BOAT = find(MATCHED(DQO,19) > 14 & MATCHED(DQO,19) < 17);
NOBOAT = find(MATCHED(DQO,19) < 15 | MATCHED(DQO,19) > 16);

% ALL BREATHS MATCHED HAVE PNEUMOTACH ON

[U,summary,AR,SR] = pca2(MATCHED(:,1:16),1);
%%
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


% Varimax
Ar = AR(:,1:3); % select first 3 factors
Arot = varimax(Ar);

% plot factor scores
figure
hold on
plot(Arot); plot(AR(:,1:3),'--')
legend('PC1','PC2','PC3')
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'...
    'ET O_2','ET CO_2','Max Insp Flow','Max Exp Flow','VT','LO_2 consumed'};
set(gca,'Xtick',[1:16])
set(gca,'Xticklabel',vlbs)


% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

%% BIPLOT
figure
biplot(Arot(:,1:3),'scores',SR(:,1:3),'varlabels',vlbs)

%% Plot factor-factor relationships
figure
plot(SR(before,1),SR(before,2),'.'); hold on
plot(SR(after,1),SR(after,2),'g.');
xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)'));
legend('Before Swim','After Swim')

%% PLOT BY INDIVIDUAL
figure(10)
plot3(SR(kolohe,1),SR(kolohe,2),SR(kolohe,3),'b.'); hold on
plot3(SR(liko,1),SR(liko,2),SR(liko,3),'g.');
plot3(SR(lono,1),SR(lono,2),SR(lono,3),'k.'); 
plot3(SR(nainoa,1),SR(nainoa,2),SR(nainoa,3),'r.'); 
xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))
legend('Kolohe','Liko','Lono','Nainoa')

% PLOT BY BEFORE/AFTER
figure(11)
plot3(SR(before,1),SR(before,2),SR(before,3),'b.'); hold on
plot3(SR(after,1),SR(after,2),SR(after,3),'g.')
plot3(SR(deck,1),SR(deck,2),SR(deck,3),'r.')
plot3(SR(water,1),SR(water,2),SR(water,3),'k.')
xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))
legend('Before Swim','After Swim','Deck','Water')

% PLOT BY LOCATION
figure(14)
plot3(SR(DQO,1),SR(DQO,2),SR(DQO,3),'c.'); hold on
plot3(SR(SARASOTA,1),SR(SARASOTA,2),SR(SARASOTA,3),'k.');
legend('Dolphin Quest','Sarasota')
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));


% PLOT BOAT
figure(13)
plot3(SR(BOAT,1),SR(BOAT,2),SR(BOAT,3),'c.'); hold on
plot3(SR(NOBOAT,1),SR(NOBOAT,2),SR(NOBOAT,3),'k.');
legend('No Boat','Boat')

%% PLOT BY FILE?
filec = rand(32,3);
figure(12)
% for DQO
for file = 1:17
    ind = find(MATCHED(:,19) == file & MATCHED(:,20) == 1);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file,:)); hold on
end
% for SARASOTA
for file = 1:15
    ind = find(MATCHED(:,19) == file & MATCHED(:,20) == 2);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file+17,:)); hold on
end


xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))


return


%% ANIMATE PLOT WITH SINGLE INDIVIDUALS AS THEY GO THROUGH BEFORE AND AFTER

for file = 1:17
    point = 1;
    ind = find(MATCHED(:,19) == file);
    while point < length(ind)
        plot3(SR(ind(point:point+1),1),SR(ind(point:point+1),2),SR(ind(point:point+1),3),'-','color',filec(file,:)); hold on
        point = point+1;
     pause
    end
end


