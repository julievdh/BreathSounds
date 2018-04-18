% parse LabChart

[nchan nblock] = size(datastart);


for ch = 1:nchan
    v = genvarname(titles(ch,:));
    for bl = 1:nblock
    eval(strcat(v,'{',num2str(bl), '} = data(datastart(',num2str(ch),',',num2str(bl),'):dataend(',num2str(ch),',',num2str(bl),'));'));
    end
end

