% do flowsoundplot for syringe data
warning off 
% run 152b and 152z script first
AlignData_SyringeCal 

pneum = zeros(length(dist),1); pneum(pon) = 1; % pneumotach status
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\
%% 
for f = 1
filename = tags(f).name; 

%%
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

end 

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

