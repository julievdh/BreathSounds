% a template-based filter to remove the boat or tag noise in Sarasota
% tt14_128a
% select segments
load('tt14_128a_filterseg') % seg is a start point of each segment

% time-align segments
tmp(:,1) = s(seg(1):seg(2)); 
for i = 2:length(seg)-1;
    sseg = s(seg(i):seg(i)+length(tmp)-1); 
xc = xcorr(sseg,tmp(:,1),'coeff'); % cross-correlate
[~,lag] = max(xc);
ac = xcorr(sseg,'coeff'); % auto-correlate
[~,reflag] = max(ac);

tmp(:,i) = circshift(sseg,[(reflag-lag) 0]);

figure(2), clf, hold on, 
plot(tmp(:,1)), plot(tmp(:,i))

end
plot(tmp)
plot(mean(tmp'),'k','linewidth',2)

mntmp = mean(tmp')'; % average template 
% tukey window around peaks
[pks,locs] = findpeaks(mntmp,'minpeakheight',2E-4,'minpeakdistance',660);
tuk = zeros(length(mntmp),1); 
for i = 1:length(pks) % make a tukey window around each peak
    tuk(locs(i)-10:locs(i)+140,1) = tukeywin(151,0.1);
end
mntmp = mntmp.*tuk; 


%% move the template along the signal 
news = s; 
for i = 1:435237 % length(news)-length(tmp)
sseg = news(i:i+length(tmp)-1); % signal segment
R = corrcoef(sseg,mntmp); % compute correlation between signal and mean template
R2 = R(1,2).^2; 
 if R2 > 0.5
     % look one ahead 
     nxtsseg = news(i+1:i+length(tmp)); % signal segment
    R = corrcoef(nxtsseg,mntmp); % compute correlation between signal and mean template
    nxtR2 = R(1,2).^2; 
if nxtR2 < R2
    sseg = sseg - mntmp; % subtract mean template
    news(i:i+length(tmp)-1) = sseg; % put it back in the original signal
end
end
rsquared(i) = R2; 
end

figure(5), clf, hold on
plot(s), plot(news)