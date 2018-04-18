figure(88), clf, hold on
histogram(Sint1,10)
c = viridis; 
num = length(Sint1); % how many colours to choose: here, number of breaths
nums = 1:num; 
entries = round(linspace(1,length(c),num)); % evenly spaced in vector
cvec = c(entries,:);

for i = 1:length(Sint1)
    plot([Sint1(i) Sint1(i)],[0 0.5],'color',cvec(i,:))
end

for i = 1:length(Sint1_off)
    plot([Sint1_off(i) Sint1_off(i)],[0 0.5],'b')
end

