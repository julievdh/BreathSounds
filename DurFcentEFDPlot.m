% Individual Variability Figure

% load data
load('AllBreaths_noPEAK')

DQO = find(BREATHONLY(:,15) == 1);
SARASOTA = find(BREATHONLY(:,15) == 2);

animal = BREATHONLY(DQO,11);
condition = BREATHONLY(DQO,12);

varnames = {'Individual';'Condition'};
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'};

% get new data (population marginal means)
[p,table,stats] = anovan(BREATHONLY(DQO,1),{animal condition},2,2,varnames);
[c,DQ_Dur,h,nms] = multcompare(stats);

[p,table,stats] = anovan(BREATHONLY(DQO,2),{animal condition},2,2,varnames);
[c,DQ_EFD,h,nms] = multcompare(stats);

[p,table,stats] = anovan(BREATHONLY(DQO,5),{animal condition},2,2,varnames);
[c,DQ_Fcent,h,nms] = multcompare(stats);



% select only deck and water
% ii = find(BREATHONLY(SARASOTA,12) ~= 5);
condition = BREATHONLY(SARASOTA,12);
animal = BREATHONLY(SARASOTA,11);

[p,table,stats] = anovan(BREATHONLY(SARASOTA,1),{animal condition},'varnames',varnames);
[c,SAR_Dur,h,nms] = multcompare(stats);

[p,table,stats] = anovan(BREATHONLY(SARASOTA,2),{animal condition},'varnames',varnames);
[c,SAR_EFD,h,nms] = multcompare(stats);

[p,table,stats] = anovan(BREATHONLY(SARASOTA,5),{animal condition},'varnames',varnames);
[c,SAR_Fcent,h,nms] = multcompare(stats);

%% Build figure



figure(10); clf; hold on
%subplot(121); hold on
errorbar(DQ_Dur(:,1),DQ_Fcent(:,1),DQ_Fcent(:,2),'.')
herrorbar(DQ_Dur(:,1),DQ_Fcent(:,1),DQ_Dur(:,2),'.')

%subplot(122); hold on
errorbar(SAR_Dur(:,1),SAR_Fcent(:,1),SAR_Fcent(:,2),'r.')
herrorbar(SAR_Dur(:,1),SAR_Fcent(:,1),SAR_Dur(:,2),'r.')
errorbar(SAR_Dur(7:8,1),SAR_Fcent(7:8,1),SAR_Fcent(7:8,2),'g.')
herrorbar(SAR_Dur(7:8,1),SAR_Fcent(7:8,1),SAR_Dur(7:8,2),'g.')
xlabel('95% Energy Duration (s)'); ylabel('Centroid Frequency (Hz)')
adjustfigurefont
box on

figure(11); clf; hold on
errorbar(DQ_EFD(:,1),DQ_Fcent(:,1),DQ_Fcent(:,2),'.')
herrorbar(DQ_EFD(:,1),DQ_Fcent(:,1),DQ_EFD(:,2),'.')

errorbar(SAR_EFD(:,1),SAR_Fcent(:,1),SAR_Fcent(:,2),'r.')
herrorbar(SAR_EFD(:,1),SAR_Fcent(:,1),SAR_EFD(:,2),'r.')

errorbar(SAR_EFD(7:8,1),SAR_Fcent(7:8,1),SAR_Fcent(7:8,2),'g.')
herrorbar(SAR_EFD(7:8,1),SAR_Fcent(7:8,1),SAR_EFD(7:8,2),'g.')
xlabel('Energy Flux Density (Pa^2s)'); ylabel('Centroid Frequency (Hz)')
adjustfigurefont
box on

%% 
figure(80)
plot(BREATHONLY(:,6),BREATHONLY(:,1),'.')
hold on
plot([0 3],[0 3])
xlabel('Inhalation Duration'); ylabel('Exhalation Duration')
adjustfigurefont

figure(81)
plot(BREATHONLY(:,10),BREATHONLY(:,5),'.')
hold on
plot([0 3500],[0 3500])
xlabel('Inhalation Centroid Frequency (kHz)'); ylabel('Exhalation Centroid Frequency (kHz)')
adjustfigurefont

figure(82); clf; hold on
plot(BREATHONLY(:,1),BREATHONLY(:,5)/1000,'.')
plot(BREATHONLY(:,6),BREATHONLY(:,10)/1000,'r.')
box on
xlabel('95% Energy Duration (s)'); ylabel('Centroid Frequency (kHz)')
adjustfigurefont
