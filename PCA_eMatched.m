% Import all exhalations that are matched
load('eMatched')

%% PCA

% create data matrix
MATCHED = [etimewindow eEFD eRMS ePP eFcent ETO2 ETCO2 MaxInspFlow MaxExpFlow VT LO2consumed];
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'ET O_2','ET CO_2','Max Insp Flow','Max Exp Flow','VT','LO_2 consumed'};

DQO = find(Location == 1);
SARASOTA = find(Location == 2);

deck = find(State(SARASOTA) == 3);
water = find(State(SARASOTA) == 4);

[U,summary,AR,SR] = pca2(MATCHED(SARASOTA,:),1);

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
set(gca,'Xtick',[1:16])
set(gca,'Xticklabel',vlbs)


% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

%% BIPLOT
figure
biplot(Arot(:,1:3),'scores',SR(:,1:3),'varlabels',vlbs)

%% PLOT BY STATE
figure(11); hold on
plot3(SR(deck,1),SR(deck,2),SR(deck,3),'r.')
plot3(SR(water,1),SR(water,2),SR(water,3),'k.')
xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))
legend('Deck','Water')

%% PLOT BY FILE
filec = rand(16,3);
figure(20)
% for SARASOTA
for file = 1:15
    ind = find(file_i(SARASOTA) == file);
plot3(SR(ind,1),SR(ind,2),SR(ind,3),'.','color',filec(file,:)); hold on
end


xlabel(strcat('Factor 1 (',num2str(summary(1,2)*100),'%)')); 
ylabel(strcat('Factor 2 (',num2str(summary(2,2)*100),'%)')); 
zlabel(strcat('Factor 3 (',num2str(summary(3,2)*100),'%)'))

