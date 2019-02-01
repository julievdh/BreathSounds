% plotMassVT

figure(2), hold on
plot(Sarasota{f,3}+3*rand(1,length(VTesti)),nanmean(VTesti),'bv')
plot(Sarasota{f,3}+3*rand(1,length(VTi_rest)),VTi_rest,'rv')
plot(Sarasota{f,3}+3*rand(1,length(VTi_swim)),VTi_swim,'kv')
plot(Sarasota{f,3}+3*rand(1,length(VTi)),VTi,'k.')

M = 160:300; % range of masses
TLCest = 0.135*M.^0.92; % TLCestimate from Kooyman 1973
plot(M,TLCest,'k--')
plot(M,(7.69/1000)*M,'k:') %Stahl


if f == 16
    % load vt and mb
    importVTlit
   
    for i = 1:length(vt_err)
        plot([mb(i) mb(i)],[vt(i)+vt_err(i) vt(i)-vt_err(i)],'k')
    end
    plot(mb,vt,'ko','markerfacecolor','w')
    
    for i = 1:length(vtin)
        plot([mb(i) mb(i)],[vtin(i)+vtin_err(i) vtin(i)-vtin_err(i)],'b')
    end
    plot(mb,vtin,'ko','markerfacecolor','b')
    
    for i = 1:length(vt_chuff)
        plot([mb(i) mb(i)],[vt_chuff(i)+vt_chuff_err(i) vt_chuff(i)-vt_chuff_err(i)],'r')
    end
    plot(mb,vt_chuff,'ko','markerfacecolor','r')
    
    % kooyman
    mbx = min(mb):max(mb);
    TLC = 0.135*(mbx).^0.92; % estimate from Kooyman
    plot(mbx,TLC,'k--')
    
    ylim([1 30])
end
