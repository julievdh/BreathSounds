% tt134a freeswim breaths

% tag = 'tt15_134a';
load('SarasotaFiles')
f = 12;
tag = Sarasota{f,1};
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag); 
load(['C:/tag/tagdata/' tag '_PQ.mat']) 
filename = strcat(Sarasota{f,2},'_resp');
load([cd '\PneumoData\' filename])


loadprh(tag,'p','fs')
[~,breath] = findbreathcues(R);
release = findaudit(R,'release'); 
pneum = findaudit(R,'pneumotach'); 

figure(2), clf, hold on
plot((1:length(p))/fs,-p)
plot(breath.cue(:,1),zeros(length(breath.cue),1),'r*') % plot any audited cues
% plot([pneum(1) pneum(1)],[-0.5 0.5],'g'), plot([pneum(2,1) pneum(2,1)],[-0.5 0.5],'g')
plot([release(1) release(1)],[-1 1],'k'),

%% how long is deployment?
dur = breath.cue(end,1)/3600;

if isempty(pneum) == 0
% how many breaths with pneumotach?
pneum_count = sum(iswithin(breath.cue(:,1),pneum(:,1)'));
% how many breaths without pneumotach before release?
pneum_off = sum(iswithin(breath.cue(:,1),[pneum(2,1) release(1)]));
else 
    pneum_count = length(CUE);
    pneum_off = size(find(breath.cue(:,1) < release(1)),1)-pneum_count;
end

% how many breaths after release?
free_dur = dur - release(1)/3600; % duration of free-swim
free_count = sum(breath.cue(:,1) > release(1));

%% load pneumotach data 
%cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData
%num = xlsread([cd '\test 11.xlsx']);
%eVT = num(:,22); iVT = num(:,23); % comment time is column 3
eVT = SUMMARYDATA(:,5); 

% how much does VT vary at rest? 
figure(4), clf, hold on
%h = scatterhist(abs(eVT),iVT);
%hold on;
%clr = get(h(1),'colororder');
%boxplot(h(2),abs(eVT),'orientation','horizontal',...
%     'label',{''},'color',clr);
%boxplot(h(3),iVT,'orientation','horizontal',...
%     'label', {''},'color',clr);
%set(h(2:3),'XTickLabel','');
%view(h(3),[270,90]);  % Rotate the Y plot
%axis(h(1),'auto');  % Sync axes
%hold off;
%h(1).XLabel.String = 'Exhaled VT (L)';
%h(1).YLabel.String = 'Inhaled VT (L)';
% [mean(iVT) std(iVT)]
[mean(eVT) std(eVT)]; 
subplot(311), hold on
for i = 1:length(CUE)
    if ~isnan(CUE(i)) == 1
plot(breath.cue(CUE(i),1),eVT(i),'ko')
plot(breath.cue(CUE(i),1),SUMMARYDATA(i,3),'rv') % max inhaled flow
plot(breath.cue(CUE(i),1),SUMMARYDATA(i,4),'b^') % max exhaled flow
    end
end

%% do breath routine 

%% plot eParams, iParams, etc 
dn = length(eParams.dur); % the end of the breaths that have been 2* audited so far
subplot(312), hold on
plot(breath.cue(1:dn,1),extractfield(iParams,'dur'),'o')
plot(breath.cue(1:dn,1),extractfield(eParams,'dur'),'o')
subplot(313), hold on
plot(breath.cue(1:dn,1),extractfield(iParams,'EFD'),'o')
plot(breath.cue(1:dn,1),extractfield(eParams,'EFD'),'o')
plot(breath.cue(1:dn,1),extractfield(iParams,'RMS'),'o')

plot([release(1) release(1)],[-0.5E2 0.5E2],'k')

%% count Quality, etc
Qtb = table(length(find(Quality == 1)),length(find(Quality == 0)),length(find(Quality == 20)),length(find(Quality == 22)),...
    'VariableNames',{'Talking';'Good';'Hsplash';'Fsplash'});
% how much does duratoin vary
% under the pneumotach 
nanmean(eParams.dur(~isnan(CUE)))
nanmean(iParams.dur(~isnan(CUE))) 
swm = find(breath.cue(:,1) > round(release(1)),1,'first'); 
off = CUE(end)+1 : swm-1;

nanmean(eParams.dur(off)) 
nanmean(iParams.dur(off))

nanmean(eParams.dur(swm))
nanmean(iParams.dur(swm))

figure, hold on, title('Inhalation Duration')
histogram(iParams.dur(~isnan(CUE)),'binwidth',0.01)
histogram(iParams.dur(off),'binwidth',0.01)
histogram(iParams.dur(swm:dn),'binwidth',0.01)
