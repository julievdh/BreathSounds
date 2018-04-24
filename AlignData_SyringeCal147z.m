% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% Created: 13 Aug 2014 % Updated: Jan 2018

close all; clear; clc; warning off

% load saved Syringe data from other file
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load('SyringeCalData')

% Load tags
f = 3; 
tags(f).name = 'tt17_147z';

% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
for f = 1:length(tags)
    tags(f).recdir = d3makefname(tags(f).name,'RECDIR');
    
    % load calibration and deployment info, tag audit
    tags(f).R = loadaudit(tags(f).name);
    [tags(f).CAL,tags(f).DEPLOY] = d3loadcal(tags(f).name);
end
tags(f).col = [0 0 1];

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
load('Trial55_May27-ECG-tag-sound-cal')

parseLabChart
for bl = 1:nblock
    if bl > 1
        T{1,bl} = etime(datevec(blocktimes(bl)),datevec(blocktimes(bl-1))) + (datastart(ch,bl):dataend(ch,bl))/tickrate(bl); % time in seconds for flow
    else
        T{1,bl} = (datastart(ch,bl):dataend(ch,bl))/tickrate(bl); % time in seconds for flow
    end
end
clear data dataend datastart firstsampleoffset rangemax rangemin unittext unittextmap ch
clear CO20Base CO2Cumul CO2Flow0x2A0Base ChestBand Blank O2 O20Base O2Cumul O2Flow0x2A0Base CO2
clear SumFlow FlowRaw InspFlow InspVolume TidalVolume0x2DNoReset TidalVolume0x2DReset ExpFlow ExpVolume

% return to other directory
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\

%% IMPORT SOUNDS AND CALCULATE SOUND INTEGRAL
% have gone through and set *inhales 1-5 and *exhales 1-5 from syringe

for f = 3
    [tags(f).sin,~] = findaudit(tags(f).R,'sin'); % syringe in = inhale equivalent
    [tags(f).sout,~] = findaudit(tags(f).R,'sout'); % syringe out = exhale equivalent
    
    % for syringe in
    %    figure(16), subplot(121), % hold on
    for i = 1:length(tags(f).sin)
        [s,afs] = d3wavread([tags(f).sin(i,1) tags(f).sin(i,1)+tags(f).sin(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        ns = fftsyringe(s1,afs);
        [~,~,bwi(i),s1] = CleanSpectra_fun(ns,afs,tags(f).sin(i,:)); % clean spectra
        sigstore(f).i{1,i} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        ns = fftsyringe(s2,afs);
        [~,~,~,s2] = CleanSpectra_fun(ns,afs,tags(f).sin(i,:));
        sigstore(f).i{2,i} = s2; % store
        
        [~,~,E2_s_1,~] = envfilt(sigstore(f).i{1,i},afs); % channel 1
        [~,~,E2_s_2,newfs] = envfilt(sigstore(f).i{2,i},afs); % channel 2
        %         figure(16),
        %         plot((1:length(E2_s_1))/newfs,E2_s_2+i/1000)
        %         plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000)
        Sint1(f).in(i) = trapz(E2_s_1); % integral of filtered sound
        Sint2(f).in(i) = trapz(E2_s_2);
        envstore(f).in{i} = E2_s_1; % store
    end
    
    % syringe out
    %   figure(16), subplot(122), % hold on
    for i = 1:length(tags(f).sout)
        [s,afs] = d3wavread([tags(f).sout(i,1) tags(f).sout(i,1)+tags(f).sout(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        ns = fftsyringe(s1,afs);
        [~,~,bwo(i),s1] = CleanSpectra_fun(ns,afs,tags(f).sout(i,:));
        sigstore(f).o{1,i} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        ns = fftsyringe(s2,afs);
        [~,~,~,s2] = CleanSpectra_fun(ns,afs,tags(f).sout(i,:));
        sigstore(f).o{2,i} = s2; % store
        
        BL = 2048;
        [Pxx(:,i),Freq] = pwelch(s1,hamming(BL),floor(BL/1.3),BL,afs,'onesided');
        
        
        [~,~,E2_s_1,~] = envfilt(sigstore(f).o{1,i},afs); % channel 1
        [~,~,E2_s_2,newfs] = envfilt(sigstore(f).o{2,i},afs); % channel 2
        %         figure(16),
        %         plot((1:length(E2_s_1))/newfs,E2_s_2+i/1000)
        %         plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000)
        Sint1(f).out(i) = trapz(E2_s_1); % integral of filtered sound
        Sint2(f).out(i) = trapz(E2_s_2);
        envstore(f).out{i} = E2_s_1; % store envelope
    end
    
    %     figure(199), clf, hold on
    pon3 = [12:16 22:26 32:36 42:46 52:56 62:66 72:76] -1; % because removed first sin-sout to have even rows
    poff3 = [2:11 17:21 27:31 37:41 47:51 57:61 67:71] -1; % because removed first sin-sout
    dist3 = [repmat(10,1,15) repmat(12,1,10) repmat(14,1,10) repmat(16,1,10) ...
        repmat(18,1,10) repmat(20,1,10) repmat(22,1,10)];
    pneum = zeros(length(dist3),1);
    pneum(pon3) = 1; % pneumotach status
    
    %
    %     plot(Sint1_out(pon),dist(pon),'b^','markerfacecolor','b')
    %     plot(Sint1_out(poff),dist(poff),'b^')
    %
    %     plot(Sint1_in(pon),dist(pon),'rv','markerfacecolor','r')
    %     plot(Sint1_in(poff),dist(poff),'rv')
    
end

%% %% %% spectrogram all breaths
figure(4), clf
set(gcf,'position',1000*[2.9783   -0.3117    0.5607    0.9520],...
    'paperpositionmode','auto')
ha = tight_subplot(15,5,[.03 .03],[.08 .01],[.1 .01]);

for k = 1:length(sigstore(f).o)
    axes(ha(k)); hold on;
    bspectrogram(sigstore(f).o{1,k},afs,[0 length(sigstore(f).o{1,k})/afs]); % tags(f).sout(k,:));
    [SL_o(:,k),F] = speclev(sigstore(f).o{1,k},2048,afs);
end
linkaxes
set(ha(end-4:end),'XTick',[0 0.4],'XTicklabels',[0 0.4])
set(ha(1:5:75),'Ytick',[0 20],'yticklabels',[0 20])

[ax2,h2]=suplabel('Frequency (kHz)','y');
set(h2,'position',[-0.02 0.5 0])
[ax1,h1]=suplabel('Time (sec)','x');
set(h1,'position',[0.5 0 0])
adjustfigurefont

print([cd '\AnalysisFigures\Syringe_147z_assay_out'],'-dpng','-r300')

%%
figure(5), clf
for k = 1:length(sigstore(f).o)
    subplot(15,5,k), hold on
    [SL_o(:,k),F] = speclev(sigstore(f).o{1,k},2048,afs);
    plot(SL_o(:,k),F)
    axis([-150 -60 0 5E3])
%     lth = 2000; hth = 4000;
%     SLhigh_o(k) = mean(SL_o(f>lth & f <hth,k));
%     SLlow_o(k) = mean(SL_o(f<lth,k));
%     plot([SLhigh_o(k) SLlow_o(k)],[hth lth],'o-')
end

%% for inhales
%% spectrogram all breaths
figure(6), clf
set(gcf,'position',1000*[2.9783   -0.3117    0.5607    0.9520],...
    'paperpositionmode','auto')
ha = tight_subplot(15,5,[.03 .03],[.08 .01],[.1 .01]);

for k = 1:length(sigstore(f).i)
    axes(ha(k)); hold on;
    bspectrogram(sigstore(f).i{1,k},afs,[0 length(sigstore(f).i{1,k})/afs]); % tags(f).sout(k,:));
    [SL_i(:,k),F] = speclev(sigstore(f).i{1,k},2048,afs);
end
linkaxes
set(ha(end-4:end),'XTick',[0 0.4],'XTicklabels',[0 0.4])
set(ha(1:5:75),'Ytick',[0 20],'yticklabels',[0 20])

[ax2,h2]=suplabel('Frequency (kHz)','y');
set(h2,'position',[-0.02 0.5 0])
[ax1,h1]=suplabel('Time (sec)','x');
set(h1,'position',[0.5 0 0])
adjustfigurefont

print([cd '\AnalysisFigures\Syringe_147z_assay_in'],'-dpng','-r300')

%%
figure(7), clf
for k = 1:length(sigstore(f).i)
    subplot(15,5,k), hold on
    [SL_i(:,k),F] = speclev(sigstore(f).i{1,k},2048,afs);
    plot(SL_i(:,k),F)
    axis([-150 -60 0 5E3])
    %lth = 2000; hth = 4000;
    %SLhigh_i(k) = mean(SL_i(F>lth & F <hth,k));
    %SLlow_i(k) = mean(SL_i(F<lth,k));
    %plot([SLhigh_i(k) SLlow_i(k)],[hth lth],'o-')
end

%% Always 7L Volume

% figure(2); clf
ct = 0;
for bl = 1:nblock
    for i = 1:length(st{bl})
        % calculate volume
        ct = ct+1;
        vol = cumsum(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)))./samplerate(1);
        exvol{bl}(i) = max(vol);
        % find max flow rate during that time
        mxflow{bl}(i) = max(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)));
        minflow{bl}(i) = min(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)));
        
        
        cuts(pon3(ct)).flow = FilteredFlow{bl}(st{bl}(i):ed{bl}(i));
        cuts(pon3(ct)).vol = vol; 
        
        %subplot(121), hold on
        %plot flow-volume loop
        %         plot(vol,FilteredFlow{bl}(st{bl}(i):ed{bl}(i)))
        %        xlabel('Volume (L)'), ylabel('Flow (L/s)')
        %         subplot(122), hold on
        % plot volume of syringe
        %plot(vol)
        %xlabel('Time'), ylabel('Volume (L)')
    end
end
save([cd '\ChestBand\Trial55_May27-ECG-tag-sound-cal'],'cuts','-append')

%% find optimal bands for comparison
optimalBands;

figure(3), clf, hold on
gscatter(Sint1(f).out(pon3),[minflow{:}],dist3(pon3))
gscatter(Sint1(f).in(pon3),[mxflow{:}],dist3(pon3))
xlabel('Integral of Filtered Sound'), ylabel('Max Flow Rate (L/s)')

figure(31), clf, hold on 
plot(Sint1(f).out(pon3(1:5)),[minflow{1}],'^-','color','k')
plot(Sint1(f).out(pon3(6:10)),[minflow{2}],'^-','color','k')
plot(Sint1(f).out(pon3(11:15)),[minflow{3}],'^-','color','k')
plot(Sint1(f).out(pon3(16:20)),[minflow{4}],'^-','color','k')
plot(Sint1(f).out(pon3(21:25)),[minflow{5}],'^-','color','k')
plot(Sint1(f).out(pon3(26:30)),[minflow{6}],'^-','color','k')
plot(Sint1(f).out(pon3(31:35)),[minflow{7}],'^-','color','k')

plot(Sint2(f).out(pon3(1:5)),[minflow{1}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(6:10)),[minflow{2}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(11:15)),[minflow{3}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(16:20)),[minflow{4}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(21:25)),[minflow{5}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(26:30)),[minflow{6}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).out(pon3(31:35)),[minflow{7}],'^-','color',[0.5 0.5 0.5])

plot(Sint2(f).in(pon3(1:5)),[mxflow{1}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(6:10)),[mxflow{2}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(11:15)),[mxflow{3}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(16:20)),[mxflow{4}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(21:25)),[mxflow{5}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(26:30)),[mxflow{6}],'^-','color',[0.5 0.5 0.5])
plot(Sint2(f).in(pon3(31:35)),[mxflow{7}],'^-','color',[0.5 0.5 0.5])

plot(Sint1(f).in(pon3(1:5)),[mxflow{1}],'^-','color','k')
plot(Sint1(f).in(pon3(6:10)),[mxflow{2}],'^-','color','k')
plot(Sint1(f).in(pon3(11:15)),[mxflow{3}],'^-','color','k')
plot(Sint1(f).in(pon3(16:20)),[mxflow{4}],'^-','color','k')
plot(Sint1(f).in(pon3(21:25)),[mxflow{5}],'^-','color','k')
plot(Sint1(f).in(pon3(26:30)),[mxflow{6}],'^-','color','k')
plot(Sint1(f).in(pon3(31:35)),[mxflow{7}],'^-','color','k')


SLdiff_o = SLlow_o - SLhigh_o;
SLdiff_i = SLlow_i - SLhigh_i;

flow = repmat(1:5,1,15);

figure(13); clf, hold on
%gscatter(bwo,flow,pneum,'bg')
%gscatter(bwi,flow,pneum)
subplot(121), hold on
plot(SLlow_o(pon3),[minflow{:}],'o')
plot(SLhigh_o(pon3),[minflow{:}],'o')
xlabel('SL'), ylabel('Max Syringe Out Flow (L/s)')
legend('0-1000 Hz','2500-3500 Hz','location','southwest')
subplot(122)
plot(SLdiff_o(pon3),[minflow{:}],'o')
xlabel('SLlow-SLhigh')

% plot sound integral and envelopes and correlation
allminflow = [minflow{:}];
allmxflow = [mxflow{:}];
figure(14), clf,
subplot(121),hold on
plot3(Sint1(f).out(pon3),repmat(7,size(pon3),1),allminflow,'o')
xlabel('Integral of Filtered Sound'), ylabel('Measured VT (L)'), zlabel('Max Flow Rate (L/s)')
% can we plot envelope next to the values?
for i = 1:length(pon3)
    plot3(Sint1(f).out(pon3(i))+(1:length(envstore(f).out{pon3(i)}))/(afs/4),(1:length(envstore(f).out{pon3(i)}))/(afs/4)+7,allminflow(i)+1000*envstore(f).out{pon3(i)})
end
set(gca,'view',[-12.2667   -1.2000])
subplot(122), hold on
plot3(Sint1(f).in(pon3),repmat(7,size(pon3),1),allmxflow,'o')
xlabel('Integral of Filtered Sound'), ylabel('Measured VT (L)'), zlabel('Max Flow Rate (L/s)')
% can we plot envelope next to the values?
for i = 1:length(pon3)
    plot3(Sint1(f).in(pon3(i))+(1:length(envstore(f).in{pon3(i)}))/(afs/4),(1:length(envstore(f).in{pon3(i)}))/(afs/4)+7,allmxflow(i)+1000*envstore(f).in{pon3(i)})
end
set(gca,'view',[-12.2667   -1.2000])
%% 3d plot ranked spectra
figure(90), clf, hold on
strt=find(F > 200,1,'first');
L = find(F < 0.5E4,1,'last'); % zoom in on the first half of F range
allminflow = [minflow{:}];
[cvec,c_all] = getcmap(dist3); % colormap by distance
for i = 1:length(pon3)
    plot3(F(1:L),zeros(L,1)+abs(allminflow(i)),Pxx(1:L,pon3(i))/sum(Pxx(1:L,pon3(i))),'color',c_all(pon3(i),:))
end
xlabel('Frequency'), ylabel('Max Exhaled Flow Rate (L/s)'), zlabel('norm PSD')


cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures'
set(gca,'view',[13.8667   57.4667])
print('Syringe-147z-pneumon-PSD.png','-dpng')

% get average flow rates for each *flow level*
for i = 1:5 
flows(i,:) = [mean(allminflow(i:5:end)) std(allminflow(i:5:end)) mean(allmxflow(i:5:end)) std(allmxflow(i:5:end))];
end

%% do linear model
% some variables in table
tbl = table(Sint1(f).out', SLlow_o',SLhigh_o',SLdiff_o',dist3',flow',pneum,...
    'VariableNames',{'Sint','SLlow','SLhigh','SLdiff','Distance','Flow','Pneumo'});
% fit a linear model: is the source level affected by distance or
% pneumotach?
lmLF = fitlm(tbl,'SLlow~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)
figure(32), clf
co = [0 93 154]/255;
SyringeSpecLMfig(lmLF,co)
lmHF = fitlm(tbl,'SLhigh~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)
co = [25 164 255]/255;
SyringeSpecLMfig(lmHF,co)
print([cd '\AnalysisFigures\Syringe_147z_LMout'],'-dpng','-r300')
% lm = fitlm(tbl,'SLdiff~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'}); plotSlice(lm)

lm = fitlm(tbl,'Sint~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'}); plotSlice(lm)

tbl = table(Sint1(f).in', SLlow_i',SLhigh_i',SLdiff_i',dist3',flow',pneum,...
    'VariableNames',{'Sint','SLlow','SLhigh','SLdiff','Distance','Flow','Pneumo'});
% fit a linear model: is the source level affected by distance or
% pneumotach?
figure(33), clf, 
lmLF = fitlm(tbl,'SLlow~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)
co = [201 82 11]/255;
SyringeSpecLMfig(lmLF,co)
lmHF = fitlm(tbl,'SLhigh~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)
co = [255 129 54]/255;
SyringeSpecLMfig(lmHF,co) 

print([cd '\AnalysisFigures\Syringe_147z_LMin'],'-dpng','-r300')
    
%lm = fitlm(tbl,'SLdiff~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'}); plotSlice(lm)
% how is sound integral affected by pneumotach?
lm = fitlm(tbl,'Sint~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'}), plotSlice(lm)




return 

%% next: volume or flow relationship to SL or Sint
tbl_o = table([minflow{:}]',Sint1(f).out(pon3)',SLlow_o(pon3)',SLhigh_o(pon3)',SLdiff_o(pon3)',dist3(pon3)',...
    'VariableNames',{'MinFlow','Sint','SLlow','SLhigh','SLdiff','Distance'});
% fit a linear model: can SLlow-high-diff be used to indicate flow?
lm = fitlm(tbl_o,'MinFlow~SLhigh+SLdiff+Distance'), plotSlice(lm)

tbl_i = table([mxflow{:}]',Sint1(f).in(pon3)',SLlow_i(pon3)',SLhigh_i(pon3)',SLdiff_i(pon3)',dist3(pon3)',...
    'VariableNames',{'MinFlow','Sint','SLlow','SLhigh','SLdiff','Distance'});
% fit a linear model: can SLlow-high-diff be used to indicate flow?
lm = fitlm(tbl_i,'MinFlow~SLhigh+SLdiff+Distance'), plotSlice(lm)
