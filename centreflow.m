data = cuts(n).flow;

% subtract mean to zero entire data series
data(:,2) = data(:,2) - mean(data(:,2));

% find data in mid-range (around mean value)
ii = find(data(:,2) < 5 & data(:,2) > -5);
figure(1), clf, hold on
plot(data(:,1),data(:,2))
plot(data(ii,1),data(ii,2),'k.','MarkerSize',20)

% find where these values are not monotonically increasing (i.e. a breath)
diff = ii(2:end) - ii(1:end-1);
ind = find(diff ~= 1);

% eliminate any indices inside breath 
for i = 1:length(ind)
ii(ind(i)-20:ind(i)+20) = NaN;
end
ii(isnan(ii)) = [];

plot(data(ii,1),data(ii,2),'r.','MarkerSize',20)


% plot final, corrected data
plot(data(:,1),data(:,2),'k')

%% find where below zero
% find below zero after exhalation
if isnan(exp(CUE_R(n))) == 1
    ij = find(data(:,1) > cuts(n).flow(1,1)+ins(CUE_R(n),1)-0.2);
else
ij = find(data(:,1) > cuts(n).flow(1,1)+exp(CUE_R(n),2));
end
ii = find(data(:,2) < 0);
inhl = intersect(ij,ii);
plot(data(inhl,1),data(inhl,2))
stinhl = inhl(1);
% rest of inhalation where it's increasing until the change-point
[peaks,idx]=findpeaks(data(ij,2),'minpeakheight',2);
plot(data(ij(idx),1),peaks,'*')
endinhl = ij(idx(find(ij(idx) > inhl(1))));
plot(data(stinhl:endinhl,1),data(stinhl:endinhl,2),'c')
