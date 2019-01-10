% plot syringe assessment - 147z
% called upon by FlowSoundApply_Syringe 
% 28 March 2018

s1 = 1:5:71; % flow speed 1
s2 = 2:5:72; % 2
s3 = 3:5:73; % 3
s4 = 4:5:74; % 4
s5 = 5:5:75; % 5

c = colormap(viridis);

VTefill = VTe; 
VTefill(isnan(VTe)) = nanmean(VTe);
VTifill = VTi; 
VTifill(isnan(VTi)) = nanmean(VTi);


figure(29), clf, hold on 
plot([0 15],[0 15],'color',[0.5 0.5 0.5])

plot(VTest(:,s1),VTe(s1),'^','color',c(1,:))
plot(VTest(:,s2),VTe(s2),'^','color',c(50,:))
plot(VTest(:,s3),VTe(s3),'^','color',c(100,:))
plot(VTest(:,s4),VTe(s4),'^','color',c(150,:))
plot(VTest(:,s5),VTe(s5),'^','color',c(250,:))

plot(VTesti(:,s1),VTi(s1),'v','color',c(1,:))
plot(VTesti(:,s2),VTi(s2),'v','color',c(50,:))
plot(VTesti(:,s3),VTi(s3),'v','color',c(100,:))
plot(VTesti(:,s4),VTi(s4),'v','color',c(150,:))
plot(VTesti(:,s5),VTi(s5),'v','color',c(250,:))

ylabel('Measured VT'), xlabel('Estimated VT')


% colour these by flow and distance
figure(1), clf, hold on 
plot(VTest(2,:),'color',[0.5 0.5 0.5])
plot(VTest(1,:),'color',[0.5 0.5 0.5])

plot(s1,VTest(:,s1),'^','color',c(1,:))
plot(s2,VTest(:,s2),'^','color',c(50,:))
plot(s3,VTest(:,s3),'^','color',c(100,:))
plot(s4,VTest(:,s4),'^','color',c(150,:))
plot(s5,VTest(:,s5),'^','color',c(250,:))

VTe(VTe == 0) = NaN; 
plot(VTe,'k-')

plot(-VTesti(2,:),'color',[0.5 0.5 0.5])
plot(-VTesti(1,:),'color',[0.5 0.5 0.5])

plot(s1,-VTesti(:,s1),'v','color',c(1,:))
plot(s2,-VTesti(:,s2),'v','color',c(50,:))
plot(s3,-VTesti(:,s3),'v','color',c(100,:))
plot(s4,-VTesti(:,s4),'v','color',c(150,:))
plot(s5,-VTesti(:,s5),'v','color',c(250,:))

VTi(VTi == 0) = NaN; 
plot(-VTi,'k-')

ylabel('Air Volume (L)')