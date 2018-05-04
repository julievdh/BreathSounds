% apply to all where no pneumotach on syringe

% for n = 1:length(tags(f).sin) % 1:length(q);
%     if pneum(n) == 0
%         
%         allstore(n).sound = []; % make sure a row is empty
%         [s,afs] = d3wavread([tags(f).sin(n,1)-0.2 tags(f).sout(n,1)+tags(f).sout(n,2)+0.2],d3makefname(tags(f).name,'RECDIR'), [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
%         s1 = s(:,1)-mean(s(:,1)); % channel 1 minus DC offset
%         s2 = s(:,2)-mean(s(:,2));
%         [~,~,~,s1_a] = CleanSpectra_fun(s1,afs,[tags(f).sin(n,1)-0.2 length(s1)/afs]);
%         [~,~,~,s2_a] = CleanSpectra_fun(s2,afs,[tags(f).sin(n,1)-0.2 length(s2)/afs]);
%         s1_a(s1_a == 0) = NaN;  % clean signal based on kurtosis and NaN out zeros
%         s2_a(s2_a == 0) = NaN;
%         H1 = hilbenv(s1_a); % take hilbert
%         H2 = hilbenv(s2_a);
%         ffs = tickrate(1); % flow sampling rate
%         
%         dr = round(afs/ffs); % decimation rate
%         y = resample(H1,1,dr)-nanmean(H1(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
%         y2 = resample(H2,1,dr)-nanmean(H2(1:12000));
%         
%         figure(100)
%         plot(y)
%         
%         temp = ginput(2);
%             strt = temp(1,1); ed = temp(2,1);
%                
%             allstore(n).soundi(:,1) = y(strt:ed)-min(y(strt:ed))+1E-10;
%             allstore(n).sound2i(:,1) = y2(strt:ed)-min(y2(strt:ed))+1E-10;
%             
%             allstore(n).idxi = strt:ed;
%             
%             % syringe out
%             figure(100)
%             temp = ginput(2);
%             strt = temp(1,1); ed = temp(2,1);
%             
%             allstore(n).soundo(:,1) = y(strt:ed)-min(y(strt:ed))+1E-10;
%             allstore(n).sound2o(:,1) = y2(strt:ed)-min(y2(strt:ed))+1E-10;
%             
%             allstore(n).idxo = strt:ed;
%                             
%             % apply that relationship
%         allstore(n).sfilli = naninterp(allstore(n).soundi);                   % interpolate NaNs
%         allstore(n).sfilli(find(allstore(n).sfilli<0)) = 0;                           % zero out any negative values at the beginning
%         allstore(n).sfilli(find(allstore(n).sfilli>max(allstore(n).soundi))) = 0;    % interpolation should never exceed max envelope
%         % hydrophone 2
%         allstore(n).sfilli2 = naninterp(allstore(n).sound2i);                   % interpolate NaNs
%         allstore(n).sfilli2(find(allstore(n).sfilli2<0)) = 0;                           % zero out any negative values at the beginning
%         allstore(n).sfilli2(find(allstore(n).sfilli2>max(allstore(n).sound2i))) = 0;    % interpolation should never exceed max envelope
%         % out
%         allstore(n).sfillo = naninterp(allstore(n).soundo);                   % interpolate NaNs
%         allstore(n).sfillo(find(allstore(n).sfillo<0)) = 0;                           % zero out any negative values at the beginning
%         allstore(n).sfillo(find(allstore(n).sfillo>max(allstore(n).soundo))) = 0;    % interpolation should never exceed max envelope
%         % hydrophone 2
%         allstore(n).sfillo2 = naninterp(allstore(n).sound2o);                   % interpolate NaNs
%         allstore(n).sfillo2(find(allstore(n).sfillo2<0)) = 0;                           % zero out any negative values at the beginning
%         allstore(n).sfillo2(find(allstore(n).sfillo2>max(allstore(n).sound2o))) = 0;    % interpolation should never exceed max envelope
%         
%         % estimate flow from sound - both hydrophones
%         allstore(n).Festi = ai*(allstore(n).sfilli).^bi;
%         allstore(n).Festi2 = ai*(allstore(n).sfilli2).^bi;
%         allstore(n).Festo = a*(allstore(n).sfillo).^b;
%         allstore(n).Festo2 = a*(allstore(n).sfillo2).^b;
%         
%             
%         VTest(1,n) = trapz(allstore(n).Festo)/(afs/dr);
%         VTest(2,n) = trapz(allstore(n).Festo2)/(afs/dr);
%         VTesti(1,n) = trapz(allstore(n).Festi)/(afs/dr);
%         VTesti(2,n) = trapz(allstore(n).Festi2)/(afs/dr);
%             
%     end
% end
FlowSoundPlot_Syringe

for n = 1:length(allstore)
            VTest(1,n) = trapz(allstore(n).Festo)/(afs/dr);
        VTest(2,n) = trapz(allstore(n).Festo2)/(afs/dr);
        VTesti(1,n) = trapz(allstore(n).Festi)/(afs/dr);
        VTesti(2,n) = trapz(allstore(n).Festi2)/(afs/dr);
end

PlotSyringeApply
%% linear model to assess VT estimate effect of syringe, distance, etc
tbl = table(dist3', pneum, flow',VTest(1,:)',VTesti(1,:)',...
    'VariableNames',{'Distance','Pneumo','Flow','VTesto','VTesti'});
% fit a linear model: is the source level affected by distance or
% pneumotach?
lm_exh = fitlm(tbl,'VTesto~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)
lm_inh = fitlm(tbl,'VTesti~Distance+Flow+Pneumo','Categorical',{'Flow','Pneumo'})%, plotSlice(lm)

figure(32), clf
co = [0 93 154]/255;
plotSlice(lm_exh)
% SyringeSpecLMfig(lm_exh,co)


return 

figure(4), clf, hold on
allflow = extractfield(allstore,'flow')';
allsound = extractfield(allstore,'sound')';
inhflow = find(allflow < -1);
exhflow = find(extractfield(allstore,'flow') > 1);
plot(allsound(inhflow),-allflow(inhflow),'o')
plot(curvei), legend off
plot(extractfield(surfstore,'E'),extractfield(surfstore,'Festi'),'.')

% figure(14), clf, hold on
% for i = 1:length(surfstore)
%     if isempty(surfstore(i).SL_o) == 0
%     plot(F,surfstore(i).SL_o)
%     end
% end

figure(29)
hold on
for n = 1:length(q)
    plot(breath.cue(q(n))/60,surfstore(n).VTesti,'kv','markerfacecolor',[0.5 0.5 0.5])
end

% get swimming values and fill in NaN when quality is not good
VTi_swim = extractfield(surfstore,'VTesti');
VTi_swim(VTi_swim < 1) = NaN;
NA = find(isnan(VTi_swim)); % replace NaN with mean and sd

for i = 1:length(NA)
    plot([breath.cue(q(NA(i)),1)/60 breath.cue(q(NA(i)),1)/60],[nanmean(VTi_swim)-nanstd(VTi_swim) nanmean(VTi_swim)+nanstd(VTi_swim)],'k')
end

plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1),'kv','markerfacecolor','w')
VTi_swim(NA) = nanmean(VTi_swim);

%% what about Quality = 0 when no Pneumotach?
q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
% q = [1:2 77:82]; % good quality when no pneumotach, so resting, should be similar
for n = 1:length(q);
    sub = []; H = [];
    [s,afs] = d3wavread([breath.cue(q(n),1)-0.2 breath.cue(q(n),1)+breath.cue(q(n),2)+0.5],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    
    s = s(:,1)-mean(s(:,1)); % channel 1 minus DC offset
    H = hilbenv(s); % take hilbert
    y = resample(H,1,dr)-mean(H(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
    % remove mean of first 0.05 s to remove noise floor
    
    %figure(90), clf
    %subplot(211),
    %plot(H), xlim([0 length(H)])
    %subplot(212),
    %bspectrogram(s,afs,breath.cue(q(n),:));
    %xlabel('Time')
    % get input for inhale selection
    %temp = ginput(2);
    %strt = temp(1,1); ed = temp(2,1);
    if isnan(ins(q(n))) == 0
        sub = H(ins(q(n),1)*afs:ins(q(n),2)*afs); % select subset of signal
        y = resample(sub,1,dr); % -mean(sub(1:4800)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        figure(91), hold on
        plot((1:length(sub))/afs,sub)
        
        plot((1:length(y))/(afs/dr),y,'LineWidth',2)
        reststore(n).soundi(:,1) = y;
        
        % also get spectral content
        [Pxx_i,Freq,bw_i,s_i] = CleanSpectra_fun(s(ins(q(n),1)*afs:ins(q(n),2)*afs),afs,[breath.cue(q(n)) ins(q(n),2)-ins(q(n),1)]);
        [E,E2,E2_s,newfs] = envfilt(s_i,afs); % get envelope and filter
        reststore(n).E = E2_s; % this is sampled at newfs
        [SL_i,F] = speclev(s_i,2048,afs);
        reststore(n).SL_i = SL_i;
        reststore(n).Pxx_i = Pxx_i;
    end
end
for n = 1:length(reststore)
    reststore(n).Festi = ai*(reststore(n).E).^bi; % do it on the filtered envelope with the bad bits removed
    reststore(n).VTesti = trapz(reststore(n).Festi)/newfs;
end

figure(4)
plot(extractfield(reststore,'E'),extractfield(reststore,'Festi'),'.')

figure(29)
plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'.')
