% loop through to check audit status of files

clear all

% load files
[S,D] = AllFilesImport(1); % 1 = Sarasota, 2 = DQ. Try to add 3 = both 

% return to standard directory
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\'

%% plot audit details
for f = 1:length(S);
    
    S(f).t = (1:length(S(f).p))/S(f).fs;
    figure(f); clf; hold on
    plot(S(f).t,-S(f).p)
    for i = 1:length(S(f).R.cue)
        plot(S(f).R.cue(i),0,'r*')
    end
    % title figure
    title(regexprep(S(f).name,'_',' '))
    xlabel('Time (s)'); ylabel('Depth (m)')
    % save
    filename = strcat(S(f).name,'_auditcheckfig');
    cd  \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures\AuditCheck
    print(filename,'-dpng')
end

%% for DQ
for f = 1:length(D);
    
    D(f).t = (1:length(D(f).p))/D(f).fs;
    figure(f+length(S)); clf; hold on
    plot(D(f).t,-D(f).p)
    for i = 1:length(D(f).R.cue)
        plot(D(f).R.cue(i),0,'r*')
    end
    % title figure
    title(regexprep(D(f).name,'_',' '))
    xlabel('Time (s)'); ylabel('Depth (m)')
    % save
    filename = strcat(D(f).name,'_auditcheckfig');
    cd  \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures\AuditCheck
    print(filename,'-dpng')
    
end
