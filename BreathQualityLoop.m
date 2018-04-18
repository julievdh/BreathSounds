% Loop together all breaths in a deployment to calculate breath sound
% parameters over selected expirations and inspirations
% Controls for quality based on masking sound types

% Calls upon BreathFilt, BreathParams, other custom breath code

% Julie van der Hoop // June 2014 // jvanderhoop@whoi.edu
% Last Updated: 27 June 2014
close all; clear; clc
warning off

%% LOAD IN TAG DATA
% load('DQfiles2017')
% f = 11; tag = DQ2017{f,1};
% set path, tag
% change tag and path for different deployments
load('DQFiles2017')
f = 10;
tag = DQ2017{f,1};

recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);
[~,breath] = findbreathcues(R); 

%% LOOP THROUGH ALL BREATHS AUDITED
% MIGHT HAVE TO CHANGE THIS TO DO BREATH SEARCH FIRST, THEN LENGTH = THAT
% do params and quality already exist?
cd('C:/tag/tagdata/')
list = dir('*.mat');
if exist(strcat(tag,'_PQ.mat'), 'file') ~= 2
    % if not, establish Params and Quality
    eParams = [];
    iParams = [];
    tParams = [];
    sParams = [];
    Quality = nan(length(breath.cue),1);
else if exist(strcat(tag,'_PQ.mat'), 'file') == 2
        load(strcat(tag,'_PQ'))
    end
end
if exist('exp') ~= 1
    exp = nan(length(breath.cue),2);
    ins = nan(length(breath.cue),2);
    srf = nan(length(breath.cue),2);
end
if exist('btype') == 0
    btype = zeros(length(breath.cue),3);
end


%%
% [~,resp] = findaudit(R,'resp'); % just do for free-swimming ones

% loop through all audited breaths (= length of R.cue)
for i = 1:10 % length(resp.cue)
    
    % downsample and filter single breath
    [x,xfilt,afs] = BreathFilt(i,breath,recdir,tag,1); % using RESP not R 
    figure(1); hold on
    title(i)
    
    %     % plot 95% energy
    %     figure(2); clf; set(gcf,'Position',[200 175 560 420])
    %     energy95(xfilt,i,R,2)
    %     plot((1:length(xfilt))/afs,100*xfilt,'k')
    
    % play sound
    p = audioplayer(xfilt, afs); play(p)
    
    % request quality input via prompt
    % 0 = good; 1 = talking;
    % 20 = splashing but good (splash around breath can be removed)
    % 22 = splashing, not good; 3 = dolphin sounds (click, whistle); 4 = other
    
    Quality(i) = input('enter breath quality  ');
    
    % if clip is overall good:
    if Quality(i) == 0 || Quality(i) == 20 || Quality(i) == 1 
         %         % does the clip capture expiration only, or fully?
        %         result = input('if entire clip = expiration, type 1; if not, 0:  ');
        %         if result == 1;
        %             exp(i,:) = [0 R.cue(i,2)+0.2];
        %             [eParams] = BreathParams(xfilt,i,eParams,R);
        %             energy95sub(xfilt,i,exp(i,1),2)
        %         end
        %         if result ~= 1;
        reenter = 1;
        while reenter == 1
            % input start of range
            disp('select start')
            figure(1)
            temp1 = ginput(1);
            plot(temp1(1,1),15,'k*')
            % input end of range
            disp('select end')
            temp2 = ginput(1);
            plot(temp2(1,1),15,'k*')
            plot([temp1(1,1) temp2(1,1)],[15 15],'k')
            % play sound
            p = audioplayer(xfilt(temp1(1,1)*afs:temp2(1,1)*afs), afs); play(p)
            % accept selected area?
            yn = input('accept: 1 or 0?  ');
            if yn == 1
                % is it expiration (e) or inspiration (i)?
                sec = input('enter e or i or s  ','s');
                if strmatch(sec,'i') == 1
                    ins(i,:) = [temp1(:,1) temp2(:,1)];
                else if strmatch(sec,'e') == 1
                        exp(i,:) = [temp1(:,1) temp2(:,1)];
                    else if strmatch(sec,'s') == 1
                            srf(i,:) = [temp1(:,1) temp2(:,1)];
                        end
                    end
                end
            end
            if yn == 0
                clear yn temp1 temp2
            end
            % want to enter another?
            reenter = input('select another section: 1 or 0?  ');
        % end
    end
end

% calculate params
%     figure(10); hold on
%     plot(xfilt(exp(i,1)*afs:ins(i,2)*afs))
%     plot([ins(i,1)*afs ins(i,2)*afs],[2 2],'r')
%     plot([exp(i,1)*afs exp(i,2)*afs],[2 2],'r')
%
% if expiration is detected
if exp(i,1) > 0
    % calculate params over e, plot 95% energy of e only
    [eParams] = BreathParams(xfilt(floor(exp(i,1)*afs):floor(exp(i,2)*afs)),i,afs,eParams,breath);
    % energy95sub(xfilt(floor(exp(i,1)*afs):floor(exp(i,2)*afs)),i,exp(i,1),1)
    % enter breath type in btype matrix
    btype(i,1) = 1;
    
    % if expiration AND inspiration is detected
    if ins(i,1) > 0
        % calculate params over e and i together, plot 95% energy
        [tParams] = BreathParams(xfilt(floor(exp(i,1)*afs):floor(ins(i,2)*afs)),i,afs,tParams,breath);
        % energy95sub(xfilt(floor(exp(i,1)*afs):floor(ins(i,2)*afs)),i,exp(i,1),1)
    end
end
% if inspiration is detected
if ins(i,1) > 0
    % calculate params over i, plot 95% energy of i only
    [iParams] = BreathParams(xfilt(floor(ins(i,1)*afs):floor(ins(i,2)*afs)),i,afs,tParams,breath);
    % energy95sub(xfilt(floor(ins(i,1)*afs):floor(ins(i,2)*afs)),i,ins(i,1),1)
    % enter in btype matrix
    btype(i,2) = 1;
    
end
% if during a surface for free-swimming (uncertain as to whether exp or
% insp)
if srf(i,1) > 0
    % calculate params over i, plot 95% energy of i only
    [sParams] = BreathParams(xfilt(floor(srf(i,1)*afs):floor(srf(i,2)*afs)),i,afs,sParams,breath);
    % energy95sub(xfilt(floor(srf(i,1)*afs):floor(srf(i,2)*afs)),i,srf(i,1),1)
    % enter in bytpe matrix
    btype(i,3) = 1;
end
end

% ZeroBreaths

% save Params and Quality
save(strcat('C:/tag/tagdata/',tag,'_PQ'),'eParams','iParams','tParams','sParams','Quality','btype','exp','ins','srf','R') 
% save the version of the audit structure that went with these params


% USEFUL:
%  p = audioplayer(xfilt, afs);
%  play(p)

