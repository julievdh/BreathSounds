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


for i = 1:length(files)
    if isempty(files(i).tdiff) == 0
        % calculate duration of resp audit in hours
        files(i).dur = (files(i).resp(end) - files(i).resp(1))/3600;
        if files(i).dur >= 6
            mnIBI(i) = mean(files(i).tdiff); % mean IBI
            stdIBI(i) = std(files(i).tdiff); % STD
            mdIBI(i) = median(files(i).tdiff); % median IBI
            modeIBI(i) = mode(files(i).tdiff); % mode
            
            % if isfield(files(i),'swim_ct') == 1
            mnf(i) = 60/mnIBI(i); % mean frequency
            mdf(i) = 60/mdIBI(i); % median frequency
            % end
        else
            mnIBI(i) = NaN; % mean IBI
            stdIBI(i) = NaN; % STD
            mdIBI(i) = NaN; % median IBI
            modeIBI(i) = NaN; % mode
        end
        else files(i).dur = NaN;
    end
end

wt = [files(:).wt];
dur = [files(:).dur];
spp = [files(:).spp];

% pick specific species codes: 3 4 6 7 

% 
