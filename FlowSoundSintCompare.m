% FlowSintCompare 

% load corrstore and DQ2017 file list
load([cd '\PneumoData\corrstoreET'])
load('DQFiles2017')
close all

for f = [16:25 27]; % as an example

% load FlowSound for that file 
load([cd '\PneumoData\' DQ2017{f,2} '_resp_flowsound'])

% get sorted indices for B
[~,I] = sort(VTe);

% plot against each measured values
figure(1), clf, hold on
[ax1] = scatterhist3(corrstore(f).pred1,abs(corrstore(f).B),'^',1,1);
scatterhist3(VTest(1,:),VTe,'^',1,1);
plot(ax1,[0 max(VTe)+2],[0 max(VTe)+2],'color',[0.5 0.5 0.5])
% plot(corrstore(f).pred2,abs(corrstore(f).B),'^',VTest(2,:),VTe,'^')

xlabel(ax1,'Estimated VT (L)'), ylabel(ax1,'Measured VT (L)')

% plot against each other
figure(2), hold on 
[ax1] = scatterhist3(corrstore(f).pred1,VTest(1,I),'^',1,1);
plot(ax1,[0 max(VTe)+2],[0 max(VTe)+2],'color',[0.5 0.5 0.5])

xlabel(ax1,'Sint'), ylabel(ax1,'FlowSound')

% error
% compute for Sint
SintErr = corrstore(f).pred1-abs(corrstore(f).B);
figure(3), hold on 
[ax1] = scatterhist3(SintErr,VTerre(1,I),'o',1);
xlabel(ax1,'Sint Error (L)'), ylabel(ax1,'FlowSound Error (L)') 
end
plot(ax1,[-15 10],[-15 10],'color',[0.5 0.5 0.5])
