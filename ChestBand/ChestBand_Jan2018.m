% Chest Band Re-Do

%% import files: select trial
clear, close all
load('DQfiles2017')
f = 9; tag = DQ2017{f,1};
% file 61 = 9; 44 = 5; 22 = 2;

% load resp summary data
[all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2});

% load tag audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'exh'); % exhales only
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);

%% run chest band to get measured and estimated VT
% load ChestBand data and get measured and estimated VT
RunChestBand_apply
%%%%%%%%%%%%%%%%%%% CLEAN UP, REMOVE SOME OF THESE EXTRA VARIABLES

%% plot what we have
%% check and make sure that breaths are at the right time
figure(12); clf
plot(t/tickrate,FilteredFlow,'LineWidth',2); hold on
% find pneumotach cues
[~,pneum] = findaudit(R,'pneum');
for n = 1:length(pneum.cue(:,1))
    line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
end
% plot all breaths - exhales only
[~,breath] = findaudit(R,'exh');
for n = 1:length(breath.cue)
    line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
    text(breath.cue(n,1)-tcue,50,num2str(n)) % cue in audit structure
end
text(breath.cue(n,1)-tcue+20,50,'Exh Audit Cue')
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

CUE_S = find(CUE); CUE_R = CUE(find(CUE));

% plot pneumotach row numbers
offset = Flocs(1) - RESPTIMING(1);
for i = 1:size(all_SUMMARYDATA,1)
    text((RESPTIMING(i)+offset)/tickrate,40,num2str(i)) % row number in all_SUMMARYDATA
end
text((RESPTIMING(i)+offset)/tickrate+20,40,'Pneumotach row')

%% make a matrix of cues where we have all three sources
idx_all = horzcat(Fmatch,match,CUE_R); % pneumotach row, band index, exh cue

VT(:,1) = abs(all_SUMMARYDATA(idx_all(:,1),5)); % pneumotach measured VT
VT(:,2) = EVTest(match); % band estimated VT

%% import sound and calculate integral
figure(6), subplot(131), hold on
for k = 1:length(CUE_R)
    if isnan(CUE_R(k)) ~= 1
        [s,afs] = d3wavread([breath.cue(CUE_R(k),1) breath.cue(CUE_R(k),1)+breath.cue(CUE_R(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        sigstore{1,k} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        sigstore{2,k} = s2; % store
        
        % compute filtered envelopes
        [E,E2,E2_s_1,~] = envfilt(sigstore{1,k},afs); % channel 1
        [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,k},afs); % channel 2
        figure(6)
        plot((1:length(E2_s_1))/newfs,E2_s_1+k/1000,'color',[194/255 165/255 207/255]) % channel 1
        plot((1:length(E2_s_2))/newfs,E2_s_2+k/1000,'color',[123/255 50/255 148/255]) % channel 2
        text(0.5,k/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        % text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
        text(0.6,(k+0.02)/1000,num2str(CUE_R(k))) % exh cue
        
        % figure(199), hold on
        Sint1(k) = trapz(E2_s_1); % integrate filtered sound
        Sint2(k) = trapz(E2_s_2);
        %h = scatter(Sint2(i),abs(B(i))); % plot integral of filtered sound channel 2 versus exhaled VT
        %h.MarkerFaceColor = h.MarkerEdgeColor; h.MarkerFaceAlpha = 0.5;
    else
        Sint1(k) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
        Sint2(k) = NaN;
    end
end

%% these are filtered like in rest5envelopes_exh
% for i = 1:length(CUE_R)
%     [b(i).clean(:,1),afs,b(i).raw(:,1)] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,1); % channel 1
%     [~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);
%     
%     [b(i).clean(:,2),afs,b(i).raw(:,2)] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,2); % channel 2
%     [~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);
%     
%     figure(21),
%     subplot(ceil(length(CUE_R)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
%     plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
%     plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
%     
%     Sint1b(i) = trapz(b(i).env(:,1));
%     Sint2b(i) = trapz(b(i).env(:,2));
% end

%% Plot the sound and the estimates based on band and pneumotach
figure(199), hold on
xlabel('Integral of Filtered Sound')
ylabel('Exhaled Tidal Volume (L)')
title(regexprep(filename,'_',' '))
%plot(Sint1,VT(:,1),'ko','markerfacecolor','k')
%plot(Sint1,VT(:,2),'bo','markerfacecolor','b')
plot(Sint2,VT(:,1),'ko','markerfacecolor','k')
plot(Sint2,VT(:,2),'bo','markerfacecolor','b')

for i = 1:length(Sint1)
%plot([Sint1(i) Sint1(i)],[VT(i,1) VT(i,2)],'k:')
plot([Sint2(i) Sint2(i)],[VT(i,1) VT(i,2)],'k:')
end
delt = VT(:,1)-VT(:,2); 
% [~,~,~,yresid1,fit1,gof1] = evalcorr(Sint1',VT(:,1),1,'g',1); legend off
[~,~,~,yresid2,fit2,gof2] = evalcorr(Sint2',VT(:,1),1,'g',1); legend off
[ci_sound] = predint(fit2,min(Sint2):0.01:max(Sint2));
H = plot_ci(min(Sint2):0.01:max(Sint2),ci_sound,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');

[~,~,~,~,fitband,gofband] = evalcorr(Sint2',VT(:,2),1,'g',1); legend off

%% Now, breaths with band and without pneumotach 
poff = find(~ismember(1:size(breath.cue),CUE)); % breaths that are not in CUE
figure(12)
plot(Blocs(othr)/tickrate,Bpks(othr),'r*') % breaths where we have band estimates
plot(breath.cue(poff,1)-tcue,zeros(length(poff),1),'ko') % breath cues with no pneumotach
[BonPoff,mind] = nearest(breath.cue(:,1)-tcue',Blocs(othr)'/tickrate,1,0); % find the nearest breath cue

% Import, calculate integral
figure(6), subplot(132), hold on
for k = 1:length(BonPoff)
    if isnan(BonPoff(k)) ~= 1
        [s,afs] = d3wavread([breath.cue(BonPoff(k),1) breath.cue(BonPoff(k),1)+breath.cue(BonPoff(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        sigstore{1,k} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        sigstore{2,k} = s2; % store
        
        % compute filtered envelopes
        [E,E2,E2_s_1,~] = envfilt(sigstore{1,k},afs); % channel 1
        [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,k},afs); % channel 2
        figure(6)
        plot((1:length(E2_s_1))/newfs,E2_s_1+k/1000,'color',[194/255 165/255 207/255]) % channel 1
        plot((1:length(E2_s_2))/newfs,E2_s_2+k/1000,'color',[123/255 50/255 148/255]) % channel 2
        text(0.5,k/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        % text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
        text(0.6,(k+0.02)/1000,num2str(BonPoff(k))) % exh cue
        
        % figure(199), hold on
        Sint1_BonPoff(k) = trapz(E2_s_1); % integrate filtered sound
        Sint2_BonPoff(k) = trapz(E2_s_2);
        %h = scatter(Sint2(i),abs(B(i))); % plot integral of filtered sound channel 2 versus exhaled VT
        %h.MarkerFaceColor = h.MarkerEdgeColor; h.MarkerFaceAlpha = 0.5;
    else
        Sint1_BonPoff(k) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
        Sint2_BonPoff(k) = NaN;
    end
end

figure(199)
% plot(Sint1_BonPoff,EVTest(othr),'bo')
plot(Sint2_BonPoff,EVTest(othr),'bo')

%% All breath sounds when pneum off 
figure(6), subplot(133), hold on
for k = 1:length(poff)
    if isnan(poff(k)) ~= 1
        [s,afs] = d3wavread([breath.cue(poff(k),1) breath.cue(poff(k),1)+breath.cue(poff(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        sigstore{1,k} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        sigstore{2,k} = s2; % store
        
        % compute filtered envelopes
        [E,E2,E2_s_1,~] = envfilt(sigstore{1,k},afs); % channel 1
        [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,k},afs); % channel 2
        figure(6)
        plot((1:length(E2_s_1))/newfs,E2_s_1+k/1000,'color',[194/255 165/255 207/255]) % channel 1
        plot((1:length(E2_s_2))/newfs,E2_s_2+k/1000,'color',[123/255 50/255 148/255]) % channel 2
        text(0.5,k/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        % text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
        text(0.6,(k+0.02)/1000,num2str(poff(k))) % exh cue
        
        % figure(199), hold on
        Sint1_poff(k) = trapz(E2_s_1); % integrate filtered sound
        Sint2_poff(k) = trapz(E2_s_2);
        %h = scatter(Sint2(i),abs(B(i))); % plot integral of filtered sound channel 2 versus exhaled VT
        %h.MarkerFaceColor = h.MarkerEdgeColor; h.MarkerFaceAlpha = 0.5;
    else
        Sint1_poff(k) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
        Sint2_poff(k) = NaN;
    end
end
figure(199)
[ci_off2] = predint(fit2,sort(Sint2_poff'));
plot(Sint2_poff,feval(fit2,Sint2_poff),'ko')
H = plot_ci(sort(Sint2_poff'),ci_off2,'patchcolor',[0 0 0],'patchalpha',0.25,'linecolor','w');
[ci_band] = predint(fitband,sort(Sint2_poff)');
H = plot_ci(sort(Sint2_poff)',ci_band,'patchcolor',[0 0 1],'patchalpha',0.25,'linecolor','w');
xlabel('Integral of Filtered Sound')
ylabel('Exhaled Tidal Volume (L)')

cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
print(regexprep(filename,'.mat','pneumband.png'),'-dpng')

% pneum on-off sound and measured and estimated VT 
%figure(200), clf, hold on
%allSint = vertcat(Sint1',Sint1_poff'); 
%allVT = vertcat(VT(:,1),fit1(Sint1_poff)); 
%Pon = vertcat(ones(length(Sint1),1),zeros(length(Sint1_poff),1)); 
%scatterhist(allSint,allVT,'group',Pon,'kernel','on','location','NE','direction','out')

figure(202), clf, hold on
allSint = vertcat(Sint2',Sint2_poff'); 
allVT = vertcat(VT(:,1),fit2(Sint2_poff)); 
Pon = vertcat(ones(length(Sint2),1),zeros(length(Sint2_poff),1)); 
scatterhist(allSint,allVT,'group',Pon,'kernel','on','location','NE','direction','out')

