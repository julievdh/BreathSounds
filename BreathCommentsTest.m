% clear all

% load ChestBand .mat file
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
[filename,path] = uigetfile;
load([path filename]);

%% parse
for i = 1:size(titles,1)
    v = genvarname(titles(i,:));
    eval(strcat(v, ' = data(datastart(', num2str(i), '):dataend(', num2str(i), '));'));
end
%%
ChestBand = -ChestBand; 
ChestBand = ChestBand-median(ChestBand); % Remove DC;
FilteredFlow = FilteredFlow - median(FilteredFlow);

t = 1:length(ChestBand); % index vector

figure(1), clf, hold on
[ax, h1, h2] = plotyy(t,FilteredFlow,t,ChestBand); 
title('Flow and Band')

%% add comments
% find all breaths:
for i = 1:length(comtext)
    bind(i) = isempty(strfind(comtext(i),'b'));
    lind(i) = isempty(strfind(comtext(i),'l'));
    cind(i) = isempty(strfind(comtext(i),'c'));
end
bs = find(bind == 0);
bcom = com(find(com(:,5) == bs(1) | com(:,5) == bs(2)),:);
for i = 1:size(bcom,1)
    plot([bcom(i,3) bcom(i,3)],[-10 10],'k:')
end

ls = find(lind == 0);
if isempty(ls) == 0
    lcom = com(find(com(:,5) == ls(1)),:);
    for i = 1:size(lcom,1)
        plot([lcom(i,3) lcom(i,3)],[-10 10],'r:')
    end
end
cs = find(cind == 0);
if isempty(cs) ~= 1
if size(cs,1) == 1
    ccom = com(find(com(:,5) == cs(1)),:);
else if size(cs,1) > 1
        ccom = com(find(com(:,5) == cs(1) | com(:,5) == cs(2)),:);
    end
end

for i = 1:size(ccom,1)
    plot([ccom(i,3) ccom(i,3)],[-10 10],'k-')
end
end

% keep filename ChestBand FilteredFlow t tickrate

return


%% plot diffs

figure(3)
[ax, h1, h2] = plotyy(t(1:end-1),diff(FlowRaw),t(1:end-1),diff(ChestBand));
% align zero for left and right
maxval = cellfun(@(x) max(abs(x)), get([h1 h2], 'YData'));
ylim = [-maxval, maxval] * 1.1;  % Mult by 1.1 to pad out a bit
set(ax(1), 'YLim', ylim(1,:) );
set(ax(2), 'YLim', ylim(2,:) );
title('diff(Flow) and diff(Band)')

%%
