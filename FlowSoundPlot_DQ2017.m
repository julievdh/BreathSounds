% Align Data, get pneumo data
AlignData_DQ2017, warning off
% load PQ audit
load(strcat('C:/tag/tagdata/',tag,'_PQ'))
CUE_S = find(CUE); CUE_R = CUE(find(CUE));
[~,breath] = findaudit(R,'breath');
if exist([cd '\PneumoData\' filename '_flowsound.mat'],'file') == 2
    load([cd '\PneumoData\' filename '_flowsound.mat'])
else % preallocate
    allstore = struct('sound', cell(1, length(CUE_R)), 'flow', cell(1, length(CUE_R)));
    aligned = NaN(length(CUE_R),1);
end
return 

%%
for n = 1:length(CUE_R)
    %%
    if isnan(CUE_R(n)) == 0
        if Quality(CUE_R(n)) == 0       % only if Quality == 0
            [s,afs] = d3wavread([breath.cue(CUE_R(n),1)-0.4 breath.cue(CUE_R(n),1)+breath.cue(CUE_R(n),2)+0.6],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
            s1 = s(:,1)-mean(s(:,1)); % channel 1 minus DC offset
            s2 = s(:,2)-mean(s(:,2));
            [~,~,~,s1_a] = CleanSpectra_fun(s1,afs,[breath.cue(CUE_R(n),1)-0.4 breath.cue(CUE_R(n),2)+0.4+0.6]);
            [~,~,~,s2_a] = CleanSpectra_fun(s2,afs,[breath.cue(CUE_R(n),1)-0.4 breath.cue(CUE_R(n),2)+0.4+0.6]);
            s1_a(s1_a == 0) = NaN;  % clean signal based on kurtosis and NaN out zeros
            s2_a(s2_a == 0) = NaN;
            H1 = hilbenv(s1_a); % take hilbert
            H2 = hilbenv(s2_a);
            if exist('RAW_DATA','var')
                ffs = 1/diff(RAW_DATA(1:2,1)); % flow sampling rate
            else ffs = 1/diff(all_RAWDATA(1:2,1));
            end
            
            dr = round(afs/ffs); % decimation rate
            y = resample(H1,1,dr)-nanmean(H1(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
            y2 = resample(H2,1,dr)-nanmean(H2(1:12000));
            % remove mean of first 0.05 s to remove noise floor
            
            figure(90), clf, hold on
            [ax, h1, h2] = plotyy((1:length(y))/(afs/dr),[y y2],cuts(CUE_S(n)).flow(:,1)-cuts(CUE_S(n)).flow(1,1),cuts(CUE_S(n)).flow(:,2));
            set(h2,'Marker','o'), set(h1,'Marker','o') % ok they're at the same sampling frequency now
            
            if btype(CUE_R(n),1) == 1 
                % make one the same duration of the other
                mn = min([length(cuts(CUE_S(n)).flow) length(y)]);
                flow_short = cuts(CUE_S(n)).flow(1:mn,:); y = y(1:mn); y2 = y2(1:mn);
                
                % cross correlate
                xc = xcorr(y,flow_short(:,3),'coeff'); % cross-correlate
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
                [ax, h1, h2] = plotyy((1:length(shift_y)),[shift_y shift_y2],1:length(flow_short),flow_short(:,2));
                xlabel('Time (samples)')
                % title(strcat(regexprep(tag,'_',' '),' breath R',num2str(CUE_R(n)),'S',num2str(CUE_S(n))))
                % line(exp(CUE_R(n),:)-(iF-iE2)/fs,[9 9],'parent',ax(2)) % add the expiration duration
                % align plotyy axis
                maxval = cellfun(@(x) max(abs(x)), get([h1(1) h1(2) h2], 'YData'));
                maxval = [max(maxval(1:2)) maxval(3)]';
                minval = cellfun(@(x) min((x)), get([h1(1) h1(2) h2], 'YData')); minval(1) = minval(1)*5;
                minval = [max(minval(1:2)) minval(3)]';
                ylim = [minval*1.1, maxval * 1.1];  % Mult by 1.1 to pad out a bit
                
                set(ax(1), 'YLim', ylim(1,:) );
                set(ax(2), 'YLim', ylim(2,:) );
                
                % do they line up? aligned = 5 is a bad breath for any
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
                    [ax, h1, h2] = plotyy((1:length(shift_y)),[shift_y shift_y2],1:length(cuts(CUE_S(n)).flow(:,2)),cuts(CUE_S(n)).flow(:,2));
                    xlabel('Time (samples)')
                    aligned(n) = input('do they line up?  '); % how about now?
                end
                if aligned(n) == 1
                    % manually select exhale for now
                    temp = ginput(2);
                    strt = temp(1,1); ed = temp(2,1);
                    figure(4), hold on
                    %mn = min([length(cuts(CUE_S(n)).flow) length(shift_y)]);
                    plot(shift_y(strt:ed)-min(shift_y(strt:ed)),cuts(CUE_S(n)).flow(strt:ed,3),'o') % shifted, sub-section
                    xlabel('Filtered Sound Envelope '), ylabel('Flow (L/s)')
                    
                    
                    % fit relationship
                    %[ curve,goodness] = fit(shift_y(exh),cuts(CUE_S(n)).flow(exh,2),'a*log10(x)+b');curve
                    % coeffs(n,:) = coeffvalues(curve);
                    % Rsq(n) = goodness.rsquare;
                    allstore(n).sound(:,1) = shift_y(strt:ed)-min(shift_y(strt:ed))+1E-10;
                    allstore(n).sound2(:,1) = shift_y2(strt:ed)-min(shift_y2(strt:ed))+1E-10;
                    
                    allstore(n).flow = cuts(CUE_S(n)).flow(strt:ed,3);
                    allstore(n).idx = strt:ed;
                end
            end
            
            % also get spectral information for the exhale and inhale
            % you've already selected
            if isnan(exp(CUE_R(n))) == 0
                [Pxx_e,Freq,bw_e,s_e] = CleanSpectra_fun(s2((exp(CUE_R(n),1))*afs:(exp(CUE_R(n),2))*afs),afs,[breath.cue(CUE_R(n)) exp(CUE_R(n),2)-exp(CUE_R(n),1)]);
                [SL_e,F] = speclev(s_e,2048,afs);
                allstore(n).SL_e = SL_e;
                allstore(n).Pxx_e = Pxx_e;
            end
            if isnan(ins(CUE_R(n))) == 0
                [Pxx_i,Freq,bw_i,s_i] = CleanSpectra_fun(s2((ins(CUE_R(n),1))*afs:(ins(CUE_R(n),2))*afs),afs,[breath.cue(CUE_R(n)) ins(CUE_R(n),2)-ins(CUE_R(n),1)]);
                [SL_i,F] = speclev(s_i,2048,afs);
                allstore(n).SL_i = SL_i;
                allstore(n).Pxx_i = Pxx_i;
            end
            
            %% flow volume loop
            %         figure(6), clf, hold on
            %         plot(cumsum(shift_y)/sum(shift_y),shift_y/max(shift_y)) % normalized duration and magnitude
            %         plot(cumsum(flow_short(:,3))/sum(flow_short(:,3)),flow_short(:,3)/max(flow_short(:,3))) % normalized duration and magnitude
            %         title('Flow Volume Loop - Normalized dur and mag')
            
        end
    end
    clear s y y2 shift_y shift_y2 flow_short
end

%% save allstore
save([cd '\PneumoData\' filename '_flowsound'],'allstore','aligned','filename','cuts')

%% assess the relationship and fit and estimate
FlowSoundAssess

return

%% plot spectral information and flow rate
expFR = abs(all_SUMMARYDATA(CUE_S,4))';
insFR = all_SUMMARYDATA(CUE_S,3)';
figure(88), clf, hold on
for i = 1:length(allstore)
    if isempty(allstore(i).SL_e) == 0
        plot3(repmat(expFR(i),1,171),F(1:171),allstore(i).SL_e(1:171))
    end
end

figure(89), clf, hold on
for i = 1:length(allstore)
    if isempty(allstore(i).SL_i) == 0
        plot3(repmat(insFR(i),1,171),F(1:171),allstore(i).SL_i(1:171))
    end
end


%% apply to surface breaths
FlowSoundApply


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

