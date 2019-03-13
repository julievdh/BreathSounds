for n = 501:520 %length(q) % 1:length(q);
    sub = []; H = [];
    surfstore(n).sound = []; % make sure a row is empty
    
    [x,xfilt,afs,tcue,tdur] = BreathFilt(q(n),breath,recdir,tag,1); % using RESP not R 
   
    [~,~,~,s_a] = CleanSpectra_fun(xfilt,afs,[tcue-0.4 tdur+0.4+0.6]);
    
    figure(1), clf, hold on, plot(s_a), plot(ins(q(n),1)*afs,0,'ko'), plot(ins(q(n),2)*afs,0,'ko')
    title(num2str(n))
    pause
end
