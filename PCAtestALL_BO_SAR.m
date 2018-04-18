% Import MasterBreathTable for PCA

close all
load('AllBreaths_noPEAK')

% headers = {'e 95 duration','e EFD','e RMS','e PP','e Fcent',...
%     'i 95 duration','i EFD','i RMS','i PP','i Fcent',...
%     'End Tidal O2','End Tidal CO2','Max Insp Flow','Max Exp Flow','VT'};

%% PCA
%% SET UP INDICES
SARASOTA = find(BREATHONLY(:,15) == 2);
DQO = find(BREATHONLY(:,15) == 1);

deck = find(BREATHONLY(SARASOTA,12) == 3);
water = find(BREATHONLY(SARASOTA,12) == 4);
swim = find(BREATHONLY(SARASOTA,12) == 5);

ON = find(BREATHONLY(SARASOTA,14) == 1);
OFF = find(BREATHONLY(SARASOTA,14) == 0);

% PCA
[U,summary,AR,SR] = pca2(BREATHONLY(SARASOTA,1:10),1);

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
plot(Arot); plot(Ar,'--')
legend('PC1','PC2')
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent','i.time window','i.EFD','i.RMS','i.PP','i.Fcent'}';
set(gca,'Xticklabel',vlbs)

% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

figure
biplot(Arot(:,1:3),'scores',SR(:,1:3),'varlabels',vlbs)

% PLOT DECK/WATER/SWIM
figure(6)
plot3(SR(deck,1),SR(deck,2),SR(deck,3),'b.'); hold on
plot3(SR(water,1),SR(water,2),SR(water,3),'g.');
plot3(SR(swim,1),SR(swim,2),SR(swim,3),'k.'); 
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
legend('Deck','Water','Swim')


% PLOT BY INDIVIDUAL
% figure(10)
% 
% plot(SR(kolohe,1),SR(kolohe,2),'b.'); hold on
% plot(SR(liko,1),SR(liko,2),'g.');
% plot(SR(lono,1),SR(lono,2),'k.'); 
% plot(SR(nainoa,1),SR(nainoa,2),'r.'); 
% xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
% ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
% legend('Kolohe','Liko','Lono','Nainoa')
 

%% PLOT BY FILE?
filec = rand(17,3);
figure(12)
for file = 1:15
    ind = find(BREATHONLY(SARASOTA,13) == file);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file,:)); hold on
end
xlabel(strcat('Factor 1 (',num2str(summary(1,3)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str((summary(2,3)-summary(1,3))*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str((summary(3,3)-summary(2,3))*100),'%)'));

return

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
