% do flowsoundplot for syringe data
warning off 
% initialize for 147z and then apply to other
f = 3;
tags(f).name = 'tt17_147z';

% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
for f = 3;
    tags(f).recdir = d3makefname(tags(f).name,'RECDIR');
    
    % load calibration and deployment info, tag audit
    tags(f).R = loadaudit(tags(f).name);
    [tags(f).CAL,tags(f).DEPLOY] = d3loadcal(tags(f).name);
    [tags(f).sin,~] = findaudit(tags(f).R,'sin'); % syringe in = inhale equivalent
    [tags(f).sout,~] = findaudit(tags(f).R,'sout'); % syringe out = exhale equivalent
end
tags(f).col = [0 0 1];

% some specifics for 147z
pon3 = [12:16 22:26 32:36 42:46 52:56 62:66 72:76] -1; % because removed first sin-sout to have even rows
poff3 = [2:11 17:21 27:31 37:41 47:51 57:61 67:71] -1; % because removed first sin-sout
dist3 = [repmat(10,1,15) repmat(12,1,10) repmat(14,1,10) repmat(16,1,10) ...
    repmat(18,1,10) repmat(20,1,10) repmat(22,1,10)];
pneum = zeros(length(dist3),1); pneum(pon3) = 1; % pneumotach status

% load respiration data .mat files
load([cd '\ChestBand\Trial55_May27-ECG-tag-sound-cal'])

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

filename = tags(f).name; 

f%%
if exist([cd '\PneumoData\' filename '_flowsound.mat'],'file') == 2
    load([cd '\PneumoData\' filename '_flowsound.mat'])
else % preallocate
    allstore = struct('sound', cell(1, length(tags(f).sin)), 'flow', cell(1, length(tags(f).sin)));
    aligned = NaN(length(tags(f).sin),1);
end

return 

%%
for n = 1:length(tags(f).sin)
    %%
    if pneum(n) == 1
        [s,afs] = d3wavread([tags(f).sin(n,1)-0.2 tags(f).sout(n,1)+tags(f).sout(n,2)+0.2],d3makefname(tags(f).name,'RECDIR'), [tags(f).name(1:2) tags(f).name(6:9)], 'wav' );
        s1 = s(:,1)-mean(s(:,1)); % channel 1 minus DC offset
        s2 = s(:,2)-mean(s(:,2));
        [~,~,~,s1_a] = CleanSpectra_fun(s1,afs,[tags(f).sin(n,1)-0.2 length(s1)/afs]);
        [~,~,~,s2_a] = CleanSpectra_fun(s2,afs,[tags(f).sin(n,1)-0.2 length(s2)/afs]);
        s1_a(s1_a == 0) = NaN;  % clean signal based on kurtosis and NaN out zeros
        s2_a(s2_a == 0) = NaN;
        H1 = hilbenv(s1_a); % take hilbert
        H2 = hilbenv(s2_a);
        ffs = tickrate(1); % flow sampling rate
        
        dr = round(afs/ffs); % decimation rate
        y = resample(H1,1,dr)-nanmean(H1(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
        y2 = resample(H2,1,dr)-nanmean(H2(1:12000));
        % remove mean of first 0.05 s to remove noise floor
        
        figure(90), clf, hold on
        [ax, h1, h2] = plotyy((1:length(y))/(afs/dr),[y y2],(1:length(cuts(n).flow))/tickrate(1),cuts(n).flow);
        set(h2,'Marker','o'), set(h1,'Marker','o') % ok they're at the same sampling frequency now
        
        
        % make one the same duration of the other
        mn = min([length(cuts(n).flow) length(y)]);
        flow_short = cuts(n).flow(1:mn); y = y(1:mn); y2 = y2(1:mn);
        
        % cross correlate
        xc = xcorr(y,flow_short,'coeff'); % cross-correlate
        [~,lag] = max(xc);
        ac = xcorr(y,'coeff'); % auto-correlate
        [~,reflag] = max(ac);
        
        % pad with zeros at beginning
        if reflag-lag >= 1
            shift_y((reflag-lag)+(1:length(y))) = y; shift_y = shift_y';
            shift_y2((reflag-lag)+(1:length(y2))) = y2; shift_y2 = shift_y2';
        end
        if reflag-lag < 1
            shift_y = y(abs(reflag-lag)+1:end);
            shift_y2 = y2(abs(reflag-lag)+1:end);
        end
        
        figure(100),
        [ax, h1, h2] = plotyy((1:length(shift_y)),[shift_y shift_y2],1:length(flow_short),flow_short);
        xlabel('Time (samples)')
        % title(strcat(regexprep(tag,'_',' '),' breath R',num2str(CUE_R(n)),'S',num2str(n)))
        % line(exp(CUE_R(n),:)-(iF-iE2)/fs,[9 9],'parent',ax(2)) % add the expiration duration
        % align plotyy axis
        maxval = cellfun(@(x) max(abs(x)), get([h1(1) h1(2) h2], 'YData'));
        maxval = [max(maxval(1:2)) maxval(3)]';
        minval = cellfun(@(x) min((x)), get([h1(1) h1(2) h2], 'YData')); minval(1) = minval(1)*5;
        minval = [max(minval(1:2)) minval(3)]';
        ylim = [minval*1.1, maxval * 1.1];  % Mult by 1.1 to pad out a bit
        % ylim = [[0 0]', maxval] * 1.1;  % Mult by 1.1 to pad out a bit
        set(ax(1), 'YLim', ylim(1,:) );
        set(ax(2), 'YLim', ylim(2,:) );
        
        %% do they line up? aligned = 5 is a bad breath for any
        % relationship
        aligned(n) = input('do they line up?  ');
        while aligned(n) == 0 % if not aligned, then align them
            disp('select sound then flow')
            temp = ginput(2);
            offset = round(temp(2,1) - temp(1,1));
            if offset > 0
                shift_y(offset+(1:length(shift_y)),1) = shift_y;
                shift_y(1:offset,1) = NaN;
                shift_y2(offset+(1:length(shift_y2)),1) = shift_y2;
                shift_y2(1:offset,1) = NaN;
                
            end, if offset < 0
                shift_y(1:length(shift_y)-abs(offset)) = shift_y(abs(offset)+1:end);
                shift_y2(1:length(shift_y2)-abs(offset)) = shift_y2(abs(offset)+1:end);
            end
            [ax, h1, h2] = plotyy((1:length(shift_y)),[shift_y shift_y2],1:length(cuts(n).flow),cuts(n).flow);
            xlabel('Time (samples)')
            aligned(n) = input('do they line up?  '); % how about now?
        end
        if aligned(n) == 1
            % manually select syringe inhale
            temp = ginput(2);
            strt = temp(1,1); ed = temp(2,1);
            
            figure(4), hold on
            plot(shift_y(strt:ed)-min(shift_y(strt:ed)),cuts(n).flow(strt:ed),'o') % shifted, sub-section
            xlabel('Filtered Sound Envelope '), ylabel('Flow (L/s)')
            
            allstore(n).soundi(:,1) = shift_y(strt:ed)-min(shift_y(strt:ed))+1E-10;
            allstore(n).sound2i(:,1) = shift_y2(strt:ed)-min(shift_y2(strt:ed))+1E-10;
            
            allstore(n).flowi = cuts(n).flow(strt:ed);
            allstore(n).idxi = strt:ed;
            
            % syringe out
            figure(100)
            temp = ginput(2);
            strt = temp(1,1); ed = temp(2,1);
            
            figure(4), hold on
            plot(shift_y(strt:ed)-min(shift_y(strt:ed)),cuts(n).flow(strt:ed),'o') % shifted, sub-section
            
            allstore(n).soundo(:,1) = shift_y(strt:ed)-min(shift_y(strt:ed))+1E-10;
            allstore(n).sound2o(:,1) = shift_y2(strt:ed)-min(shift_y2(strt:ed))+1E-10;
            
            allstore(n).flowo = cuts(n).flow(strt:ed);
            allstore(n).idxo = strt:ed;
            
        end
        %%
    end
    clear s y y2 shift_y shift_y2 flow_short
end

%% save allstore
save([cd '\PneumoData\' filename '_flowsound'],'allstore','aligned','filename','cuts')

return 
%%
%FlowSoundAssess_Syringe
%% apply to surface breaths
%FlowSoundApply_Syringe


return

%% fit gaussian here on stored data? Dont think this will work...
for n = 1:length(aligned)
    if aligned(n) == 1
        x = 1:length(allstore(n).sound); y = allstore(n).sound;
        f = fit(x',y,'gauss2');
        figure(5)
        plot(f,x,y)
        pause
    end
end

