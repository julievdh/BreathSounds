% files for Peter FMR

% select files for Peter's FMR paper:
% + short-finned pilot whales = spp 3
% + sperm whales = spp 7
% + mesoplodon = spp 4
% + cuvier's = spp 6


% load count data from tags
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\BreathCounts
load('countdata')
assignSpp % assign species codes

% pick specific species codes: 3 4 6 7
selspp = ismember(spp,[3 4 6 7]);
seldur = dur(selspp); % all durations for the selected species


for i = 1:length(files)
    if isempty(files(i).tdiff) == 0
        % calculate duration of resp audit in hours
        files(i).dur = (files(i).resp(end) - files(i).resp(1))/3600;
        
        files(i).mnIBI = mean(files(i).tdiff); % mean IBI
        files(i).stdIBI = std(files(i).tdiff); % STD
        files(i).mdIBI = median(files(i).tdiff); % median IBI
        files(i).modeIBI = mode(files(i).tdiff); % mode
        
        % if isfield(files(i),'swim_ct') == 1
        files(i).mnf = 60/mnIBI(i); % mean frequency
        files(i).mdf = 60/mdIBI(i); % median frequency
        % end
        
    else files(i).dur = NaN;
    end
end

wt = [files(:).wt];
dur = [files(:).dur];
spp = [files(:).spp];i


% remove some fields
cpy = rmfield(files,'resp');
cpy(find(~ismember(selspp,spp))) = []; % remove other species
cpy = rmfield(cpy,'tdiff');
cpy = rmfield(cpy,'age');

% save table for Peter
writetable(struct2table(cpy), 'Peter-FMR-files.csv')

%% prh plot
% preallocate figure and subplot
fig = 0.25:0.25:length(cpy)/4;
fig = ceil(fig);
sub = repmat(1:4,1,10);

for i = 1:length(cpy) % for all selected files
    % if duration is > 6
    if cpy(i).dur >= 6
        loadprh(cpy(i).tag,'p','fs')
        figure(fig(i))
        subplot(2,2,sub(i))
        if exist('p','var')
            plott(p,fs), title(cpy(i).tag)
            clear p fs
        end
    end
end