% 5' rest sound flow analysis for DQ animals
clear, close all, warning off

load('DQFiles2017')
f = 12; % 5' rests are files 12-15 
filename = strcat(DQ2017{f,2},'_resp');
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load(filename)

% load tag audit
tag = DQ2017{f,1}; R = loadaudit(tag); recdir = d3makefname(tag,'RECDIR');

% make exhales only?
[~,R] = findaudit(R,'exh');

% get cues
CUE_S = find(CUE); % cues in pneumotach summary file
CUE_R = CUE(find(CUE)); % cues in R audit structure

% check audited cue locations
figure(42), clf, hold on
plot(RAW_DATA(:,1),RAW_DATA(:,3)) 
plot(R.cue(:,1)-tcue,zeros(length(R.cue),1),'ro') % plot any audited cues
plot(R.cue(CUE_R,1)-tcue,zeros(length(CUE_R)),'ko') % plot those aligned with pneum
%% plot all envelopes in subplot
for i = 1:length(CUE_R)
    [b(i).clean(:,1),afs,b(i).raw(:,1)] = cleanbreath_fun(tag,R.cue(CUE_R(i),:),recdir,0,1); % channel 1
    [~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);
    
    [b(i).clean(:,2),afs,b(i).raw(:,2)] = cleanbreath_fun(tag,R.cue(CUE_R(i),:),recdir,0,2); % channel 2
    [~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);
    
    figure(21),
    subplot(ceil(length(CUE_R)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple

end

 
%% summary data
% what is mean/SD of measured VT, flow rates?
figure(3); clf, hold on
plot(R.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,3:6),'.','markersize',10)
errorbar(repmat(max(R.cue(CUE_R,1)-tcue)+100,1,4),mean(all_SUMMARYDATA(CUE_S,3:6)),std(all_SUMMARYDATA(CUE_S,3:6)),'ko','markerfacecolor','k')
legend('Max Insp Flow','Max Exp Flow','Tidal Volume E','Tidal Volume I','Location','WestOutside')
title(regexprep(tag,'_',' ')), xlabel('Time (s)')
adjustfigurefont

%% calculate 95% energy duration
figure(21), clf
for i = 1:length(CUE_R)
    [start1(i),stop1(i),time_window1(i)] = energy95(b(i).env(:,1),fs);
    [start2(i),stop2(i),time_window2(i)] = energy95(b(i).env(:,2),fs);
    
    %subplot(ceil(length(CUE_R)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
    figure(21), 
    subplot(121),hold on
    plot((1:length(b(i).env))/fs,b(i).env(:,1)+i/1000,'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2)+i/1000,'color',[123/255 50/255 148/255]) % light purple
    plot(start1(i):(1/fs):stop1(i),b(i).env(start1(i)*fs:round(stop1(i)*fs),1)+i/1000,'k')
    plot(start2(i):(1/fs):stop2(i),b(i).env(start2(i)*fs:round(stop2(i)*fs),2)+i/1000,'k')
   
    % calculate the max of the cleaned envelope 
    [mx1(i),ind1(i)] = max(b(i).env(start1(i)*fs:round(stop1(i)*fs),1)); plot(ind1(i)/fs + start1(i),mx1(i)+i/1000,'*')
    [mx2(i),ind2(i)] = max(b(i).env(start2(i)*fs:round(stop2(i)*fs),2)); plot(ind2(i)/fs + start2(i),mx2(i)+i/1000,'*')
    
    % calculate integral of 95% energy of envelope
    intE1(i) = trapz(b(i).env(start1(i)*fs:round(stop1(i)*fs),1));
    intE2(i) = trapz(b(i).env(start1(i)*fs:round(stop1(i)*fs),2));

    % calculate integral of all signal - envelope 
    intEall(i,1) = trapz(b(i).env(:,1));
    intEall(i,2) = trapz(b(i).env(:,2));
    
    % calculate integral of all signal - cleaned 
    intEallC(i,1) = trapz(abs(b(i).clean(:,1)));
    intEallC(i,2) = trapz(abs(b(i).clean(:,2)));
    
    % calculate integral of all signal - raw 
    intEallR(i,1) = trapz(abs(b(i).raw(:,1)));
    intEallR(i,2) = trapz(abs(b(i).raw(:,2)));
    
   
text(0.6,(i/1000)+0.00015,num2str(intEall(i,2))) % envelope only
text(0.6,(i/1000)-0.00015,num2str(intEall(i,1)))

text(-0.3,i/1000,num2str(abs(all_SUMMARYDATA(CUE_S(i),5))))
xlim([-0.4 0.8]), ylim([0 (length(CUE_R)+1)/1000])

subplot(122), hold on % plot full signals
plot((1:length(b(i).clean))/afs,abs(b(i).clean(:,2))+i/1000,'color',[123/255 50/255 148/255]) % light purple
plot((1:length(b(i).clean))/afs,abs(b(i).clean(:,1))+i/1000,'color',[194/255 165/255 207/255]) % dark purple
text(-0.3,i/1000,num2str(abs(all_SUMMARYDATA(CUE_S(i),5)))) % exhaled VT measured 

text(0.8,(i/1000)+0.00015,num2str(intEallC(i,2))) % full signal
text(0.8,(i/1000)-0.00015,num2str(intEallC(i,1)))
text(0.6,(i/1000),num2str(CUE_R(i)))


end
xlim([-0.4 0.8]), ylim([0 (length(CUE_R)+1)/1000])
%% do detected max's align? indicator of performance
mxtime1 = start1+ind1/fs;
mxtime2 = start2+ind2/fs;
align = abs(mxtime1 - mxtime2) < 0.04; 

%% add sound to flow plot
figure(42)
for i = 1:length(CUE_R)
plot(R.cue(CUE_R(i),1)-tcue-0.25+(1:length(b(i).clean))/afs,abs(b(i).clean(:,2))*1E4,'color',[123/255 50/255 148/255]) % light purple
end
 
%% correlate
figure(5), clf,
subplot(221), hold on
plot(mx1,all_SUMMARYDATA(CUE_S,4),'o','color',[194/255 165/255 207/255])
plot(mx2,all_SUMMARYDATA(CUE_S,4),'o','color',[123/255 50/255 148/255])
plot(mx1(align),all_SUMMARYDATA(CUE_S(align),4),'.','color',[194/255 165/255 207/255])
[coeffs,rsq,RMSE] = evalcorr(mx1(align),all_SUMMARYDATA(CUE_S(align),4)',1,[0.75 0.75 0.75]);
text(0.25E-3,-17,num2str([rsq; RMSE]))
plot(mx2(align),all_SUMMARYDATA(CUE_S(align),4),'.','color',[123/255 50/255 148/255])
[coeffs,rsq,RMSE] = evalcorr(mx2(align),all_SUMMARYDATA(CUE_S(align),4)',1);
text(1.0E-3,-17,num2str([rsq; RMSE]))
ylabel('Max Exp Flow (L/s)'), xlabel('Max Pressure Envelope (Pa)')

subplot(222), hold on
plot(intE1,all_SUMMARYDATA(CUE_S,5),'o','color',[194/255 165/255 207/255])
plot(intE2,all_SUMMARYDATA(CUE_S,5),'o','color',[123/255 50/255 148/255])
plot(intE1(align),all_SUMMARYDATA(CUE_S(align),5),'.','color',[194/255 165/255 207/255])
[coeffs,rsq,RMSE] = evalcorr(intE1(align),all_SUMMARYDATA(CUE_S(align),5)',1,[0.75 0.75 0.75]);
text(0.005,-10,num2str([rsq; RMSE]))
plot(intE2(align),all_SUMMARYDATA(CUE_S(align),5),'.','color',[123/255 50/255 148/255])
[coeffs,rsq,RMSE] = evalcorr(intE2(align),all_SUMMARYDATA(CUE_S(align),5)',1);
text(0.02,-6,num2str([rsq; RMSE]))

plot(intEall,all_SUMMARYDATA(CUE_S,5),'o','color',[194/255 165/255 207/255])
plot(intE2,all_SUMMARYDATA(CUE_S,5),'o','color',[123/255 50/255 148/255])


ylabel('Exp Tidal Volume (L)'), xlabel('Integral of 95% Energy of Envelope (Pa*s)')
%%
% Resp Timing is START-EXH (row), END-EXH (row), START-INH (row), END-INH (row), Breath-duration (sec), Exhale-duration (sec), Inhale-duration (sec)
subplot(223), hold on
plot(time_window1,RESPTIMING(CUE_S,6),'o','color',[194/255 165/255 207/255])
plot(time_window2,RESPTIMING(CUE_S,6),'o','color',[123/255 50/255 148/255])
plot(time_window1(align),RESPTIMING(CUE_S(align),6),'.','color',[194/255 165/255 207/255])
plot(time_window2(align),RESPTIMING(CUE_S(align),6),'.','color',[123/255 50/255 148/255])
% plot(RESPTIMING(CUE_S,6),R.cue(CUE_R,2),'k*') % from audit - but
% resolution is only 0.1 s, so too coarse

[coeffs,rsq,RMSE] = evalcorr(time_window1(align),RESPTIMING(CUE_S(align),6)',1,[0.75 0.75 0.75]);
text(0.2,0.8,num2str([rsq; RMSE]))

[coeffs,rsq,RMSE] = evalcorr(time_window2(align),RESPTIMING(CUE_S(align),6)',1);
text(0.3,0.8,num2str([rsq; RMSE]))


ylabel('Exh Duration (s)'), xlabel('95% Energy Duration (s)')


%%
subplot(224), hold on
plot(intEall(:,1),all_SUMMARYDATA(CUE_S,5),'o','color',[194/255 165/255 207/255])
plot(intEall(:,2),all_SUMMARYDATA(CUE_S,5),'o','color',[123/255 50/255 148/255])
plot(intEall(align,1),all_SUMMARYDATA(CUE_S(align),5),'.','color',[194/255 165/255 207/255])
plot(intEall(align,2),all_SUMMARYDATA(CUE_S(align),5),'.','color',[123/255 50/255 148/255])

[coeffs,rsq,RMSE] = evalcorr(intEall(align,1),all_SUMMARYDATA(CUE_S(align),5),1,[0.75 0.75 0.75]);
text(0.015,-6.8,num2str([rsq; RMSE]))

[coeffs,rsq,RMSE] = evalcorr(intEall(align,2),all_SUMMARYDATA(CUE_S(align),5),1); 
text(0.022,-6.8,num2str([rsq; RMSE]))


ylabel('Exp Tidal Volume (L)'), xlabel('Integral of Audited Exhale Envelope (Pa*s)')

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures'
print(strcat(tag,'-5minExpCorrelate'),'-dpng')

%% plot full signal, filtered signal, envelope and coefficients 
figure(22),clf, hold on
plot(intE1,all_SUMMARYDATA(CUE_S,5),'o','color',[194/255 165/255 207/255])
plot(intE2,all_SUMMARYDATA(CUE_S,5),'o','color',[123/255 50/255 148/255])
[coeffs,rsq,RMSE] = evalcorr(intE2(align),all_SUMMARYDATA(CUE_S(align),5)',1);
text(max(intE2),min(all_SUMMARYDATA(CUE_S,5))-1,num2str([rsq; RMSE]))
[coeffs,rsq,RMSE] = evalcorr(intE1(align),all_SUMMARYDATA(CUE_S(align),5)',1);
text(max(intE1),min(all_SUMMARYDATA(CUE_S,5))-1,num2str([rsq; RMSE]))

plot(intEall,all_SUMMARYDATA(CUE_S,5),'o')
[coeffs,rsq,RMSE] = evalcorr(intEall(:,1),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEall(:,1)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))
[coeffs,rsq,RMSE] = evalcorr(intEall(:,2),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEall(:,2)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))


plot(intEallC,all_SUMMARYDATA(CUE_S,5),'o')
[coeffs,rsq,RMSE] = evalcorr(intEallC(:,1),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEallC(:,1)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))
[coeffs,rsq,RMSE] = evalcorr(intEallC(:,2),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEallC(:,2)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))

plot(intEallR,all_SUMMARYDATA(CUE_S,5),'o')
[coeffs,rsq,RMSE] = evalcorr(intEallR(:,1),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEallR(:,1)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))
[coeffs,rsq,RMSE] = evalcorr(intEallR(:,2),all_SUMMARYDATA(CUE_S,5),1);
text(max(intEallR(:,2)),min(all_SUMMARYDATA(CUE_S,5)-1),num2str([rsq; RMSE]))



return

%% plot all envelopes, some with pneum on 
figure(23), clear b mx1 mx2 ind1 ind2
for i = 1:length(R.cue)
    [b(i).clean(:,1),afs] = cleanbreath_fun(tag,R.cue(i,:),recdir,0,1); % channel 1
    [~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);
    
    [b(i).clean(:,2),afs] = cleanbreath_fun(tag,R.cue(i,:),recdir,0,2); % channel 2
    [~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);
    
    figure(23)
    subplot(ceil(length(R.cue)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
    
    [start1(i),stop1(i),time_window1(i)] = energy95(b(i).env(:,1),fs);
    [start2(i),stop2(i),time_window2(i)] = energy95(b(i).env(:,2),fs);
    
    [mx1(i),ind1(i)] = max(b(i).env(start1(i)*fs:round(stop1(i)*fs),1)); plot(ind1(i)/fs + start1(i),mx1(i),'*')
    [mx2(i),ind2(i)] = max(b(i).env(start2(i)*fs:round(stop2(i)*fs),2)); plot(ind2(i)/fs + start2(i),mx2(i),'*')
end

figure(22), clf, hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
for i = 1:length(b)
    if ismember(i,CUE_R) == 1 % if breath has pneumotach on
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
    else 
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[166/255 219/255 160/255]) % dark green
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[0 137/255 55/255]) % light green
    end
end
