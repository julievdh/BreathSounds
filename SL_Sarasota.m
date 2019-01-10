FlowSoundPlot_Sarasota
FlowSoundAssess
load('6May2014_water_tt126b_FB142_resp_surfstore.mat')
q20 = find(Quality == 20);

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

%% plot 3d PSD and flow like we did with syringe
figure(90), clf, hold on
strt=find(F > 200,1,'first');
L = find(F < 0.5E4,1,'last'); % zoom in on the first half of F range
[cvec,c_all] = getcmap(mxEflow,'Max Exhaled Flow Rate (L/s)'); % colormap by flow rate
for i = 1:length(allstore)
    if ~isnan(mxEflow(i))
        plot3(F(1:L),zeros(1,L)+abs(mxEflow(i)),allstore(i).Pxx_e(1:L)/sum(allstore(i).Pxx_e(1:L)),'color',c_all(i,:))
    end
end

xlabel('Frequency'), ylabel('Max Exhaled Flow Rate (L/s)'), zlabel('norm PSD')

set(gca,'view',[13.8667   57.4667])
% print([cd '\AnalysisFigures\Syringe-147z-pneumon-PSD.png'],'-dpng')

figure(92),
hold on, for i = 1:length(allstore)
    if ~isnan(mxEflow(i))
        plot3(F(1:L),zeros(1,L)+abs(mxEflow(i)),allstore(i).SL_e(1:L),'color',c_all(i,:))
    end
end
set(gca,'view',[0.5 0])
xlabel('Frequency (Hz)'), zlabel('SL'), title('Exhale')

% norm PSD
figure(91), clf, hold on
strt=find(F > 200,1,'first');
L = find(F < 0.5E4,1,'last'); % zoom in on the first half of F range
[cvec,c_all] = getcmap(abs(mxIflow),'Max Inhaled Flow Rate (L/s)'); % colormap by flow rate
for i = 1:length(allstore)
    if ~isnan(mxflowI(i))
        plot3(F(1:L),zeros(1,L)+abs(mxIflow(i)),allstore(i).Pxx_i(1:L)/sum(allstore(i).Pxx_i(1:L)),'color',c_all(i,:))
    end
end

xlabel('Frequency'), ylabel('Max Inhaled Flow Rate (L/s)'), zlabel('norm PSD')

set(gca,'view',[13.8667   57.4667])

% SL
figure(93),
hold on, for i = 1:length(allstore)
    if ~isnan(mxflowI(i))
        plot3(F(1:L),zeros(1,L)+abs(mxIflow(i)),allstore(i).SL_i(1:L),'color',c_all(i,:))
    end
end
set(gca,'view',[0.5 0])
xlabel('Frequency (Hz)'), zlabel('SL'), title('Inhale')

%% plot all spectrograms
% get sorted indices for flow rates -- i think these indices are off
[vE,idxE] = sort(mxEflow);
[vI,idxI] = sort(mxIflow);
for n = 1:length(CUE_R)
    %% 
    if isnan(CUE_R(n)) == 0
        if Quality(CUE_R(n)) == 0 % only if Quality == 0
            % and only the good E/I portions go in?
            [s,afs] = d3wavread([breath.cue(CUE_R(n),1)-0.4 breath.cue(CUE_R(n),1)+breath.cue(CUE_R(n),2)+0.6],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
            s = s(:,CH)-mean(s(:,CH)); % channel 1 minus DC offset
            s = cleanup_d3_hum(s,afs);
            [~,~,~,s_a] = CleanSpectra_fun(s,afs,[breath.cue(CUE_R(n),1)-0.4 breath.cue(CUE_R(n),2)+0.4+0.6]);
        end
        if isnan(exp(CUE_R(n))) == 0
            figure(100)
            subplot(3,5,n)
            bspectrogram(s((exp(CUE_R(n),1))*afs:(exp(CUE_R(n),2))*afs),afs,[0 exp(CUE_R(n),2)-exp(CUE_R(n),1)]);            
            title(num2str(vE(n)))
        end
        if isnan(ins(CUE_R(n))) == 0
            figure(101)
            subplot(3,5,n)
            bspectrogram(s((ins(CUE_R(n),1))*afs:(ins(CUE_R(n),2))*afs),afs,[0 ins(CUE_R(n),2)-ins(CUE_R(n),1)]);
            title(num2str(vI(n)))
        end
    end
end

%% plot flow sound coloured by flow rate
figure(9), clf, subplot(121), hold on
[cvec,c_all] = getcmap(mxEflow,'Max Exhaled Flow Rate'); % colormap by distance
for i = 1:length(allstore)
    allstore(i).sounde = medfilt1(allstore(i).sounde,5); 
plot(allstore(i).sounde,allstore(i).flowe,'o','color',cvec(i,:))
end
colorbar off, title('Exhale')
xlabel('Sound'), ylabel('Flow Rate (L/s)')
subplot(122), hold on 
[cvec,c_all] = getcmap(mxIflow,'Max Inhaled Flow Rate'); % colormap by distance
for i = 1:length(allstore)
    allstore(i).soundi = medfilt1(allstore(i).soundi,5); 
plot(allstore(i).soundi,-allstore(i).flowi,'o','color',cvec(i,:))
end
colorbar off, title('Inhale')
xlabel('Sound'), ylabel('Flow Rate (L/s)')