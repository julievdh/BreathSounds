% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% Created: 13 Aug 2014 % Updated: Jan 2018

close all; clear; clc

% Load tags
tags(1).name = 'tt17_152b';
tags(2).name = 'tt17_152z';

% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
for f = 1:length(tags)
    tags(f).recdir = d3makefname(tags(f).name,'RECDIR');
    
    % load calibration and deployment info, tag audit
    tags(f).R = loadaudit(tags(f).name);
    [tags(f).CAL,tags(f).DEPLOY] = d3loadcal(tags(f).name);
end
tags(1).col = [0 0 1]; tags(2).col = [1 0 0]; % prescribe color for ease

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
load('Trial72_June01-Sound-Calibration')

parseLabChart
for bl = 1:nblock
    if bl > 1
        T{1,bl} = etime(datevec(blocktimes(bl)),datevec(blocktimes(bl-1))) + (datastart(ch,bl):dataend(ch,bl))/tickrate(bl); % time in seconds for flow
    else
        T{1,bl} = (datastart(ch,bl):dataend(ch,bl))/tickrate(bl); % time in seconds for flow
    end
end
clear data dataend datastart firstsampleoffset rangemax rangemin unittext unittextmap

% return to other directory
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\

%%

% plot all together
% figure(1); clf, hold on
% for bl = 1:5
%     plot(T{bl},FilteredFlow{bl})
% end
for f = 1:length(tags)
    % find time in tag record when trial starts
    tags(f).tcue = etime(datevec(addtodate(blocktimes(1),10,'h')), tags(f).DEPLOY.TAGON.TIME)-50;

    % find sound calibration times 
    [tags(f).scal,~] = findaudit(tags(f).R,'scal');
%     for n = 1:length(tags(f).scal)
%         line([tags(f).scal(n,1)-tags(f).tcue tags(f).scal(n,1)-tags(f).tcue],[0 50],'color',tags(f).col)
%     end
%     xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
end

%% IMPORT SOUNDS AND CALCULATE SOUND INTEGRAL
% have gone through and set *inhales 1-5 and *exhales 1-5 from syringe

for f = 1:2
[tags(f).sin,~] = findaudit(tags(f).R,'sin'); % syringe in = inhale equivalent
[tags(f).sout,~] = findaudit(tags(f).R,'sout'); % syringe out = exhale equivalent

% for syringe in
figure(6), subplot(121), hold on
for i = 1:length(tags(f).sin)
    [s,afs] = d3wavread([tags(f).sin(i,1) tags(f).sin(i,1)+tags(f).sin(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
    s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
    sigstore(f).i{1,i} = s1; % store
    s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
    sigstore(f).i{2,i} = s2; % store
    
    [~,~,E2_s_1,~] = envfilt(sigstore(f).i{1,i},afs); % channel 1
    [~,~,E2_s_2,newfs] = envfilt(sigstore(f).i{2,i},afs); % channel 1
    figure(6),
    plot((1:length(E2_s_1))/newfs,E2_s_2+i/1000) 
    plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000) 
    Sint1(f).in(i) = trapz(E2_s_1); % integral of filtered sound
    Sint2(f).in(i) = trapz(E2_s_2); 
end

% syringe out
figure(6), subplot(122), hold on
for i = 1:length(tags(f).sout)
    [s,afs] = d3wavread([tags(f).sout(i,1) tags(f).sout(i,1)+tags(f).sout(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
    s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
    sigstore(f).o{1,i} = s1; % store
    s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
    sigstore(f).o{2,i} = s2; % store
    
    [~,~,E2_s_1,~] = envfilt(sigstore(f).o{1,i},afs); % channel 1
    [~,~,E2_s_2,newfs] = envfilt(sigstore(f).o{2,i},afs); % channel 2
    figure(6),
    plot((1:length(E2_s_1))/newfs,E2_s_2+i/1000) 
    plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000) 
    Sint1(f).out(i) = trapz(E2_s_1); % integral of filtered sound
    Sint2(f).out(i) = trapz(E2_s_2); 
end

figure(199), clf, hold on
pon = [1:5 11:15 21:25];
poff = [6:10 16:20 26:30]; 
dist = [repmat(10,1,5) repmat(15,1,5) repmat(20,1,10) repmat(10,1,10)];  


plot(Sint1(f).out(pon),dist(pon),'b^','markerfacecolor','b')
plot(Sint1(f).out(poff),dist(poff),'b^')

plot(Sint1(f).in(pon),dist(pon),'rv','markerfacecolor','r')
plot(Sint1(f).in(poff),dist(poff),'rv')

end

%% plot four spectrograms of one sound calibration 
% figure(4)
% f = 1; i = 1; % first tag, first scal
% [s,afs] = d3wavread([tags(f).scal(i,1) tags(f).scal(i,1)+tags(f).scal(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
% subplot(411), bspectrogram(s(:,1),afs,tags(f).scal(1,:)); % channel 1
% subplot(412), bspectrogram(s(:,2),afs,tags(f).scal(1,:)); % channel 2
% f = 2; i = 1; % second tag, first scal
% [s,afs] = d3wavread([tags(f).scal(i,1) tags(f).scal(i,1)+tags(f).scal(i,2)],tags(f).recdir, [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
% subplot(413), bspectrogram(s(:,1),afs,tags(f).scal(1,:)); % channel 1
% subplot(414), bspectrogram(s(:,2),afs,tags(f).scal(1,:)); % channel 2

%% Always 7L Volume

figure(2); clf
ct = 0; % set a counter
for bl = [1 2 5]
for i = 1:length(st(:,bl))
    ct = ct+1; 
    % calculate volume 
    vol = cumsum(FilteredFlow{bl}(st(i,bl):ed(i,bl)))./samplerate(1);
    % find max flow rate during that time
    mxflow{bl}(i) = max(FilteredFlow{bl}(st(i,bl):ed(i,bl))); 
    minflow{bl}(i) = min(FilteredFlow{bl}(st(i,bl):ed(i,bl))); 
    subplot(121), hold on
    % save cuts
       cuts(pon(ct)).flow = FilteredFlow{bl}(st(i,bl):ed(i,bl));
        cuts(pon(ct)).vol = vol; 
    
    % plot flow-volume loop
    plot(vol,FilteredFlow{bl}(st(i,bl):ed(i,bl)))
    xlabel('Volume (L)'), ylabel('Flow (L/s)')
    subplot(122), hold on
    % plot volume of syringe
    plot(vol)
    xlabel('Time'), ylabel('Volume (L)')
end
end


figure(3), clf, hold on
f = 1;
plot(Sint1(f).out(pon(1:5)),[minflow{1}],'^-','color','b')
plot(Sint1(f).out(pon(6:10)),[minflow{2}],'^-','color','c')
plot(Sint1(f).out(pon(11:15)),[minflow{5}],'^-','color','b')
plot(Sint2(f).out(pon(1:5)),[minflow{1}],'^-','color','r')
plot(Sint2(f).out(pon(6:10)),[minflow{2}],'^-','color','m')
plot(Sint2(f).out(pon(11:15)),[minflow{5}],'^-','color','r')


plot(Sint1(f).in(pon(1:5)),[mxflow{1}],'v-','color','b')
plot(Sint1(f).in(pon(6:10)),[mxflow{2}],'v-','color','c')
plot(Sint1(f).in(pon(11:15)),[mxflow{5}],'v-','color','b')
plot(Sint2(f).in(pon(1:5)),[mxflow{1}],'v-','color','r')
plot(Sint2(f).in(pon(6:10)),[mxflow{2}],'v-','color','m')
plot(Sint2(f).in(pon(11:15)),[mxflow{5}],'v-','color','r')

f = 2; % second tag
plot(Sint1(f).out(pon(1:5)),[minflow{1}],'^-','color','b')
plot(Sint1(f).out(pon(6:10)),[minflow{2}],'^-','color','c')
plot(Sint1(f).out(pon(11:15)),[minflow{5}],'^-','color','b')
plot(Sint2(f).out(pon(1:5)),[minflow{1}],'^-','color','r')
plot(Sint2(f).out(pon(6:10)),[minflow{2}],'^-','color','m')
plot(Sint2(f).out(pon(11:15)),[minflow{5}],'^-','color','r')

plot(Sint1(f).in(pon(1:5)),[mxflow{1}],'v-','color','b')
plot(Sint1(f).in(pon(6:10)),[mxflow{2}],'v-','color','c')
plot(Sint1(f).in(pon(11:15)),[mxflow{5}],'v-','color','b')
plot(Sint2(f).in(pon(1:5)),[mxflow{1}],'v-','color','r')
plot(Sint2(f).in(pon(6:10)),[mxflow{2}],'v-','color','m')
plot(Sint2(f).in(pon(11:15)),[mxflow{5}],'v-','color','r')

xlabel('Integral of Filtered Sound'), ylabel('Max Flow Rate (L/s)')

%% plot hydrophones and tags against each other
figure(2), clf
set(gcf,'position',1000*[2.0637    0.0990    1.1680    0.4280])
subplot(121), hold on %% note hydrophones are 'numbered' arbitrarily and this way plots look better with inset
title('Within Tags')
plot([Sint2(1).in],[Sint1(1).in],'v') % inhale T1
plot([Sint2(2).in],[Sint1(2).in],'v') % inhale T2
plot([Sint2(1).out],[Sint1(1).out],'^') % exhale T1
plot([Sint2(2).out],[Sint1(2).out],'^') % exhale T2
legend('Inhale T1','Inhale T2','Exhale T1', 'Exhale T2','Location','NW')

xlabel('Integrated Sound - Hydrophone 1'), ylabel('Integrated Sound - Hydrophone 2')
xlim([0 3]), ylim([0 3])

axes('Position',[.35 .2 .1 .3])
box on, hold on 
plot([Sint2(1).in],[Sint1(1).in],'v')
plot([Sint2(1).in],[Sint2(1).in],'v')
xlim([0 0.35]), ylim([0 0.35])
axis square, set(gca,'xtick',0:0.1:0.3)

subplot(122), hold on 
title('Between Tags')
plot([Sint1(1).in],[Sint1(2).in],'v') % inhale hydrophone 1 
plot([Sint2(1).in],[Sint2(2).in],'v') % inhale hydrophone 2
plot([Sint1(1).out],[Sint1(2).out],'^') % exhale hydrophone 1
plot([Sint2(1).out],[Sint2(2).out],'^') % exhale hydrophone 2 
legend('Inhale H1','Inhale H2','Exhale H1', 'Exhale H2')
xlabel('Integrated Sound - Tag 1'), ylabel('Integrated Sound - Tag 2')
xlim([0 3]), ylim([0 3])

axes('Position',[.75 .2 .15 .4])
box on, hold on 
plot([Sint1(1).in],[Sint1(2).in],'v')
plot([Sint2(1).in],[Sint2(2).in],'v')
xlim([0 0.35]), ylim([0 0.35])

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures'
print('dualsyringecal_withinbetween', '-dpng', '-r300')

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
save('SyringeCalData','pon','poff','tags','Sint1','Sint2','minflow','mxflow','dist')

return 

PlotSyringeCompare % comparison of FlowSound method
