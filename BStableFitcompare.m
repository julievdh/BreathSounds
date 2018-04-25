% make table of all breaths, pneum breaths, good sound, compare fits
% between files'

% make a list of all the files
load('DQFiles2017')

% set a counter
ct = 1;
close all

for f = [9 28 10:25 27]
    filename = strcat(DQ2017{f,2},'_resp');
    load([cd '\PneumoData\' filename '_flowsound.mat'])
    load([cd '\PneumoData\' filename])
    tag = DQ2017{f,1};
    load(strcat('C:/tag/tagdata/',tag,'_PQ'))
    CUE_S = find(CUE); CUE_R = CUE(find(CUE));
    R = loadaudit(tag);
    [~,breath] = findaudit(R,'breath');
    
    % make a table
    T(ct).f = f;
    T(ct).nbreaths = size(breath.cue,1); % breaths total
    T(ct).npon = length(all_SUMMARYDATA); % pneumotach breaths
    % T(ct).ngpon = sum(~isnan(CUE_R)); % good pneumotach breaths with paired sound
    T(ct).ngpoff = length(find(~ismember(1:size(breath.cue),CUE))); % size(find(Quality == 0),1) + size(find(Quality == 20),1) - sum(~isnan(CUE_R)); % good sound without pneumotach
    T(ct).ngpone = sum(~isnan(VTest(1,:)));
    T(ct).ngponi = sum(~isnan(VTesti(1,:)));
    gidx = find(arrayfun(@(allstore) ~isempty(allstore.erroro),allstore));
    T(ct).errorofit = nanmean(abs([allstore(gidx(1:5)).erroro]));
    T(ct).errorifit = nanmean(abs([allstore(gidx(1:5)).errori]));
    
    T(ct).erroro_othr = nanmean(abs([allstore(gidx(6:end)).erroro]));
    T(ct).errori_othr = nanmean(abs([allstore(gidx(6:end)).errori]));
    T(ct).VTerre_fit = nanmean(abs(VTerre(1,gidx(1:5))));
    T(ct).VTerri_fit = nanmean(abs(VTerri(1,gidx(1:5))));
    T(ct).VTerre_othr = nanmean(abs(VTerre(1,gidx(6:end))));
    T(ct).VTerri_othr = nanmean(abs(VTerri(1,gidx(6:end))));
    
    T(ct).filename = filename; % pneumotach file name
    T(ct).dep = tag; % tag deployment name
    [T(ct).animal T(ct).col] = assignDQname(filename);
    T(ct).dist = DQ2017{f,3}; % distance to blowhole
    T(ct).tag = DQ2017{f,4}; % tag (hardware)
    if T(ct).tag == 401
        T(ct).mkr = 'd';
    else if T(ct).tag == 421
            T(ct).mkr = 's';
        else if T(ct).tag == 119
                T(ct).mkr = 'o';
            end
        end
    end
    
    if exist('fitinfo','var')
        %% compare fits
        figure(12), ax1 = subplot(411); hold on
        h = plot(ct,fitinfo.ai,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col);
        
        ax2 = subplot(412); hold on
        plot(ct,fitinfo.bi,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
        
        ax3 = subplot(413); hold on
        plot(ct,fitinfo.a,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
        
        ax4 = subplot(414); hold on
        plot(ct,fitinfo.b,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
        
    end
    
    % parameters versus distance
    figure(13),
    subplot(221), hold on
    plot(T(ct).dist,fitinfo.ai,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
    subplot(222), hold on
    plot(T(ct).dist,fitinfo.bi,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
    subplot(223), hold on
    plot(T(ct).dist,fitinfo.a,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
    subplot(224), hold on
    plot(T(ct).dist,fitinfo.b,'ko','marker',T(ct).mkr,'markerfacecolor',T(ct).col)
    
    
    ct = ct+1;
    clear fitinfo
end

% add labels
subplot(221), title('a'), ylabel('Inhale')
subplot(222), title('b')
subplot(223), ylabel('Exhale'), xlabel('Distance blowhole to tag (cm)')
subplot(224), xlabel('Distance blowhole to tag (cm)')


%% and for DQ 2013
% make a list of all the files
load('DQFiles')

for f = 1:17
    filename = strcat(DQ{f,2},'_resp');
    load([cd '\PneumoData\' filename '_flowsound.mat'])
    % load([cd '\PneumoData\' filename '_surfstore.mat'])
    load([cd '\PneumoData\' filename])
    
    tag = DQ{f,1};
    load(strcat('C:/tag/tagdata/',tag,'_PQ'))
    CUE_S = find(CUE); CUE_R = CUE(find(CUE));
    R = loadaudit(tag);
    [~,breath] = findaudit(R,'breath');
    
    % make a table
    T(ct).f = f;
    T(ct).nbreaths = size(breath.cue,1); % breaths total
    T(ct).npon = length(pre_SUMMARYDATA)+length(post_SUMMARYDATA); % pneumotach breaths
    % T(ct).ngpon = sum(~isnan(CUE_R)); % good pneumotach breaths with paired sound
    T(ct).ngpone = sum(~isnan(VTest(1,:)));
    T(ct).ngponi = sum(~isnan(VTesti(1,:)));
    
    gidx = find(arrayfun(@(allstore) ~isempty(allstore.erroro),allstore));
    T(ct).errorofit = nanmean([allstore(gidx(1:5)).erroro]);
    T(ct).errorifit = nanmean([allstore(gidx(1:5)).errori]);
    
    T(ct).erroro_othr = nanmean([allstore(gidx(6:end)).erroro]);
    T(ct).errori_othr = nanmean([allstore(gidx(6:end)).errori]);
    
    T(ct).VTerre_fit = nanmean(VTerre(1,gidx(1:5)));
    T(ct).VTerri_fit = nanmean(VTerri(1,gidx(1:5)));
    T(ct).VTerre_othr = nanmean(VTerre(1,gidx(6:end)));
    T(ct).VTerri_othr = nanmean(VTerri(1,gidx(6:end)));
    
    
    T(ct).ngpoff = length(find(~ismember(1:size(breath.cue),CUE))); % size(find(Quality == 0),1) + size(find(Quality == 20),1) - sum(~isnan(CUE_R)); % good sound without pneumotach
    T(ct).filename = filename;
    T(ct).dep = tag;
    [T(ct).animal T(ct).col] = assignDQname(filename);
    T(ct).tag = 401; % tag (hardware)
    
    if exist('fitinfo','var')
        %% compare fits
        figure(12), subplot(411), hold on
        plot(ct,fitinfo.ai,'kd','markerfacecolor',T(ct).col)
        
        subplot(412), hold on
        plot(ct,fitinfo.bi,'kd','markerfacecolor',T(ct).col)
        
        subplot(413), hold on
        plot(ct,fitinfo.a,'kd','markerfacecolor',T(ct).col)
        
        subplot(414), hold on
        plot(ct,fitinfo.b,'kd','markerfacecolor',T(ct).col)
        
    end
    
    ct = ct+1;
    clear fitinfo
end

% add labels etc
xlabel('File number')
subplot(411), title('inhale a')
subplot(412), title('inhale b')
subplot(413), title('exhale a')
subplot(414), title('exhale b')

set([ax1 ax2 ax3 ax4],'xlim',[0 ct+1])
set([ax2 ax4],'ylim',[-0.01 1])

%% tally who
keep T ct
animal = [T(:).animal];
n = hist(animal,1:max(unique(animal))); % how many animals performed trials
n17 = hist(animal(1:19),1:max(unique(animal))); % in 2017
n13 = hist(animal(20:36),1:max(unique(animal))); % in 2013


%% load Sarasota animal too
load('SarasotaFiles'), f = 12; tag = Sarasota{f,1};
filename = strcat(Sarasota{f,2},'_resp');
load([cd '\PneumoData\' filename])
load([cd '\PneumoData\' filename '_flowsound'])
load(strcat('C:/tag/tagdata/',tag,'_PQ'))
CUE_S = find(CUE); CUE_R = CUE(find(CUE));
R = loadaudit(tag);
[~,breath] = findbreathcues(R);

% make a table
T(ct).f = f;
T(ct).nbreaths = size(breath.cue,1); % breaths total
T(ct).npon = length(SUMMARYDATA); % pneumotach breaths
% T(ct).ngpon = sum(~isnan(CUE_R)); % good pneumotach breaths with paired sound
T(ct).ngpone = sum(~isnan(VTest(1,:)));
T(ct).ngponi = sum(~isnan(VTesti(1,:)));

gidx = find(arrayfun(@(allstore) ~isempty(allstore.erroro),allstore));
T(ct).errorofit = nanmean([allstore(gidx(1:5)).erroro]);
T(ct).errorifit = nanmean([allstore(gidx(1:5)).errori]);

T(ct).erroro_othr = nanmean([allstore(gidx(6:end)).erroro]);
T(ct).errori_othr = nanmean([allstore(gidx(6:end)).errori]);

T(ct).VTerre_fit = nanmean(VTerre(1,gidx(1:5)));
T(ct).VTerri_fit = nanmean(VTerri(1,gidx(1:5)));
T(ct).VTerre_othr = nanmean(VTerre(1,gidx(6:end)));
T(ct).VTerri_othr = nanmean(VTerri(1,gidx(6:end)));

T(ct).ngpoff = length(find(~ismember(1:size(breath.cue),CUE))); % size(find(Quality == 0),1) + size(find(Quality == 20),1) - sum(~isnan(CUE_R)); % good sound without pneumotach
T(ct).filename = filename;
T(ct).dep = tag;
T(ct).animal = 'FB142';
T(ct).col = [77 175 74]/255;
T(ct).tag = 108; % tag (hardware)

if exist('fitinfo','var')
    %% compare fits
    figure(12), subplot(411), hold on
    plot(ct,fitinfo.ai,'k>','markerfacecolor',T(ct).col)
    
    subplot(412), hold on
    plot(ct,fitinfo.bi,'k>','markerfacecolor',T(ct).col)
    
    subplot(413), hold on
    plot(ct,fitinfo.a,'k>','markerfacecolor',T(ct).col)
    
    subplot(414), hold on
    plot(ct,fitinfo.b,'k>','markerfacecolor',T(ct).col)
    
end

ct = ct+1;
clear fitinfo

%% plot mean absolute error with distance to see
figure
hold on 
plot([T(1:19).VTerre_othr],[T(:).dist],'^')
plot([T(1:19).VTerri_othr],[T(:).dist],'v')
xlabel('Mean Absolute VT Error (L)'), ylabel('Distance (cm)')
figure
hold on
plot([T(1:19).erroro_othr],[T(:).dist],'^')
plot([T(1:19).errori_othr],[T(:).dist],'v')
xlabel('Mean Absolute Flow Rate Error (L/s)'), ylabel('Distance (cm)')


return
%% do some counts, minus sarasota animal - numbers for paper
% sum([T(1:36).ngponi])
[mean([T(1:36).errorofit]) std([T(1:36).errorofit])]
[mean([T(1:36).errorifit]) std([T(1:36).errorifit])]
[mean([T(1:36).VTerre_fit]) std([T(1:36).VTerre_fit])]
[mean([T(1:36).VTerri_fit]) std([T(1:36).VTerri_fit])]

[mean([T(1:36).erroro_othr]) std([T(1:36).erroro_othr])]
[mean([T(1:36).errori_othr]) std([T(1:36).errori_othr])]
[nanmean([T(1:36).VTerre_othr]) nanstd([T(1:36).VTerre_othr])]
[nanmean([T(1:36).VTerri_othr]) nanstd([T(1:36).VTerri_othr])]
