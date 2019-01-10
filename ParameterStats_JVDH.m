load('AllBreaths_noPEAK')

DQO = find(BREATHONLY(:,15) == 1);
SARASOTA = find(BREATHONLY(:,15) == 2);

animal = BREATHONLY(DQO,11);
condition = BREATHONLY(DQO,12);

varnames = {'Individual';'Condition'};
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'};

[p,table,stats] = anovan(BREATHONLY(DQO,7),{animal condition},2,2,varnames);
[c,m,h,nms] = multcompare(stats);
% figure
%[c,m,h,nms] = multcompare(stats,'dim',2);

% [table, chi2, p, factorvals] = crosstab(animal,condition)
%%
animal = BREATHONLY(SARASOTA,11);
condition = BREATHONLY(SARASOTA,12);

figure
[p,table,stats] = anovan(BREATHONLY(SARASOTA,5),{animal condition},'varnames',varnames);
[c,m,h,nms] = multcompare(stats);
title(vlbs(5))
%figure
%[c,m,h,nms] = multcompare(stats,'dim',2);

%% CONDITION FIGURE

figure(1); clf; hold on
deck = find(BREATHONLY(:,12) == 3);
water = find(BREATHONLY(:,12) == 4);
swim = find(BREATHONLY(:,12) == 5);

plot(BREATHONLY(deck,1),BREATHONLY(deck,5)/1000,'o','MarkerFaceColor','b')
plot(BREATHONLY(water,1),BREATHONLY(water,5)/1000,'co','MarkerFaceColor','c')
plot(BREATHONLY(swim,1),BREATHONLY(swim,5)/1000,'ko','MarkerFaceColor','k')

xlabel('95% Energy Duration (s)'); ylabel('Centroid Frequency (kHz)')
adjustfigurefont
box on

figure(2); clf; hold on
plot(BREATHONLY(deck,1),BREATHONLY(deck,2),'o','MarkerFaceColor','b')
plot(BREATHONLY(water,1),BREATHONLY(water,2),'co','MarkerFaceColor','c')
plot(BREATHONLY(swim,1),BREATHONLY(swim,2),'ko','MarkerFaceColor','k')

xlabel('95% Energy Duration (s)'); ylabel('Energy Flux Density (Pa^2s)')
adjustfigurefont
box on

figure(3); clf; hold on
plot(BREATHONLY(deck,2),BREATHONLY(deck,5)/1000,'o','MarkerFaceColor','b')
plot(BREATHONLY(water,2),BREATHONLY(water,5)/1000,'co','MarkerFaceColor','c')
plot(BREATHONLY(swim,2),BREATHONLY(swim,5)/1000,'ko','MarkerFaceColor','k')

xlabel('Energy Flux Density (Pa^2s)'); ylabel('Centroid Frequency (kHz)')
adjustfigurefont
box on

%% DQO

figure(4); clf; hold on
before = find(BREATHONLY(:,12) == 1);
after = find(BREATHONLY(:,12) == 2);
plot(BREATHONLY(after,1),BREATHONLY(after,5)/1000,'co','MarkerFaceColor','c')
plot(BREATHONLY(before,1),BREATHONLY(before,5)/1000,'co','MarkerFaceColor','c')

%% all together

figure(5); clf; hold on
plot(BREATHONLY(DQO,1),BREATHONLY(DQO,5)/1000,'co','MarkerFaceColor','c')

plot(BREATHONLY(water,1),BREATHONLY(water,5)/1000,'o','MarkerFaceColor',[51/255 153/255 255/255],'MarkerEdgeColor',[51/255 153/255 255/255])
plot(BREATHONLY(deck,1),BREATHONLY(deck,5)/1000,'o','MarkerFaceColor',[0 0 153/255],'MarkerEdgeColor',[0 0 153/255])
plot(BREATHONLY(swim,1),BREATHONLY(swim,5)/1000,'ko','MarkerFaceColor','k')

xlabel('95% Energy Duration (s)'); ylabel('Centroid Frequency (kHz)')
adjustfigurefont
box on

legend('Water Floating','Water Held','Swimming','Deck')

return

%% DQ VS SARASOTA
condition = BREATHONLY(:,12);
for i = 1:10
[p(i),table,stats(i)] = anovan(BREATHONLY(:,i),{condition});
[c,m,h,nms] = multcompare(stats(i),'ctype','bonferroni');
title(vlbs(i))

pause
end

