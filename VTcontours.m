% VT contours

figure(12), clf, hold on 
%scatter([allstore(:).dex],abs([allstore(:).mnflowE]),20,VTe2(~isnan(VTe2)),'^')
%scatter([allstore(:).din],abs([allstore(:).mnflowI]),20,abs(VTi2(~isnan(VTi2))),'v')
scatter([allstore(:).din],abs([allstore(:).mnflowI]),20,abs(VTerri(1,~isnan(VTest(1,:))))','v','filled')
scatter([allstore(:).dex],abs([allstore(:).mnflowE]),20,abs(VTerre(1,~isnan(VTest(1,:))))','^','filled')


% range of durations
drange = 0:0.05:max([allstore(:).din]);
% range of flows
frange = 0:1:50;

xlim([min(drange) max(drange)])

VTcontour5 = repmat(5,1,length(frange))./frange;
VTcontour7 = repmat(7,1,length(frange))./frange; 
VTcontour10 = repmat(10,1,length(frange))./frange; 

plot(VTcontour5,frange,'color',[0.75 0.75 0.75])
plot(VTcontour7,frange,'color',[0.75 0.75 0.75])
plot(VTcontour10,frange,'color',[0.75 0.75 0.75])

xlabel('Duration (s)'), ylabel('Mean flow rate (L/s)')
h = colorbar; 
ylabel(h,'VT estimate error (L)')