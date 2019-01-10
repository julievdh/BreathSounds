%% get all Sarasota deck data
% expirations
Sdeck_e = horzcat(tt126z.eParams.time_window,tt126y.eParams.time_window,...
    tt126x.eParams.time_window,tt128z.eParams.time_window,...
    tt128y.eParams.time_window,tt129z.eParams.time_window,...
    tt129y.eParams.time_window,tt129x.eParams.time_window)';

% inspirations
Sdeck_i = horzcat(tt126y.iParams.time_window,...
    tt126x.iParams.time_window,tt128z.iParams.time_window,...
    tt128y.iParams.time_window,tt129z.iParams.time_window,...
    tt129y.iParams.time_window,tt129x.iParams.time_window)';

Sdeck_e = Sdeck_e(Sdeck_e ~= 0);
Sdeck_i = Sdeck_i(Sdeck_i ~= 0);

% test = vertcat(repmat(1,length(Sdeck_e),1),repmat(2,length(Sdeck_i),1));
% boxplot(vertcat(Sdeck_e,Sdeck_i),test)

%% get all Sarasota swimming data
% expirations
Sswim_e = horzcat(tt125a.eParams.time_window(59:end),...
    tt125b.eParams.time_window(58:end),tt126b.eParams.time_window(19:end),...
    tt126a.eParams.time_window(25:end),tt129c.eParams.time_window(31:end))';

% inspirations
Sswim_i = horzcat(tt125a.iParams.time_window(59:end),...
    tt125b.iParams.time_window(58:end),tt126b.iParams.time_window(19:end),...
    tt126a.iParams.time_window(25:end),tt129c.iParams.time_window(31:end))';

Sswim_e = Sswim_e(Sswim_e ~= 0);
Sswim_i = Sswim_i(Sswim_i ~= 0);

%% Get all Sarasota floating data
% expirations
Sfloat_e = horzcat(tt125a.eParams.time_window(1:30),tt125b.eParams.time_window(1:57),...
    tt126b.eParams.time_window(1:18),tt126a.eParams.time_window(1:24),...
    tt129c.eParams.time_window(1:30))';

% inspirations
Sfloat_i = horzcat(tt125a.iParams.time_window(1:30),tt125b.iParams.time_window(1:57),...
    tt126b.iParams.time_window(1:18),tt126a.iParams.time_window(1:24),...
    tt129c.iParams.time_window(1:30))';

Sfloat_e = Sfloat_e(Sfloat_e ~= 0);
Sfloat_i = Sfloat_i(Sfloat_i ~= 0);

%% FIGURE: Sarasota deck, floating, swimming expirations and inspirations

all = vertcat(repmat(1,length(Sdeck_e),1),repmat(2,length(Sdeck_i),1),...
    repmat(3,length(Sfloat_e),1),repmat(4,length(Sfloat_i),1),...
    repmat(5,length(Sswim_e),1),repmat(6,length(Sswim_i),1));

figure(1)
boxplot(vertcat(Sdeck_e,Sdeck_i,Sfloat_e,Sfloat_i,Sswim_e,Sswim_i),all,...
    'labels',{'Deck Expiration','Deck Inspiration','Float Expiration',...
    'Float Inspiration','Swim Expiration','Swim Inspiration'})

hB=findobj('Type','hggroup');
hL=findobj(hB,'Type','text');
set(hL,'Rotation',35);

ylabel('Duration (s)')

%% Get all DQ float 1 data
% expirations
DQfloat1_e = horzcat(tt267b.eParams.time_window(6:11),...
    tt268c.eParams.time_window(3:8),tt268d.eParams.time_window(3:13),...
    tt269c.eParams.time_window(2:13),tt271b.eParams.time_window(3:11),...
    tt272a.eParams.time_window(3:11),tt273a.eParams.time_window(4:13),...
    tt276a.eParams.time_window(2:9),tt276b.eParams.time_window(2:14),...
    tt278a.eParams.time_window(1:12),tt279b.eParams.time_window(3:12),...
    tt281a.eParams.time_window(5:16),tt282b.eParams.time_window(2:9),...
    tt283a.eParams.time_window(2:8),tt283a.eParams.time_window(19:24),...
    tt284a.eParams.time_window(12:17),tt285d.eParams.time_window(3:11))';

% inspirations
DQfloat1_i = horzcat(tt267b.iParams.time_window(6:11),...
    tt268c.iParams.time_window(3:8),tt268d.iParams.time_window(3:13),...
    tt269c.iParams.time_window(2:13),tt271b.iParams.time_window(3:11),...
    tt272a.iParams.time_window(3:11),tt273a.iParams.time_window(4:13),...
    tt276a.iParams.time_window(2:9),tt276b.iParams.time_window(2:14),...
    tt278a.iParams.time_window(1:12),tt279b.iParams.time_window(3:12),...
    tt281a.iParams.time_window(5:16),tt282b.iParams.time_window(2:9),...
    tt283a.iParams.time_window(2:8),tt283a.iParams.time_window(19:24),...
    tt284a.iParams.time_window(12:17),tt285d.iParams.time_window(3:11))';

DQfloat1_e = DQfloat1_e(DQfloat1_e ~= 0);
DQfloat1_i = DQfloat1_i(DQfloat1_i ~= 0);


%% Get all DQ swim data
% expirations
DQswim_e = horzcat(tt268d.eParams.time_window(14:36),...
    tt268d.eParams.time_window(14:36),tt271b.eParams.time_window(12:50),...
    tt272a.eParams.time_window(12:33),tt273a.eParams.time_window(14:49),...
    tt276a.eParams.time_window(10:38),tt276b.eParams.time_window(15:51),...
    tt279b.eParams.time_window(13:43),tt281a.eParams.time_window(17:42),...
    tt282b.eParams.time_window(10:22),tt283a.eParams.time_window(25:67),...
    tt284a.eParams.time_window(18:32),tt285d.eParams.time_window(12:34))';

% inspirations
DQswim_i = horzcat(tt268d.iParams.time_window(14:36),...
    tt268d.iParams.time_window(14:36),tt271b.iParams.time_window(12:50),...
    tt272a.iParams.time_window(12:33),tt273a.iParams.time_window(14:49),...
    tt276a.iParams.time_window(10:38),tt276b.iParams.time_window(15:51),...
    tt279b.iParams.time_window(13:43),tt281a.iParams.time_window(17:42),...
    tt282b.iParams.time_window(10:22),tt283a.iParams.time_window(25:67),...
    tt284a.iParams.time_window(18:32),tt285d.iParams.time_window(12:34))';

DQswim_e = DQswim_e(DQswim_e ~= 0);
DQswim_i = DQswim_i(DQswim_i ~= 0);

% THERE IS ONLY ONE NON-ZERO SWIMMING EXPIRATION, AND NO SWIMMING
% INSPIRATIONS AT DQ

%% Get all DQ float 2 data
% expirations
DQfloat2_e = horzcat(tt267b.eParams.time_window(12:end),...
    tt268c.eParams.time_window(9:end),tt268d.eParams.time_window(37:63),...
    tt269c.eParams.time_window(14:40),tt271b.eParams.time_window(51:62),...
    tt272a.eParams.time_window(34:38),tt273a.eParams.time_window(50:end),...
    tt276a.eParams.time_window(39:end),tt276b.eParams.time_window(52:end),...
    tt278a.eParams.time_window(13:31),tt279b.eParams.time_window(44:55),...
    tt281a.eParams.time_window(43:end),tt282b.eParams.time_window(23:30),...
    tt283a.eParams.time_window(68:100),tt284a.eParams.time_window(33:40),...
    tt285d.eParams.time_window(35:58))';

% inspirations
DQfloat2_i = horzcat(tt267b.iParams.time_window(12:end),...
    tt268c.iParams.time_window(9:end),tt268d.iParams.time_window(37:63),...
    tt269c.iParams.time_window(14:37),tt271b.iParams.time_window(51:62),...
    tt272a.iParams.time_window(34:38),tt273a.iParams.time_window(50:end),...
    tt276a.iParams.time_window(39:end),tt276b.iParams.time_window(52:end),...
    tt278a.iParams.time_window(13:31),tt279b.iParams.time_window(44:55),...
    tt281a.iParams.time_window(43:end),tt282b.iParams.time_window(23:30),...
    tt283a.iParams.time_window(68:99),tt284a.iParams.time_window(33:40),...
    tt285d.iParams.time_window(35:54))';

DQfloat2_e = DQfloat2_e(DQfloat2_e ~= 0);
DQfloat2_i = DQfloat2_i(DQfloat2_i ~= 0);

%% FIGURE: Boxplot with DQ float1, float2 expirations and inspirations

% NOT INCLUDING SWIM
all = vertcat(repmat(1,length(DQfloat1_e),1),repmat(2,length(DQfloat1_i),1),...
    repmat(5,length(DQfloat2_e),1),repmat(6,length(DQfloat2_i),1));

figure(2)
boxplot(vertcat(DQfloat1_e,DQfloat1_i,DQfloat2_e,DQfloat2_i),all,'labels',...
    {'Float 1 Expiration','Float 1 Inspiration','Float 2 Expiration','Float 2 Inspiration'})

hB=findobj('Type','hggroup');
hL=findobj(hB,'Type','text');
set(hL,'Rotation',35);

ylabel('Duration (s)')


%% PLOT ALL TOGETHER 

all = vertcat(repmat(1,length(Sdeck_e),1),repmat(2,length(Sdeck_i),1),...
    repmat(3,length(Sfloat_e),1),repmat(4,length(Sfloat_i),1),...
    repmat(5,length(Sswim_e),1),repmat(6,length(Sswim_i),1),...
    repmat(7,length(DQfloat1_e),1),repmat(8,length(DQfloat1_i),1),...
    repmat(9,length(DQfloat2_e),1),repmat(10,length(DQfloat2_i),1));

figure(3)
boxplot(vertcat(Sdeck_e,Sdeck_i,Sfloat_e,Sfloat_i,Sswim_e,Sswim_i,...
    DQfloat1_e,DQfloat1_i,DQfloat2_e,DQfloat2_i),all)

ylabel('Duration (s)')


%% 

return

figure(36)

hold on



xlabel('Fcent(Hz)')
ylabel('Duration(s)')
legend('Sarasota deck', 'Sarasota free-swimming','Sarasota floating','DQ initial floating','DQ swimming','DQ final floating')

%figure 37
figure(37)
d=plot(tt126y.iParams.Fcent,tt126y.iParams.time_window,'m.')
hold on
plot(tt125a.iParams.Fcent(59:end),tt125a.iParams.time_window(59:end),'.')
plot(tt125a.iParams.Fcent(1:58),tt125a.iParams.time_window(1:58),'r.')
plot(tt129c.iParams.Fcent(31:end),tt129c.iParams.time_window(31:end),'r x')
plot(tt268d.iParams.Fcent(14:36),tt268d.iParams.time_window(14:36),'x')
plot(tt267b.iParams.Fcent(12:end),tt267b.iParams.time_window(12:end),'g x')

plot(tt125b.iParams.Fcent(58:end),tt125b.iParams.time_window(58:end),'.')
plot(tt125b.iParams.Fcent(1:57),tt125b.iParams.time_window(1:57),'r.')
plot(tt126b.iParams.Fcent(19:end),tt126b.iParams.time_window(19:end),'.')
plot(tt126b.iParams.Fcent(1:18),tt126b.iParams.time_window(1:18),'r.')
plot(tt126a.iParams.Fcent(25:end),tt126a.iParams.time_window(25:end),'.')
plot(tt126a.iParams.Fcent(1:25),tt126a.iParams.time_window(1:25),'r.')
plot(tt129c.iParams.Fcent(1:30),tt129c.iParams.time_window(1:30),'r.')
plot(tt267b.iParams.Fcent(6:11),tt267b.iParams.time_window(6:11),'r x')
plot(tt268c.iParams.Fcent(3:8),tt268c.iParams.time_window(3:8),'r x')
plot(tt268d.iParams.Fcent(3:13),tt268d.iParams.time_window(3:13),'r x')
plot(tt269c.iParams.Fcent(2:13),tt269c.iParams.time_window(2:13),'r x')
plot(tt271b.iParams.Fcent(3:11),tt271b.iParams.time_window(3:11),'r x')
plot(tt272a.iParams.Fcent(3:11),tt272a.iParams.time_window(3:11),'r x')
plot(tt273a.iParams.Fcent(4:13),tt273a.iParams.time_window(4:13),'r x')
plot(tt276a.iParams.Fcent(2:9),tt276a.iParams.time_window(2:9),'r x')
plot(tt276b.iParams.Fcent(2:14),tt276b.iParams.time_window(2:14),'r x')
plot(tt278a.iParams.Fcent(1:12),tt278a.iParams.time_window(1:12),'r x')
plot(tt279b.iParams.Fcent(3:12),tt279b.iParams.time_window(3:12),'r x')
plot(tt281a.iParams.Fcent(5:16),tt281a.iParams.time_window(5:16),'r x')
plot(tt282b.iParams.Fcent(2:9),tt282b.iParams.time_window(2:9),'r x')
plot(tt283a.iParams.Fcent(2:8),tt283a.iParams.time_window(2:8),'r x')
plot(tt283a.iParams.Fcent(19:24),tt283a.iParams.time_window(19:24),'r x')
plot(tt284a.iParams.Fcent(12:17),tt284a.iParams.time_window(12:17),'r x')
plot(tt285d.iParams.Fcent(3:11),tt285d.iParams.time_window(3:11),'r x')
% plot(tt288a.iParams.Fcent(4:9),tt288a.iParams.time_window(4:9),'r x')
plot(tt271b.iParams.Fcent(12:50),tt271b.iParams.time_window(12:50),'x')
plot(tt272a.iParams.Fcent(12:33),tt272a.iParams.time_window(12:33),'x')
plot(tt273a.iParams.Fcent(14:49),tt273a.iParams.time_window(14:49),'x')
plot(tt276a.iParams.Fcent(10:38),tt276a.iParams.time_window(10:38),'x')
plot(tt276b.iParams.Fcent(15:51),tt276b.iParams.time_window(15:51),'x')
plot(tt279b.iParams.Fcent(13:43),tt279b.iParams.time_window(13:43),'x')
plot(tt281a.iParams.Fcent(17:42),tt281a.iParams.time_window(17:42),'x')
plot(tt282b.iParams.Fcent(10:22),tt282b.iParams.time_window(10:22),'x')
plot(tt283a.iParams.Fcent(25:67),tt283a.iParams.time_window(25:67),'x')
plot(tt284a.iParams.Fcent(18:32),tt284a.iParams.time_window(18:32),'x')
plot(tt285d.iParams.Fcent(12:34),tt285d.iParams.time_window(12:34),'x')
% plot(tt288a.iParams.Fcent(10:36),tt288a.iParams.time_window(10:36),'x')
plot(tt268c.iParams.Fcent(9:end),tt268c.iParams.time_window(9:end),'g x')
plot(tt268d.iParams.Fcent(37:63),tt268d.iParams.time_window(37:63),'g x')
plot(tt269c.iParams.Fcent(14:37),tt269c.iParams.time_window(14:37),'g x')
plot(tt271b.iParams.Fcent(51:62),tt271b.iParams.time_window(51:62),'g x')
plot(tt272a.iParams.Fcent(34:38),tt272a.iParams.time_window(34:38),'g x')
plot(tt273a.iParams.Fcent(50:end),tt273a.iParams.time_window(50:end),'g x')
plot(tt276a.iParams.Fcent(39:end),tt276a.iParams.time_window(39:end),'g x')
plot(tt276b.iParams.Fcent(52:end),tt276b.iParams.time_window(52:end),'g x')
plot(tt278a.iParams.Fcent(13:31),tt278a.iParams.time_window(13:31),'g x')
plot(tt279b.iParams.Fcent(44:55),tt279b.iParams.time_window(44:55),'g x')
plot(tt281a.iParams.Fcent(43:end),tt281a.iParams.time_window(43:end),'g x')
plot(tt282b.iParams.Fcent(23:30),tt282b.iParams.time_window(23:30),'g x')
plot(tt283a.iParams.Fcent(68:99),tt283a.iParams.time_window(68:99),'g x')
plot(tt284a.iParams.Fcent(33:40),tt284a.iParams.time_window(33:40),'g x')
plot(tt285d.iParams.Fcent(35:54),tt285d.iParams.time_window(35:54),'g x')
% plot(tt288a.iParams.Fcent(37:46),tt288a.iParams.time_window(37:46),'g x')
xlabel('Fcent(Hz)')
ylabel('Duration(s)')
legend('Sarasota deck', 'Sarasota free-swimming','Sarasota floating','DQ initial floating','DQ swimming','DQ final floating')

