% compare syringe and dolphin
% load syringe data
load([cd '\ChestBand\' 'Trial55_May27-ECG-tag-sound-cal'])

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
for bl = 1:nblock
    for i = 1:length(st{bl})
        % calculate volume
        vol = cumsum(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)))./samplerate(1);
        % calculate volume
        [mx,ind] = max(vol);
        % find max-min in first half
        VTi{bl}(i) = mx-min(vol(1:ind));
        % find max-min in second half
        VTe{bl}(i) = mx-min(vol(ind:end));
        % find max flow rate during that time
        mxflow{bl}(i) = max(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)));
        minflow{bl}(i) = min(FilteredFlow{bl}(st{bl}(i):ed{bl}(i)));
    end
end


% load dolphin data
combineBreathData

%% histograms

figure(1), clf
set(gcf,'position',1000*[2.6377   -0.3117    1.0473    0.9520])
set(gcf,'paperpositionmode','auto')
subplot(221), hold on
edges = 0:1:30;
histogram(alleVT, edges)
histogram([VTe{:}],edges)
histogram(-alliVT,-flip(edges))
histogram(-[VTi{:}],-flip(edges))
plot([0 0],[0 150],'k:')
xlabel('Tidal Volume (L)')
text(2,140,'Exhalation','FontSize',14)
text(-16,140,'Inhalation','FontSize',14)
text(-28,140,'A','FontSize',20)
xlim([-30 30]), ylim([0 150])
adjustfigurefont

subplot(222), hold on
edges = 0:3:65;
histogram(-allEmaxflow,edges)
histogram(-[minflow{:}],edges)
histogram(-allImaxflow,-flip(edges))
histogram(-[mxflow{:}],-flip(edges))
plot([0 0],[0 150],'k:')
xlabel('Max Flow Rate (L/s)')
text(5,140,'Exhalation','FontSize',14)
text(-35,140,'Inhalation','FontSize',14)
text(-60,140,'B','FontSize',20)
ylim([0 150]), xlim([-65 65])
adjustfigurefont

%% for a breath that is ~7L inhale and exhale
f = 16;
% import the filteredflow for that file
filename = strcat(DQ2017{f,2},'_resp');
load([cd '\PneumoData\' filename])

% plot
subplot(223), hold on

% plot syringe --  note that the syringe goes inhale exhale and the animal
% goes exhale inhale
% so, swap order of syringe
for i = 1:5
    cuts(i).sflow = (FilteredFlow{bl}(st{bl}(i):ed{bl}(i))); % syringe flow
end
plot((357:357+(596-187))/tickrate(1),-cuts(1).sflow(187:596),'color',[0    0.4470    0.7410]) % syringe inhale 1
plot((357-(972-673):357)/tickrate(1),-cuts(1).sflow(673:972),'color',[0    0.4470    0.7410]) % syringe exhale 1

plot((357:357+(460-165))/tickrate(1),-cuts(2).sflow(165:460),'color',[    0.8500    0.3250    0.0980]) % syringe inhale 2
plot((357-(751-526):357)/tickrate(1),-cuts(2).sflow(526:751),'color',[    0.8500    0.3250    0.0980]) % syringe exhale 2

plot((357:357+(319-93))/tickrate(1),-cuts(3).sflow(93:319),'color',[    0.9290    0.6940    0.1250]) % syringe inhale 3
plot((357-(593-415):357)/tickrate(1),-cuts(3).sflow(415:593),'color',[    0.9290    0.6940    0.1250]) % syringe exhale 3

plot((357:357+(299-121))/tickrate(1),-cuts(4).sflow(121:299),'color',[   0.4940    0.1840    0.5560]) % syringe inhale 4
plot((357-(574-434):357)/tickrate(1),-cuts(4).sflow(434:574),'color',[   0.4940    0.1840    0.5560]) % syringe exhale 4

plot((357:357+(338-197))/tickrate(1),-cuts(5).sflow(197:338),'color',[    0.4660    0.6740    0.1880]) % syringe inhale 5
plot((357-(542-408):357)/tickrate(1),-cuts(5).sflow(408:542),'color',[    0.4660    0.6740    0.1880]) % syringe exhale 5

plot((1:length(cuts(42).flow))/tickrate(1),cuts(42).flow(:,2),'k','LineWidth',1.5) % dolphin breath 

% figure legend: measured airflow rates (L/s) for a dolphin breath (black)
% of approximately 7L (XL exhale, XL inhale) tidal volume, and a 7L
% calibration syringe pumped at different speeds 

xlabel('Time (s)'), ylabel('Flow Rate (L/s)')
xlim([0 2])
text(0.05, 50,'C','FontSize',20)
adjustfigurefont

print([cd '/AnalysisFigures/SyringeDolphinCompare.png'],'-dpng')

%% get some values 
[mean(allImaxflow) std(allImaxflow)]
[mean(allEmaxflow) std(allEmaxflow)]
