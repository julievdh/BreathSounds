
q = find(Quality == 20);
tic
for n = 101:length(q) % 1:length(q);
    sub = []; H = [];
    surfstore(n).soundi = []; % make sure a row is empty
    
    [s,sfilt,afs,tcue,tdur] = BreathFilt(q(n),breath,recdir,tag,1); % using RESP not R 
    [~,~,~,s_a] = CleanSpectra_fun(sfilt,afs,[tcue-0.4 tdur+0.4+0.6]);
    % s_a(s_a == 0) = NaN;        % clean signal based on kurtosis and NaN out zeros
    
    H = hilbenv(s_a); % take hilbert
    y = resample(H,1,dr)-mean(H(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
    % remove mean of first 0.05 s to remove noise floor
    
    % plot to check
    %     figure(1), plot(s_a), hold on
    % plot(exp(q(n),1)*afs,0,'k*')
    % plot(exp(q(n),2)*afs,0,'k*')
    % plot(ins(q(n),2)*afs,0,'ko')
    % plot(ins(q(n),1)*afs,0,'ko')
    
    % get previously-selected exhale information
    if isnan(exp(q(n))) == 0
        sub = H((exp(q(n),1))*afs:(exp(q(n),2))*afs); % select subset of signal
        y = resample(sub,1,dr); % -mean(sub(1:4800)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        %figure(91), hold on
        %plot((1:length(sub))/afs,sub)
        %plot((1:length(y))/(afs/dr),y,'LineWidth',2)
        surfstore(n).soundo(:,1) = y;
        
        % also get spectral content
        [Pxx,Freq,bw,~,~,ct] = CleanSpectra_fun(s((exp(q(n),1))*afs:(exp(q(n),2))*afs),afs,[tcue tdur]);
        [SL,F] = speclev(s,2048,afs);
        surfstore(n).SL_o = SL;
        surfstore(n).Pxxo = Pxx;
        surfstore(n).cto = ct;
        
        % apply that relationship
        surfstore(n).sfillo = naninterp(surfstore(n).soundo);                   % interpolate NaNs
        surfstore(n).sfillo(find(surfstore(n).sfillo<0)) = 0;                           % zero out any negative values at the beginning
        surfstore(n).sfillo(find(surfstore(n).sfillo>max(surfstore(n).soundo))) = NaN;    % interpolation should never exceed max envelope
    else surfstore(n).sfillo = NaN;
    end
    % get previously-selected inhale information
    if isnan(ins(q(n))) == 0
        sub = H((ins(q(n),1))*afs:(ins(q(n),2))*afs); % select subset of signal
        y = resample(sub,1,dr); % -mean(sub(1:4800)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        %figure(91), hold on
        %plot((1:length(sub))/afs,sub)
        %plot((1:length(y))/(afs/dr),y,'LineWidth',2)
        surfstore(n).soundi(:,1) = y;
        
        % also get spectral content
        [Pxx,Freq,bw,~,~,ct] = CleanSpectra_fun(s_a((ins(q(n),1))*afs:(ins(q(n),2))*afs),afs,[tcue tdur]);
        [SL,F] = speclev(s_a,2048,afs);
        surfstore(n).SL_i = SL;
        surfstore(n).Pxxi = Pxx;
        surfstore(n).cti = ct; % compared to total number of bins = (length(xfilt)/afs)/0.025 (or exh(:,3)/0.025)
        
        % apply that relationship
        surfstore(n).sfilli = naninterp(surfstore(n).soundi);                   % interpolate NaNs
        surfstore(n).sfilli(find(surfstore(n).sfilli<0)) = 0;                           % zero out any negative values at the beginning
        surfstore(n).sfilli(find(surfstore(n).sfilli>max(surfstore(n).soundi))) = NaN;    % interpolation should never exceed max envelope
        
    end
end
%%
for n = 1:length(surfstore)
    % estimate flow from sound - inhale
    surfstore(n).Festi = ai*(surfstore(n).sfilli).^bi;
    surfstore(n).VTesti = trapz(surfstore(n).Festi)/(afs/dr);
    % estimate flow from sound�- exhale
    %surfstore(n).Festo = a*(surfstore(n).sfillo).^b;
    %surfstore(n).VTesto = trapz(surfstore(n).Festo)/(afs/dr);
    
    %if isempty(surfstore(n).Festo) == 1
    %    surfstore(n).VTesto = NaN;
    %    surfstore(n).cto = NaN;
    %end
    if isempty(surfstore(n).Festi) == 1
        surfstore(n).VTesti = NaN;
        surfstore(n).cti = NaN;
    end
    %         if surfstore(n).cto > (exp(q(n),3)/0.025)/2
    %         surfstore(n).VTesto = NaN;
    %         end
    %         if surfstore(n).cti > (inh(q(n),3)/0.025)/2
    %         surfstore(n).VTesti = NaN;
    %     end
end
toc

return
%%
% figure(4), clf, hold on
% allflow = extractfield(allstore,'flow')';
% allsound = extractfield(allstore,'sound')';
% inhflow = find(allflow < -1);
% exhflow = find(extractfield(allstore,'flow') > 1);
% plot(allsound(inhflow),-allflow(inhflow),'o')
% plot(curvei), legend off
% plot(extractfield(surfstore,'sfilli'),extractfield(surfstore,'Festi'),'.')

% try this to see where we should do cutoff
% plot([surfstore(1:6).VTesto],[surfstore(1:6).cto],'o')


% figure(14), clf, hold on
% for i = 1:length(surfstore)
%     if isempty(surfstore(i).SL_o) == 0
%     plot(F,surfstore(i).SL_o)
%     end
% end
%%
figure(29), % clf
hold on
for n = 1:length(surfstore)
    plot(breath.cue(q(n))/60,surfstore(n).VTesti,'kv','markerfacecolor',[0.5 0.5 0.5])
    % plot(breath.cue(q(n))/60,surfstore(n).VTesto,'k^')
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

xlim([0 round(breath.cue(q(n))/60)])
%% what about Quality = 0 when no Pneumotach?
q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
% good quality when no pneumotach, so resting, should be similar
for n = 1:length(q);
    sub = []; H = [];
    [s,sfilt,afs,tcue,tdur] = BreathFilt(q(n),breath,recdir,tag,1); % using RESP not R 
    [~,~,~,s_a] = CleanSpectra_fun(sfilt,afs,[tcue-0.4 tdur+0.4+0.6]);
    
    H = hilbenv(s_a); % take hilbert
    y = resample(H,1,dr)-mean(H(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
    % remove mean of first 0.05 s to remove noise floor
    
    
    if isnan(ins(q(n))) == 0
        sub = H(ins(q(n),1)*afs:ins(q(n),2)*afs); % select subset of signal
        y = resample(sub,1,dr); % -mean(sub(1:4800)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        figure(91), hold on
        plot((1:length(sub))/afs,sub)
        
        plot((1:length(y))/(afs/dr),y,'LineWidth',2)
        reststore(n).soundi(:,1) = y;
        
        % also get spectral content
        [Pxx_i,Freq,bw_i,s_i,ct] = CleanSpectra_fun(s(ins(q(n),1)*afs:ins(q(n),2)*afs),afs,[breath.cue(q(n)) ins(q(n),2)-ins(q(n),1)]);
        % [E,E2,E2_s,newfs] = envfilt(s_i,afs); % get envelope and filter
        % reststore(n).E = E2_s; % this is sampled at newfs
        [SL_i,F] = speclev(s_i,2048,afs);
        reststore(n).SL_i = SL_i;
        reststore(n).Pxx_i = Pxx_i;
        
        reststore(n).cti = ct;
        
        reststore(n).sfilli = naninterp(reststore(n).soundi);                   % interpolate NaNs
        reststore(n).sfilli(find(reststore(n).sfilli<0)) = 0;                           % zero out any negative values at the beginning
        reststore(n).sfilli(find(reststore(n).sfilli>max(reststore(n).soundi))) = NaN;    % interpolation should never exceed max envelope
    end
    if isnan(exp(q(n))) == 0
        sub = H((exp(q(n),1))*afs:(exp(q(n),2))*afs); % select subset of signal
        y = resample(sub,1,dr); % -mean(sub(1:4800)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        figure(91), hold on
        plot((1:length(sub))/afs,sub)
        plot((1:length(y))/(afs/dr),y,'LineWidth',2)
        reststore(n).soundo(:,1) = y;
        
        % also get spectral content
        [Pxx,Freq,bw,~,~,ct] = CleanSpectra_fun(s((exp(q(n),1))*afs:(exp(q(n),2))*afs),afs,breath.cue(q(n),:));
        [SL,F] = speclev(s,2048,afs);
        reststore(n).SL_o = SL;
        reststore(n).Pxxo = Pxx;
        reststore(n).cto = ct;
        
        reststore(n).sfillo = naninterp(reststore(n).soundo);                   % interpolate NaNs
        reststore(n).sfillo(find(reststore(n).sfillo<0)) = 0;                           % zero out any negative values at the beginning
        reststore(n).sfillo(find(reststore(n).sfillo>max(reststore(n).soundo))) = NaN;    % interpolation should never exceed max envelope
    end
end
for n = 1:length(reststore)
    reststore(n).Festi = ai*(reststore(n).sfilli).^bi; % do it on the filtered envelope with the bad bits removed
    reststore(n).VTesti = trapz(reststore(n).Festi)/(afs/dr); %newfs;
    if reststore(n).VTesti < 1
        reststore(n).VTesti = NaN;
    end
    %reststore(n).Festo = a*(reststore(n).sfillo).^b;
    %reststore(n).VTesto = trapz(reststore(n).Festo)/(afs/dr);
end

%figure(4)
%plot(extractfield(reststore,'E'),extractfield(reststore,'Festi'),'.')

figure(29)
plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'v')
%plot(breath.cue(q,1)/60,extractfield(reststore,'VTesto'),'^')

% save data
save([cd '\PneumoData\' filename '_surfstore'],'surfstore','reststore','ai','bi','-append')