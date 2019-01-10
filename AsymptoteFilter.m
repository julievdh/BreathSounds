% power spectrum of flow data
% get 10 s of pneumotach data
flow = all_RAWDATA(locs(n)-1001:locs(n)+1000,:);
mnflow = mean(flow); % remove zero-offset
flow = flow - repmat(mnflow,2002,1);

figure(12), clf, hold on
[Y,P1,f] = plotfft(flow(:,2),fs);

% find mid-point of asymptote 
point = find(P1 > (max(P1)-mean(P1(end-200:end)))*0.3,1,'last');
plot([f(point) f(point)],[0 2])
mid = find(P1 > (max(P1)-mean(P1(end-200:end)))*0.5,1,'last');
plot([f(mid) f(mid)],[0 2])