function [cues,R] = findbreathcues(R)
% [cues,R] = findbreathcues(R)
% find all cues that include 'breath' or 'surf' 'resp(h)' 'exh' 'blow'

% Julie van der Hoop jvanderhoop@whoi.edu

[Au,idx,idx2] = uniquecell(R.stype);
for i = 1:length(Au)
    if isempty(strfind(Au{i},'surf')) == 0
        scue(:,i) = i; % index involved with surfacing
    else if isempty(strfind(Au{i},'reath')) == 0
            scue(:,i) = i; % index involved with breathing
        else if isempty(strfind(Au{i},'blow')) == 0
                scue(:,i) = i; % index involved with breathing
            else if isempty(strfind(Au{i},'resp')) == 0
                    scue(:,i) = i; % index involved with breathing
                else if isempty(strfind(Au{i},'exh')) == 0
                    end
                end
            end
        end
    end
end
    if exist('scue')
        [cues,R] = findaudit(R,[Au(scue > 0)]); % use only cues associated with breaths or surfacings
    else cues = []; 
    end
    