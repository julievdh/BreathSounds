% Calculate oxygen consumption of single breath
% Find breath-by-breath O2 consumption for breaths with recorded sounds

% 8 Sept 2014




A = exist('DQ')
if A == 1
RAWDATA = vertcat(pre_RAWDATA,post_RAWDATA);
SUMMARYDATA = vertcat(pre_SUMMARYDATA,post_SUMMARYDATA);
    
end

    
% plot cumulative oxygen and flow rate
figure(1); clf
plot(RAWDATA(:,1),RAWDATA(:,8),'LineWidth',2); hold on
plot(RAWDATA(:,1),RAWDATA(:,2),'k','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

title(regexprep(filename,'_',' '))
xlabel('Time (s)')
adjustfigurefont

%% Find indices of each breath and calculate L02 per breath
% determine breaths where have CUE and PNEUMO
% find peaks in flow rate signal
[pks,locs] = findpeaks(RAWDATA(:,2),'minpeakheight',1,'minpeakdistance',300);

% check to see if detected peaks are same length as summary data
disp('Did we find the same peaks?')
disp(isequal(length(pks),length(SUMMARYDATA)))

% plot detected peaks
plot(RAWDATA(locs,1),pks,'ko')

%% Calculate oxygen consumption: difference in cumulative O2 just before 
% peak and just after peak

% plot cumO2 at location of peaks
plot(RAWDATA(locs,1),RAWDATA(locs,8),'g.')

% plot cumO2 at peaks - 1 s (= 200 samples) and peaks + 1 s
plot(RAWDATA(locs-200,1),RAWDATA(locs-200,8),'mo')
plot(RAWDATA(locs+200,1),RAWDATA(locs+200,8),'mo')

% calculate difference between these
LO2 = RAWDATA(locs+200,8) - RAWDATA(locs-200,8);

% plot LO2 over time
figure(4)
plot(RAWDATA(locs,1),LO2,'r*')
xlabel('Time (s)'); ylabel('L O_2 Consumed')
adjustfigurefont


A = exist('DQ');
if A == 1
    disp('DQ!')
end

%% EXTRACT THOSE FOR MATCHED BREATHS
CUE_S = find(CUE);
CUE_R = CUE(find(CUE));

matchedLO2 = LO2(CUE_S);
% matchedLO2min = LO2min(CUE_S);

% save these to master data table for matched breaths to be used for PCA