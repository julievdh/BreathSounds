figure(38)


start=59;
I=find(tt125a.eParams.time_window(start:end))+(start-1);
exp = tt125a.eParams.time_window(I);
I=find(tt125a.iParams.time_window(start:end))+(start-1);
insp = tt125a.iParams.time_window(I);
I=find(tt125a.sParams.time_window(start:end))+(start-1);
surf = tt125a.sParams.time_window(I);

expn = length(exp);
inspn = length(insp);
surfn = length(surf);

all = vertcat(exp',insp',surf');
alln = vertcat(repmat(1,expn,1),repmat(2,inspn,1),repmat(3,surfn,1));

boxplot(all,alln,'labels',{'Expiration','Inspiration','Surface'})
ylabel('Duration (s)','FontSize',12)


ylabel('Duration(s)')
