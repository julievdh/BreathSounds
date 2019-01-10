% Look at spectral level content of syringe calibrations to see effect of
% flow rate

AlignData_SyringeCal
%% 
CH = 2; 
for i = 1:5
[SL_o(:,i),f] = speclev(sigstore(f).o{CH,i},2048,afs);
[SL_i(:,i),f] = speclev(sigstore(f).i{CH,i},2048,afs);
end
%% 
figure(4), clf
ax1 = subplot(2,4,1:2); 
plot(f,SL_o)
xlabel('Frequency (Hz)'), ylabel('SL'), title('Simulated exhales')
xlim([0 24000])

% find SL in lowest frequency band and second frequency band
%mean(SL(1:17,:))
%mean(SL(18:33,:))
ax2 = subplot(243); hold on
for i = 1:5
plot([1800 3800],[mean(SL_o(1:17,i)) mean(SL_o(18:33,i))],'o-')
end
xlabel('Mean SL in Freq band')
ax2.YLim = ax1.YLim; box on; ax2.XLim = [1500 4100];

ax3 = subplot(2,4,5:6); hold on
plot(f,SL_i)
xlabel('Frequency (Hz)'), ylabel('SL')
title('Simulated inhales')
ax3.XLim = ax1.XLim; ax3.YLim = ax1.YLim; box on

ax4 = subplot(247); hold on
for i = 1:5
plot([1800 3800],[mean(SL_i(1:17,i)) mean(SL_i(18:33,i))],'o-')
end
xlabel('Mean SL in Freq band')
ax4.YLim = ax1.YLim; box on; ax4.XLim = [1500 4100];

%% plot difference between two bands versus max flow
subplot(244), hold on
relSL_o = mean(SL_o(1:17,:))./mean(SL_o(18:33,:));
for i = 1:5
    plot(relSL_o(i),abs(minflow{1}(i)),'o')
end
ylabel('Max Flow Rate (L/s)'), box on

subplot(248), hold on
relSL_i = mean(SL_i(1:17,:))./mean(SL_i(18:33,:));
for i = 1:5
    plot(relSL_i(i),mxflow{1}(i),'o')
end
ylabel('Max Flow Rate (L/s)')
xlabel('SL Band Ratio'), box on

cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
print('SyringeCal-SL-tt152z-10cm-pon.png','-dpng')


%% %% spectrogram all breaths 
figure(4), clf
f = 1; 
for k = 1:length(sigstore_o)        
        subplot(6,5,k), hold on; 
        bspectrogram(sigstore_o{CH,k},afs,tags(f).sout(k,:)); 
end
%% 
figure(5), clf
for k = 1:length(sigstore_o)        
        subplot(6,5,k), hold on
        [SL_o(:,k),f] = speclev(sigstore_o{CH,k},2048,afs);
        plot(SL_o(:,k),f)
        axis([-150 -60 0 5E3])
        lth = 2000; hth = 4000; 
        SLhigh(k) = mean(SL_o(f>lth & f <hth,k)); 
        SLlow(k) = mean(SL_o(f<lth,k));  
        plot([SLhigh(k) SLlow(k)],[hth lth],'o-')
end

%% for inhales
%% spectrogram all breaths 
figure(6), clf
f = 1; 
for k = 1:length(sigstore_i)        
        subplot(6,5,k), hold on; 
        bspectrogram(sigstore_i{CH,k},afs,tags(f).sin(k,:)); 
end
%% 
figure(7), clf
for k = 1:length(sigstore_i)        
        subplot(6,5,k), hold on
        [SL_i(:,k),f] = speclev(sigstore_i{CH,k},2048,afs);
        plot(SL_i(:,k),f)
        axis([-150 -60 0 5E3])
        lth = 2000; hth = 4000; 
        SLhigh(k) = mean(SL_i(f>lth & f <hth,k)); 
        SLlow(k) = mean(SL_i(f<lth,k));  
        plot([SLhigh(k) SLlow(k)],[hth lth],'o-')
end

