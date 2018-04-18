% clear, close all
load('DQfiles2017'), warning off
fcount = 1;
for f = 17; 
    keep corrstore f DQ2017 fcount
    tag = DQ2017{f,1};
    
    % load resp summary data
    % [all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2});
    filename = strcat(DQ2017{f,2},'_resp');
    load([cd '\PneumoData\' filename])
    
    % load tag audit data
    R = loadaudit(tag);
    [~,breath] = findaudit(R,'exh'); % exhales only
    CUE_R = ECUE(find(ECUE));
    PneumCueTimeline % plot these things aligned
    %% take a signal
    CH = 2; % channel
    pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
    pnum = find(~isnan(ECUE)); % find the breath number in SUMMARYDATA
    for cuen = 1:length(breath.cue)
        % cuen = pon(c);
        [s,afs] = d3wavread([breath.cue(cuen,1) breath.cue(cuen,1)+breath.cue(cuen,2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
        s(:,1) = s(:,1)-mean(s(:,1)); s(:,2) = s(:,2)-mean(s(:,2));
        [Pxx(:,cuen),Freq,bw,s] = CleanSpectra_fun(s(:,CH),afs,breath.cue(cuen,:));
        [SL_o(:,cuen),F] = speclev(s,2048,afs);
        [E,E2,E2_s,newfs] = envfilt(s,afs); %
        figure(16), hold on
        plot((1:length(E2_s))/newfs,E2_s+cuen/1000)
        Sint1(cuen) = trapz(E2_s); % integral of filtered sound
        envstore{cuen} = E2_s; % store
        
        figure(14),
        subplot(ceil(length(breath.cue)/6),6,cuen), hold on;
        bspectrogram(s,afs,breath.cue(cuen,:));
        dur(cuen) = breath.cue(cuen,2); % duration of marked cue
    end
    %%
    
    
    %figure(3), subplot(121)
    %plot(bw(pon),abs(all_SUMMARYDATA(pnum,4)),'o')
    %xlabel('bandwidth'),ylabel('max exhaled flow rate')
    %subplot(122)
    %plot(cfreq(pon),abs(all_SUMMARYDATA(pnum,4)),'o')
    %xlabel('centroid freq'),ylabel('max exhaled flow rate')
    
    figure(4), clf, hold on
    plot3(Sint1(pon),abs(all_SUMMARYDATA(pnum,5)),abs(all_SUMMARYDATA(pnum,4)),'o')
    xlabel('Integral of Filtered Sound'), ylabel('Measured VT (L)'), zlabel('Max Flow Rate (L/s)')
    % can we plot envelope next to the values?
    for i = 1:length(pon)
        plot3(Sint1(pon(i))+(1:length(envstore{pon(i)}))/(afs/4),2000*envstore{pon(i)}+abs(all_SUMMARYDATA(pnum(i),5)),abs(all_SUMMARYDATA(pnum(i),4))+(1:length(envstore{pon(i)}))/(afs/4))
    end
    %%
    
    figure(90), clf, hold on
    strt=find(Freq > 200,1,'first');
    L = find(Freq < 0.5E4,1,'last'); % zoom in on the first half of F range
    
    for i = 1:length(pon)
        plot3(Freq(1:L),zeros(L,1)+abs(all_SUMMARYDATA(pnum(i),4)),Pxx(1:L,pon(i))/sum(Pxx(1:L,pon(i))))
    end
    xlabel('Frequency'), ylabel('Max Exhaled Flow Rate (L/s)'), zlabel('norm PSD')
    
    %% find optimal bands to sort on and run LM
    % optimalBands - syringe result
    besthigh = 3000; bestlow = 500; width = 1000;
    % recompute SL with the best bands, for both inhales and exhales
    for k = 1:size(SL_o,2)
        SLlow_o(k) = mean(SL_o(F>bestlow-width/2 & F <bestlow+width/2,k));
        SLhigh_o(k) = mean(SL_o(F>besthigh-width/2 & F <besthigh+width/2,k));
        if exist('SL_i') == 1 % only if also have exhales
            SLlow_i(k) = mean(SL_i(F>bestlow-width/2 & F <bestlow+width/2,k));
            SLhigh_i(k) = mean(SL_i(F>besthigh-width/2 & F <besthigh+width/2,k));
        end
    end
    SLdiff_o = SLlow_o - SLhigh_o;
    
    %figure(13); clf, hold on
    %subplot(121), hold on
    %plot(SLlow_o(pon),abs(all_SUMMARYDATA(pnum,4)),'o')
    %plot(SLhigh_o(pon),abs(all_SUMMARYDATA(pnum,4)),'o')
    %xlabel('SLlow and SLhigh'), ylabel('Max Flow Rate (L/s)')
    %subplot(122)
    %plot(SLdiff_o(pon),abs(all_SUMMARYDATA(pnum,4)),'o')
    %xlabel('SLlow-SLhigh')
    
    tbl_o = table(abs(all_SUMMARYDATA(pnum,4)),abs(all_SUMMARYDATA(pnum,5)),Sint1(pon)',SLlow_o(pon)',SLhigh_o(pon)',SLdiff_o(pon)',dur(pon)',...
        'VariableNames',{'MaxFlow','VT','Sint','SLlow','SLhigh','SLdiff','Duration'});
    % fit a linear model: can Sint or SLlow-high-diff be used to indicate flow?
    lm = fitlm(tbl_o,'MaxFlow~Sint+SLhigh+SLdiff+Duration'); % plotSlice(lm)
    lm = fitlm(tbl_o,'VT~Sint*Duration+SLhigh+SLdiff'); % plotSlice(lm)
    
    % try fit function with duration in it
    x = Sint1(pon);
    y = dur(pon);
    z = abs(all_SUMMARYDATA(pnum,5)); % output
    [curve,gof] = createFit(x, y, z);
    
    % try power curve
    [lmp,gofp] = fit(x(~isnan(x))',z(~isnan(x)),'a*x^b','robust','bisquare');
    
    figure(99)
    subplot(3,4,fcount), hold on
    plot(Sint1(pon),abs(all_SUMMARYDATA(pnum,5)),'o')
    xlabel('Integral of Filtered Sound'), ylabel('Measured VT (L)')
    % plot envelope next to the values
    for i = 1:length(pon)
        plot(Sint1(pon(i))+(1:length(envstore{pon(i)}))/(afs/4),2000*envstore{pon(i)}+abs(all_SUMMARYDATA(pnum(i),5)))
    end
    text(0.01,18,['RMSE = ' num2str(sqrt(lm.MSE)) '  ' num2str(gofp.rmse) ' L'])
    text(0.01,16,['R^2_A = ' num2str(lm.Rsquared.Adjusted) '  ' num2str(gofp.rsquare)])
    text(0.01,14,['tag ' num2str(DQ2017{f,4})])
    % xlim([0 0.05])
    ylim([0 20])
    
    %% store
    corrstore(f).Sint1 = Sint1;
    corrstore(f).all_SUMMARYDATA = all_SUMMARYDATA;
    corrstore(f).pon = pon;
    corrstore(f).pnum = pnum;
    corrstore(f).RESPTIMING = RESPTIMING;
    corrstore(f).lmp = lmp; % power function
    corrstore(f).gofp = gofp; % power function fit 
    corrstore(f).lm = lm; % linear model
    corrstore(f).curve = curve; % linear model with power function including duration
    corrstore(f).gof = gof;
    fcount = fcount+1;
    
end

%% those without pneumotach
poff = find(~ismember(1:size(breath.cue),ECUE));
for c = 1:length(poff)
    cuen = poff(c);
    [s,afs] = d3wavread([breath.cue(cuen,1) breath.cue(cuen,1)+breath.cue(cuen,2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s(:,1) = s(:,1)-mean(s(:,1)); s(:,2) = s(:,2)-mean(s(:,2));
    [~,~,bw,s] = CleanSpectra_fun(s(:,CH),afs,breath.cue(cuen,:));
    [E,E2,E2_s,newfs] = envfilt(s,afs); % envelope of cleaned sound
    [SL_o(:,cuen),F] = speclev(s,2048,afs); % take SL
    SLlow_o(cuen) = mean(SL_o(F>bestlow-width/2 & F <bestlow+width/2,k)); % SL bands
    SLhigh_o(cuen) = mean(SL_o(F>besthigh-width/2 & F <besthigh+width/2,k)); % SL bands
    figure(16), hold on
    plot((1:length(E2_s))/newfs,E2_s+cuen/1000)
    Sint1(cuen) = trapz(E2_s); % integral of filtered sound
end
return 
%% adjust SL and Sint for pneumotach before predicting
Sint1(poff) = Sint1(poff)-0.03;
% SLlow_o(poff) = SLlow_o(poff)-4.3;
% SLhigh_o(poff) = SLhigh_o(poff)-12.5;
% SLdiff_o = SLlow_o - SLhigh_o;

%% predict from linear model with Sint1 and SLhigh and SLdiff
%[pred1,yci] = predict(lm,[zeros(length(pon),1) Sint1(pon)' SLlow_o(pon)' SLhigh_o(pon)' SLdiff_o(pon)' dur(pon)']);
%[pred_off1,yci_off] = predict(lm,[zeros(length(poff),1) Sint1(poff)' SLlow_o(poff)' SLhigh_o(poff)' SLdiff_o(poff)' dur(poff)']);

[pred1,yci] = predict(lmp,log10(Sint1(pon)'));
[pred_off1,yci_off] = predict(lmp,log10(Sint1(poff)'));
pred1 = 10.^(pred1); % because log-transformed
pred_off1 = 10.^(pred_off1); % because log-transformed

figure(202), clf, hold on
allSint = vertcat(Sint1(pon)',Sint1(poff)'); 
allVT = vertcat(z,pred_off1); 
Pon = vertcat(ones(length(pon),1),zeros(length(poff),1)); 
scatterhist(allSint,allVT,'group',Pon,'kernel','on','location','NE','direction','out')

%%
figure(1), clf, subplot(3,1,1:2), hold on 
plot(pred1,z,'o'),
plot([0 20],[0 20])
xlabel('Estimated VT'), ylabel('Measured VT')
subplot(3,1,3), hold on
plot(breath.cue(CUE_R),z,'k.')
plot(breath.cue(CUE_R),pred1,'o')
print([cd '/AnalysisFigures/' tag '_VT_CleanSpectra_meas-est.png'],'-dpng')
return 

%% plot all corrstore data
figure(9), clf
for f = 16:27
    subplot(121), hold on
    plot(f,corrstore(f).gofp.rsquare,'ko',f,corrstore(f).lm.Rsquared.Adjusted,'b^',f,corrstore(f).gof.rsquare,'r*')
    subplot(122), hold on
    plot(f,corrstore(f).gofp.rmse,'ko',f,corrstore(f).lm.RMSE,'b^',f,corrstore(f).gof.rmse,'r*')
end
subplot(121), ylabel('R^2'), xlabel('File number')
subplot(122), ylabel('RMSE (L)'), xlabel('File number')
legend('VT ~ a*Sint^b','VT ~ 1 + SLhigh + SLdiff + Sint*Duration','VT ~ a*(Sint^b)+(c*Dur)+d*(Sint*Dur)')