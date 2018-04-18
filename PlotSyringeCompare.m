% PlotSyringeCompare - compare simultaneous tags on syringe for FlowSound 

% 3 April 2018

%% after having done FlowSoundPlot_Syringe 152, now can plot those data against each other

% load in data for both files 
tag1 = load([tags(1).name '_flowsound.mat']);
tag2 = load([tags(2).name '_flowsound.mat']);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\' 
% plot error comparison 
%% 
figure(27), clf, hold on
if length(minflow) > 5
plot(-minflow(pon),[tag1.allstore(:).erroro],'^')
plot(-mxflow(pon),[tag1.allstore(:).errori],'v')
plot(-minflow(pon),[tag1.allstore(:).erroro2],'^')
plot(-mxflow(pon),[tag1.allstore(:).errori2],'v')
plot(-minflow(pon),[tag2.allstore(:).erroro2],'^')
plot(-mxflow(pon),[tag2.allstore(:).errori2],'v')
plot(-minflow(pon),[tag2.allstore(:).erroro],'^')
plot(-mxflow(pon),[tag2.allstore(:).errori],'v')

plot(-minflow(pon),tag1.VTerre(:,pon),'k^')
plot(-mxflow(pon),tag1.VTerri(:,pon),'kv')
plot(-minflow(pon),tag2.VTerre(:,pon),'k^')
plot(-mxflow(pon),tag2.VTerri(:,pon),'kv')
else 
    minflow = [minflow{:}]; mxflow = [mxflow{:}];
plot(-minflow,[tag1.allstore(:).erroro],'^')
plot(-mxflow,[tag1.allstore(:).errori],'v')
plot(-minflow,[tag1.allstore(:).erroro2],'^')
plot(-mxflow,[tag1.allstore(:).errori2],'v')
plot(-minflow,[tag2.allstore(:).erroro2],'^')
plot(-mxflow,[tag2.allstore(:).errori2],'v')
plot(-minflow,[tag2.allstore(:).erroro],'^')
plot(-mxflow,[tag2.allstore(:).errori],'v')

plot(-minflow,tag1.VTerre(:,pon),'k^')
plot(-mxflow,tag1.VTerri(:,pon),'kv')
plot(-minflow,tag2.VTerre(:,pon),'k^')
plot(-mxflow,tag2.VTerri(:,pon),'kv')
end

% plot within tags, between tags 
figure(21), clf, hold on 
set(gcf,'position',1000*[2.0637    0.0990    1.1680    0.4280])
subplot(121), hold on %% note hydrophones are 'numbered' arbitrarily and this way plots look better with inset
title('Within Tags')
plot(tag1.VTesti(1,:),tag1.VTesti(2,:),'v') % inhale T1
plot(tag2.VTesti(1,:),tag2.VTesti(2,:),'v') % inhale T2
plot(tag1.VTest(1,:),tag1.VTest(2,:),'^') % exhale T1
plot(tag2.VTest(1,:),tag2.VTest(2,:),'^') % exhale T2
legend('Inhale T1','Inhale T2','Exhale T1', 'Exhale T2','Location','NW')

xlabel('VT Estimate - Hydrophone 1'), ylabel('VT Estimate - Hydrophone 2')
xlim([0 14]), ylim([0 14])

subplot(122), hold on 
title('Between Tags')
plot(tag1.VTesti(1,:),tag2.VTesti(1,:),'v') % inhale hydrophone 1 
plot(tag1.VTesti(2,:),tag2.VTesti(2,:),'v') % inhale hydrophone 2
plot(tag1.VTest(1,:),tag2.VTest(1,:),'^') % exhale hydrophone 1
plot(tag1.VTest(2,:),tag2.VTest(2,:),'^') % exhale hydrophone 2 
legend('Inhale H1','Inhale H2','Exhale H1', 'Exhale H2')
xlabel('VT estimate - Tag 1'), ylabel('VT estimate - Tag 2')
xlim([0 14]), ylim([0 14])

print([cd '\AnalysisFigures\dualsyringecal_withinbetween_FlowSound'], '-dpng', '-r300')

%% fit relationship between flow rate and error?
lmo1 = fitlm([tag1.allstore(:).erroro],-minflow);
lmi1 = fitlm([tag1.allstore(:).errori],-mxflow);
lmo2 = fitlm([tag2.allstore(:).erroro],-minflow);
lmi2 = fitlm([tag2.allstore(:).errori],-mxflow);

% compare lm results between tags (use this to compare between syringe and
% real animals too
numerator = (lmi2.SSE-lmi1.SSE)/(lmi1.NumCoefficients);
denominator = lmi1.SSE/lmi1.DFE;
F = numerator/denominator;
p = 1-fcdf(F,lmi1.NumCoefficients,lmi1.DFE);