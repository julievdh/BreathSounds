% PCA drag analysis
% 8 Dec 2014


% load in data
load('dragPCA')

%% PCA
[U,summary,AR,SR] = pca2(DF,1);

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
plot(Arot)

% select only factor loadings that explain > 25% of variance
Arot(abs(Arot)<=0.5)=0

%% Plot factor-factor relationships
figure
plot(SR(:,1),SR(:,2),'.'); hold on
xlabel('Factor 1'); ylabel('Factor 2')

tcue = etime(DEPLOY.TRIAL.STARTSWIM, DEPLOY.TAGON.TIME);
before = find(R.cue(CUE_R) <= tcue);
after = find(R.cue(CUE_R) > tcue);
plot(SR(before,1),SR(before,2),'b.')
plot(SR(after,1),SR(after,2),'g.')

figure
plot(SR(:,1),SR(:,3),'.'); hold on
plot(SR(before,1),SR(before,3),'b.')
plot(SR(after,1),SR(after,3),'g.')
xlabel('Factor 1'); ylabel('Factor 3')

figure
plot3(SR(before,1),SR(before,2),SR(before,3),'b.'); hold on
plot3(SR(after,1),SR(after,2),SR(after,3),'g.')
xlabel('Factor 1'); ylabel('Factor 2'); zlabel('Factor 3')
