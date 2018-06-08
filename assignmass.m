function mass = assignmass(filename)
if strfind(filename,'Lon') >= 1 
        mass = 245; % lono = 245 kg
end
if strfind(filename,'Kolohe') >= 1 
        mass = 209;
end
if strfind(filename,'Liho') >= 1
            mass = 156;
end
if strfind(filename,'Nai') >= 1
                mass = 186; 
end
if strfind(filename,'Hoku') >= 1
        mass = 186; % yes, Hoku and Nainoa weigh the same
end
if strfind(filename,'Hua') >= 1
        mass = 143; 
end
if strfind(filename,'Liko') >= 1
    mass = 167; 
end
if strfind(filename,'FB142') >= 1
    mass = 291; 
end

