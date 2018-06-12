%FlowSoundPlot_Sarasota
%FlowSoundAssess
%load('6May2014_water_tt126b_FB142_resp_surfstore.mat')
%q20 = find(Quality == 20);

%% find Pxx in bands
F = 0:117.1875:1.2E5; % frequencies for SL calculations

B1 = find(F<1000);
B2 = find(F>=2500 & F <= 3500);

figure(88), clf, hold on
mnflowI = nan(1,length(allstore));
mxflowI = nan(1,length(allstore));

for i = 1:length(allstore)
    if ~isempty(allstore(i).Pxx_i)
        subplot(1,3,1:2), hold on
        plot(mean(allstore(i).Pxx_i(B1)),allstore(i).mnflowI,'o')
        plot(mean(allstore(i).Pxx_i(B2)),allstore(i).mnflowI,'o')
        subplot(1,3,3), hold on
        plot(mean(allstore(i).Pxx_i(B2))-mean(allstore(i).Pxx_i(B1)),allstore(i).mnflowI,'o')
        
        mnflowI(i) = allstore(i).mnflowI;
        Pxxi(i,1) = mean(allstore(i).Pxx_i(B1));
        Pxxi(i,2) = mean(allstore(i).Pxx_i(B2));
        mxflowI(i) = min(allstore(i).flow);
    end
end
mxflowI(mxflowI > -1) = NaN;
ylabel('Flow Rate (L/s), Inhaled')
xlabel('PSD') 

lm_mn = fitlm(Pxxi(:,2)-Pxxi(:,1), mnflowI);
lm_mx = fitlm(Pxxi(:,2)-Pxxi(:,1), mxflowI);

plot(lm_mn)
plot(lm_mx)
legend off

figure(89), clf, hold on
for i = 1:length(allstore)
if ~isempty(allstore(i).SL_i)
    subplot(1,3,1:2), hold on
plot(mean(allstore(i).SL_i(B1)),allstore(i).mnflowI,'+')
plot(mean(allstore(i).SL_i(B2)),allstore(i).mnflowI,'+')

    subplot(1,3,3), hold on
  plot(mean(allstore(i).SL_i(B1))-mean(allstore(i).SL_i(B2)),allstore(i).mnflowI,'o')

end
end

figure(89), clf, hold on
plot(breath.cue(pon)/60,Pxxi(:,2)-Pxxi(:,1),'v')
xlabel('Time (min)'), ylabel('Diff PSD')
q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
for i = 1:length(q) % rest, prior to release
    plot(breath.cue(q(i))/60,mean(reststore(i).Pxxi(B2))-mean(reststore(i).Pxxi(B1)),'+')
    % plot(breath.cue(q(i))/60,mean(reststore(i).Pxxi(B2)),'+')
end

for i = 1:30 % free-swimming
    if ~isempty(surfstore(i).Pxxi)
        plot(breath.cue(q20(i))/60,mean(surfstore(i).Pxxi(B2))-mean(surfstore(i).Pxxi(B1)),'+')
    end
end

