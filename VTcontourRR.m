figure(4)

iRR = 60./diff(outCue); % not just free´swimming for resp rate

% WHAT ABOUT NANS? 

% add contours of minute ventilation
VTrange = 0:0.5:16;
% range of breaths/min
frange = 0:1:30;

VEcontour(:,1) = repmat(10,1,length(frange))./frange;
VEcontour(:,2) = repmat(30,1,length(frange))./frange; 
VEcontour(:,3) = repmat(50,1,length(frange))./frange; 
VEcontour(:,4) = repmat(70,1,length(frange))./frange;
VEcontour(:,5) = repmat(90,1,length(frange))./frange; 
VEcontour(:,6) = repmat(110,1,length(frange))./frange; 

if f == 10
    subplot(1,3,2), hold on 
plot(VEcontour,frange,'color',[0.75 0.75 0.75])
subplot(1,3,3), hold on 
plot(VEcontour,frange,'color',[0.75 0.75 0.75])
end 

outVTshort = outVT(2:end);
outQshort = outQuality(2:end);

subplot(1,3,2)
plot(outVTshort(outQshort == 0),iRR(outQshort == 0),'o','MarkerEdgeColor',[rand rand rand]) % and with different for rest vs swimming?
xlabel('Tidal Volume (L)')
ylabel('Frequency (breaths/min)')
xlim([min(VTrange) max(VTrange)])
ylim([0 16])

subplot(1,3,3)
plot(outVTshort(outQshort == 20),iRR(outQshort == 20),'ko','MarkerFaceColor',[rand rand rand]) % and with different for rest vs swimming?
xlabel('Tidal Volume (L)')
ylabel('Frequency (breaths/min)')
xlim([min(VTrange) max(VTrange)])
ylim([0 16])

if f == 16
print([cd '\AnalysisFigures\VT-contour-all'],'-dpng')
end

return 
figure(8), hold on, 
VE = outVT(2:end).*iRR;
plot(outVT(2:end),VE,'o')

% figure
% plot3(outCue/60,outVT(2:end),iRR,'o-')

