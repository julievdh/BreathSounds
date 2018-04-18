% Import MasterBreathTable for PCA

close all
load('AllBreaths_noPEAK')

% headers = {'e 95 duration','e EFD','e RMS','e PP','e Fcent','e Fmax',...
%     'i 95 duration','i EFD','i RMS','i PP','i Fcent','i Fmax',...
%     'End Tidal O2','End Tidal CO2','Max Insp Flow','Max Exp Flow','VT'};

%% PCA

%% SET UP INDICES
DQO = find(MATCHED(:,20) == 1);
SARASOTA = find(MATCHED(:,20) == 2);

deck = find(MATCHED(SARASOTA,18) == 3);
water = find(MATCHED(SARASOTA,18) == 4);

% ALL BREATHS MATCHED HAVE PNEUMOTACH ON

[U,summary,AR,SR] = pca2(MATCHED(SARASOTA,1:16),1);
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

% PLOT BY BEFORE/AFTER
figure(11); hold on
plot3(SR(deck,1),SR(deck,2),SR(deck,3),'r.')
plot3(SR(water,1),SR(water,2),SR(water,3),'k.')
xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))
legend('Deck','Water')

%% PLOT BY FILE?
filec = rand(16,3);
figure(12)
% for SARASOTA
for file = 1:15
    ind = find(MATCHED(SARASOTA,19) == file);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file,:)); hold on
end


xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))

%% PLOT BY INDIVIDUAL

filec = rand(10,3);
figure(20); hold on
indv = [133; 142; 164; 175; 185; 196; 241; 242; 268; 276];
for id = 1:length(indv)
    ind = find(MATCHED(SARASOTA,17) == indv(id));
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(id,:)); hold on
end
legend(num2str(indv))
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


