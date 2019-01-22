% Align Data, get pneumo data
% AlignData
clear, close all; warning off 
load('SarasotaFiles'), f = 10; tag = Sarasota{f,1};
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
filename = strcat(Sarasota{f,2},'_resp');
load([cd '\PneumoData\' filename])
% load PQ audit
load(strcat('C:\Users\au575532\Dropbox (Personal)\tag\tagdata\',tag,'_PQ'))
CUE_S = find(CUE); CUE_R = CUE(find(CUE)); CH = 2; 
tag = Sarasota{f,1}; R = loadaudit(tag); 
[~,breath] = findbreathcues(R);
if f == 10 % remove duplicates of breath cues
   removeDupes
end
PneumCueTimeline
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
            % and only the good E/I portions go in?
            [s,sfilt,afs,tcue,tdur] = BreathFilt(n,breath,recdir,tag,1); % using RESP not R 
            [~,~,~,s_a] = CleanSpectra_fun(sfilt,afs,[tcue-0.4 tdur+0.4+0.6]);
            % s_a(s_a == 0) = NaN;        % clean signal based on kurtosis and NaN out zeros
            H = hilbenv(s_a); % take hilbert
            H(H == 0) = NaN; % set NaNs here now
            if exist('RAW_DATA','var')
                ffs = 1/diff(RAW_DATA(1:2,1)); % flow sampling rate
            else ffs = 1/diff(RAWDATA(1:2,1));
            end
            
            dr = round(afs/ffs); % decimation rate
            y = resample(H,1,dr)-nanmean(H(1:12000)); % resample hilbert envelope of sound to be same sampling frequency as pneumotach
            % remove mean of first 0.05 s to remove noise floor
            
            figure(90), clf, hold on
            [ax, h1, h2] = plotyy((1:length(y))/(afs/dr),y,cuts(CUE_S(n)).flow(:,1)-cuts(CUE_S(n)).flow(1,1),cuts(CUE_S(n)).flow(:,2));
            %set(h2,'Marker','o'), set(h1,'Marker','o') % ok they're at the same sampling frequency now
            
            if btype(CUE_R(n),1) == 1 % get exhalation only
                % make one the same duration of the other
                %mn = min([length(cuts(CUE_S(n)).flow) length(y)]);
                %flow_short = cuts(CUE_S(n)).flow(1:mn,:); y = y(1:mn);
                
                % cross correlate
                %xc = xcorr(y,flow_short(:,2),'coeff'); % cross-correlate
                %[~,lag] = max(xc);
                %ac = xcorr(y,'coeff'); % auto-correlate
                %[~,reflag] = max(ac);
                
                % pad with zeros at beginning
                %if reflag-lag >= 1
                %    shift_y((reflag-lag)+(1:length(y))) = y;
                %end
                %if reflag-lag < 1
                %    shift_y = y(abs(reflag-lag)+1:end);
                %end
                shift_y = y;
                
                figure(100),
                [ax, h1, h2] = plotyy((1:length(shift_y)),shift_y,1:length(cuts(CUE_S(n)).flow(:,2)),cuts(CUE_S(n)).flow(:,2));
                xlabel('Time (samples)')
                % title(strcat(regexprep(tag,'_',' '),' breath R',num2str(CUE_R(n)),'S',num2str(CUE_S(n))))
                % line(exp(CUE_R(n),:)-(iF-iE2)/fs,[9 9],'parent',ax(2)) % add the expiration duration
                % align plotyy axis
                maxval = cellfun(@(x) max(abs(x)), get([h1 h2], 'YData'));
                minval = cellfun(@(x) min((x)), get([h1 h2], 'YData')); minval(1) = minval(1)*5;
                ylim = [minval*1.1, maxval * 1.1];  % Mult by 1.1 to pad out a bit
                % ylim = [[0 0]', maxval] * 1.1;  % Mult by 1.1 to pad out a bit
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
                    end, if offset < 0
                        shift_y(1:length(shift_y)-abs(offset)) = shift_y(abs(offset)+1:end);
                    end
                    [ax, h1, h2] = plotyy((1:length(shift_y)),shift_y,1:length(cuts(CUE_S(n)).flow(:,2)),cuts(CUE_S(n)).flow(:,2));
                    xlabel('Time (samples)')
                    aligned(n) = input('do they line up?  '); % how about now?
                end
                if aligned(n) == 1
                    % manually select exhale for now
                    temp = ginput(2);
                    strt = temp(1,1); ed = temp(2,1);
                    figure(4), hold on
                    %mn = min([length(cuts(CUE_S(n)).flow) length(shift_y)]);
                    plot(shift_y(strt:ed)-min(shift_y(strt:ed)),cuts(CUE_S(n)).flow(strt:ed,2),'o') % shifted, sub-section
                    xlabel('Filtered Sound Envelope '), ylabel('Flow (L/s)')
                    
                    
                    % fit relationship
                    %[ curve,goodness] = fit(shift_y(exh),cuts(CUE_S(n)).flow(exh,2),'a*log10(x)+b');curve
                    % coeffs(n,:) = coeffvalues(curve);
                    % Rsq(n) = goodness.rsquare;
                    figure(100)
                    disp('select exhale')
                    temp = ginput(2);
                    strt = temp(1,1); ed = temp(2,1);
                    
                    allstore(n).sounde(:,1) = shift_y(strt:ed)-min(shift_y(strt:ed))+1E-10;
                    allstore(n).flowe = cuts(CUE_S(n)).flow(strt:ed,2);
                    allstore(n).idxe = strt:ed; 
                    
                    disp('select inhale')
                    temp = ginput(2);
                    strt = temp(1,1); ed = temp(2,1);
                    
                    allstore(n).soundi(:,1) = shift_y(strt:ed)-min(shift_y(strt:ed))+1E-10;
                    allstore(n).flowi = cuts(CUE_S(n)).flow(strt:ed,2);
                    allstore(n).idxi = strt:ed; 
                end
            end
            
            % also get spectral information for the exhale and inhale
            % you've already selected
            if isnan(exp(CUE_R(n))) == 0
                [Pxx_e,Freq,bw_e,s_e] = CleanSpectra_fun(s((exp(CUE_R(n),1))*afs:(exp(CUE_R(n),2))*afs),afs,[breath.cue(CUE_R(n)) exp(CUE_R(n),2)-exp(CUE_R(n),1)]);
                [SL_e,F] = speclev(s_e,2048,afs);
                allstore(n).SL_e = SL_e;
                allstore(n).Pxx_e = Pxx_e;
            end
            if isnan(ins(CUE_R(n))) == 0
                [Pxx_i,Freq,bw_i,s_i] = CleanSpectra_fun(s((ins(CUE_R(n),1))*afs:(ins(CUE_R(n),2))*afs),afs,[breath.cue(CUE_R(n)) ins(CUE_R(n),2)-ins(CUE_R(n),1)]);
                [SL_i,F] = speclev(s_i,2048,afs);
                allstore(n).SL_i = SL_i;
                allstore(n).Pxx_i = Pxx_i;
            end
            
            %% flow volume loop
            %         figure(6), clf, hold on
            %         plot(cumsum(shift_y)/sum(shift_y),shift_y/max(shift_y)) % normalized duration and magnitude
            %         plot(cumsum(flow_short(:,2))/sum(flow_short(:,2)),flow_short(:,2)/max(flow_short(:,2))) % normalized duration and magnitude
            %         title('Flow Volume Loop - Normalized dur and mag')
            
        end
    end
    clear s y shift_y flow_short
end

%% save allstore
save([cd '\PneumoData\' filename '_flowsound'],'afs','allstore','aligned','filename','cuts','-append')

%% assess
FlowSoundAssess

return 

%% use relationship on sounds
% fit to everything:
exhflow = find(extractfield(allstore,'flow') > 1);
allflow = extractfield(allstore,'flow')';
allsound = extractfield(allstore,'sound')';
[curve,goodness] = fit(allsound(exhflow),allflow(exhflow),'a*log10(x)+b');
all_coeff = coeffvalues(curve);VfTe = abs(all_SUMMARYDATA(CUE_S,5))';

a = all_coeff(1); b = all_coeff(2);
% for first four inhales:
inhflow = find(allflow < -1);
[curvei,gofi] = fit(allsound(inhflow),-allflow(inhflow),'a*log10(x)+b');
all_coeffi = coeffvalues(curvei); % for inhales
ai = all_coeffi(1); bi = all_coeffi(2);

% Fest = a*log10(shift_y)+b;
% figure(9), hold on
% plot((1:length(shift_y))/(afs/1200),Fest,'o')
% plot(cuts(CUE_S(n)).flow(:,1)-cuts(CUE_S(n)).flow(1,1),cuts(CUE_S(n)).flow(:,2))
% plot(cuts(CUE_S(n)).flow(exh,1)-cuts(CUE_S(n)).flow(1,1),cuts(CUE_S(n)).flow(exh,2))
% plot(exh/(afs/1200),Fest(exh),'o')
% error = mean((cuts(CUE_S(n)).flow(exh,2) - Fest(exh))./cuts(CUE_S(n)).flow(exh,2));

for n = 1:length(aligned)
    if aligned(n) == 1,
        if size(allstore(n).sound,2) > 1
            allstore(n).sound = allstore(n).sound';
        end
        % apply that relationship
        allstore(n).Fest = a*log10(allstore(n).sound)+b;
        ex = find(allstore(n).flow > 0);
        in = find(allstore(n).flow < 0);
        allstore(n).error = (mean(allstore(n).flow(ex))-mean(allstore(n).Fest(ex)))/mean(allstore(n).flow(ex));
        allstore(n).Festi = ai*log10(allstore(n).sound)+bi;
        allstore(n).errori = (mean(allstore(n).flow(in))-mean(-allstore(n).Festi(in)))/mean(allstore(n).flow(in));
        % estimate exh tidal volume from flow
        VTest(n) = trapz(allstore(n).Fest(ex))/(afs/1200);
        VTesti(n) = trapz(allstore(n).Festi(in))/(afs/1200); 
        figure(19), hold on
        plot(allstore(n).flow)
        plot(ex,allstore(n).Fest(ex),'.')
        plot(in,-allstore(n).Festi(in),'.')
        pause
    end
end
figure(29), hold on
plot(VTest,VTe,'^')
plot(VTesti,VTe,'v')
plot([0 20],[0 20])
% how much are the tidal volumes off? 
nanmean(mean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
[min(mean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
max(mean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))]
return 

%% apply to those that were not aligned



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

