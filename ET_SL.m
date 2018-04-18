% Look at spectral level content of an exercise trial to see effect of
% flow rate or volume 

waterfallBreathET % file 16 
%% 
% sigstore contains all of the breaths when pneum is on
% is sorted for order though, by tidal volume. 
CH = 2; 
for i = 1:length(sigstore) 
if isempty(sigstore{CH,i}) == 0
    L = length(sigstore{CH,i})/2;
    [SL(:,i),f] = speclev(sigstore{CH,i}(L-5000:L+5000),2048,afs); % SL in the middle of the signal
end
end

figure(4), clf
ax1 = subplot(1,4,1:2); 
plot(f,SL)
xlabel('Frequency (Hz)'), ylabel('SL')
xlim([0 24000])

% find SL in lowest frequency band and second frequency band
%mean(SL(1:17,:))
%mean(SL(18:33,:))
ax2 = subplot(143); hold on
for i = 1:length(sigstore)
plot([1800 3800],[mean(SL(f<2000,i)) mean(SL(f>3000 & f <4000,i))],'o-')
end
xlabel('Mean SL in Freq band')
ax2.YLim = ax1.YLim; box on; ax2.XLim = [1500 4100];

%% plot difference between two bands versus max flow
subplot(144), hold on
relSL = mean(SL(f>3000 & f <4000,:))./mean(SL(f<2000,:));

mxflow = abs(all_SUMMARYDATA(I,4)); % because is sorted 
mnflow = abs(all_SUMMARYDATA(I,5)./RESPTIMING(I,6)); 

for i = 1:length(sigstore)
    plot(relSL(i),mxflow(i),'o')
    plot(relSL(i),mnflow(i),'.')
end
ylabel('Max Flow Rate (L/s)'), box on


%cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
%print('SyringeCal-SL-tt152z-10cm-pon.png','-dpng')

%% spectrogram all breaths 
figure(4), clf
for k = 1:length(sigstore)
        subplot(10,ceil(size(sigstore,2)/10),k), hold on, title(all_SUMMARYDATA(I(k),5)/RESPTIMING(I(k),6)); 
        if isnan(CUE_R(I(k))) == 0 
        bspectrogram(sigstore{CH,k},afs,breath.cue(CUE_R(I(k)),:)); 
        end
end
%% 
figure(5), clf
for k = 1:length(sigstore)        
        subplot(10,ceil(size(sigstore,2)/10),k), hold on
        plot(SL(:,k),f)
        axis([-150 -90 0 5E3])
        lth = 2000; hth = 4000; 
        SLhigh(k) = mean(SL(f>lth & f <hth,k)); 
        SLlow(k) = mean(SL(f<lth,k));  
        plot([SLhigh(k) SLlow(k)],[hth lth],'o-')
end

% linear model
lm = fitlm([SLhigh' SLhigh'-SLlow'],mxflow), plotSlice(lm)
        