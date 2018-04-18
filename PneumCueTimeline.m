figure(12); clf
if exist('RAW_DATA','var') == 1
    plot(RAW_DATA(:,1),RAW_DATA(:,3),'LineWidth',2); hold on
end
if exist('RAWDATA','var')
    plot(RAWDATA(:,1),RAWDATA(:,3),'LineWidth',2); hold on
end
if exist('all_RAWDATA','var') % for DQ 2013, all_RAWDATA(:,2) is Flow Rate 
    plot(all_RAWDATA(:,1),all_RAWDATA(:,2),'LineWidth',2); hold on
end


if exist('RESPTIMING','var')
    plot(RAW_DATA(1,1)+RESPTIMING(:,1)/400,0,'k*')
    % plot RESPTIMING numbers
    for n = 1:length(RESPTIMING)
        text(RAW_DATA(1,1)+RESPTIMING(n,1)/400,5,num2str(n))
    end
end
% find pneumotach cues
[~,pneum] = findaudit(R,'pneum');
for n = 1:length(pneum.cue(:,1))
    line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
end
% plot all exhaled breaths
for n = 1:length(breath.cue)
    line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
    text(breath.cue(n,1)-tcue,50,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
