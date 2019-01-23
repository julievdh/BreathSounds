figure(4), clf, hold on
q = find(Quality == 20); % free-swimming, good quality
iRR = 60./diff(breath.cue(q)); 

% add contours of minute ventilation
VTrange = 0:0.5:16;
% range of breaths/min
frange = 0:1:30;

VEcontour(:,1) = repmat(10,1,length(frange))./frange;
VEcontour(:,2) = repmat(30,1,length(frange))./frange; 
VEcontour(:,3) = repmat(50,1,length(frange))./frange; 
VEcontour(:,4) = repmat(70,1,length(frange))./frange;
VEcontour(:,5) = repmat(90,1,length(frange))./frange; 
VEcontour(:,6) = repmat(110,1,length(frange))./frange; 


plot(VEcontour,frange,'color',[0.75 0.75 0.75])
xlim([min(VTrange) max(VTrange)])
ylim([0 16])

plot(VTi_swim(2:end),iRR,'o-')
xlabel('Tidal Volume (L)')
ylabel('Frequency (breaths/min)')
