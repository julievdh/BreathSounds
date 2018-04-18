function [DQid, DQcol] = assignDQname(filename)
% assign name and colour based on filename of DQ data
% Lono = 1, Kolohe = 2, Liho = 3, Nainoa = 4, Hoku = 5, Hua = 6, Liko = 7
if strfind(filename,'Lon') > 0 
    DQid = 1; % lono = 245 kg
    DQcol = [228 26 28]/255;
end
if strfind(filename,'Kolohe') > 0
    DQid = 2;
    DQcol = [55 126 184]/255;
end
if strfind(filename,'Liho') > 0
    DQid = 3;
    DQcol = [77 175 74]/255;
end
if strfind(filename,'Nai') > 0
    DQid = 4;
    DQcol = [152 78 163]/255;
end
if strfind(filename,'oku') > 0 % for capitalisation reasons
    DQid = 5;
    DQcol = [255 127 0]/255;
end
if strfind(filename,'Hua') > 0
    DQid = 6;
    DQcol = [255 255 51]/255;
end
if strfind(filename,'Liko') > 0
    DQid = 7;
    DQcol = [166 86 40]/255;
end

