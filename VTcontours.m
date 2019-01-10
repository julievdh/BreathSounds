% VT contours

figure(12), clf, hold on 

if isfield(allstore,'din') == 0
for i = 1:length(allstore)
    if isempty(allstore(i).sounde) == 0
    allstore(i).dex = length(allstore(i).sounde)/ffs;
    end
    if isempty(allstore(i).soundi) == 0
    allstore(i).din = length(allstore(i).soundi)/ffs;
    end
end
end
%scatter([allstore(:).dex],abs([allstore(:).mnflowE]),20,VTe2(~isnan(VTe2)),'^')
%scatter([allstore(:).din],abs([allstore(:).mnflowI]),20,abs(VTi2(~isnan(VTi2))),'v')
scatter([allstore(:).din],abs([allstore(:).mnflowI]),20,'v')% abs(VTerri(1,~isnan(VTest(1,:))))','v','filled')
% scatter([allstore(:).dex],abs([allstore(:).mnflowE]),20,'^')% abs(VTerre(1,~isnan(VTest(1,:))))','^','filled')

% get mean estimated flow rates
for i = 1:length(allstore) 
mnflowIest_on(i)= nanmean(allstore(i).Festi); 
if isfield(allstore,'Fest') == 1
mnflowEest_on(i)= nanmean(allstore(i).Fest); 
else mnflowEest_on(i) = nanmean(allstore(i).Feste); 
end
end

scatter([allstore(:).din],abs(mnflowIest_on(~isnan(mnflowIest_on))),20,'v')
% scatter([allstore(:).dex],abs(mnflowEest_on(~isnan(mnflowEest_on))),20,'^')
   

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
%h = colorbar; 
%ylabel(h,'VT estimate error (L)')

%% plot all free-swimming estimated breaths too
figure(12), hold on 
q20 = find(Quality == 20); % find all free-swimming breaths

% compute mean estimated flow rate
for i = 1:length(surfstore)
    mnflowIest(i)= nanmean(surfstore(i).Festi); 
    mnflowEest(i) = nanmean(surfstore(i).Festo);
end
ins(:,3) = ins(:,2)-ins(:,1);
scatter(ins(q20(1:length(surfstore)),3),abs(mnflowIest),20,'*')

% range of durations
drange = 0:0.05:max(ins(:,3));
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
legend('Measured Inhale Rest','Estimated Inhale rest','Estimated Inhale Swim')


