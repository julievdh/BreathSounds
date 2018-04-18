% plot syringe assessment - 147z
% called upon by FlowSoundPlot_Syringe
% 28 March 2018
clear mxflow minflow 
% get max and min flow data
    for i = 1:length(cuts)
        if isempty(cuts(i).flow) == 0
            mxflow(:,i) = max(cuts(i).flow);
            minflow(:,i) = min(cuts(i).flow);
        else
            mxflow(:,i) = NaN; minflow(:,i) = NaN;
        end
    end
if exist('pon3','var')
    pon = pon3;
end

%%
s1 = pon(1):10:pon(end); % flow speed 1
s2 = pon(2):10:pon(end); % 2
s3 = pon(3):10:pon(end); % 3
s4 = pon(4):10:pon(end); % 4
s5 = pon(5):10:pon(end); % 5

c = colormap(viridis);

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

%% error figure
figure(27), clf, hold on
% frate = repmat(1:5,1,15); % or use maxflow here instead
plot(-minflow(pon),[allstore(:).erroro],'^')
plot(-mxflow(pon),[allstore(:).errori],'v')

% calculate calculated - estimated VT
VTerre(1,:) = VTest(1,:) - VTe;
VTerre(2,:) = VTest(2,:) - VTe;

VTerri(1,:) = VTesti(1,:) - VTi;
VTerri(2,:) = VTesti(2,:) - VTi;

plot(-minflow(pon),VTerre(1,pon),'k^')
plot(-mxflow(pon),VTerri(1,pon),'kv')
plot(-minflow(pon(1:5)),VTerre(1,pon(1:5)),'k^','markerfacecolor','k')
plot(-mxflow(pon(1:5)),VTerri(1,pon(1:5)),'kv','markerfacecolor','k')

xlabel('Flow Rate (L/s)'), ylabel('Error')
title(['Syringe ' regexprep(filename,'_','  ') ' error.png'])
legend('Exhale Flow Rate','Inhale Flow Rate','Exhale VT', 'Inhale VT','Location','best')
print([cd '/AnalysisFigures/Syringe' filename '_error.png'],'-dpng')