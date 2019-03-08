% plotMassVT

figure(2)
subplot(211), hold on
plot(Sarasota{f,3}+4*rand(1,length(VTesti)),nanmean(VTesti),'bv')
plot(Sarasota{f,3}+4*rand(1,length(VTi_rest)),VTi_rest,'rv')
plot(Sarasota{f,3}+4*rand(1,length(VTi_swim)),VTi_swim,'kv')
plot(Sarasota{f,3}+4*rand(1,length(find(VTi>1))),VTi(VTi>1),'k.')

M = 160:300; % range of masses
TLCest = 0.135*M.^0.92; % TLCestimate from Kooyman 1973
plot(M,TLCest,'k--')
plot(M,(7.69/1000)*M,'k:') %Stahl

subplot(212), hold on
% get TLC for individual
TLCind = 0.135*Sarasota{f,3}.^0.92;
plot(Sarasota{f,3}+4*rand(1,length(VTesti)),nanmean(VTesti)/TLCind,'bv')
plot(Sarasota{f,3}+4*rand(1,length(VTi_rest)),VTi_rest/TLCind,'rv')
plot(Sarasota{f,3}+4*rand(1,length(VTi_swim)),VTi_swim/TLCind,'kv')
plot(Sarasota{f,3}+4*rand(1,length(find(VTi>1))),VTi(VTi>1)/TLCind,'k.')


if f == 16
    % load vt and mb
    importVTlit
   subplot(211)
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
    plot(mbx,0.5*TLC,'k--')
    
    ylim([1 30])
    
    xlabel('Weight (kg)'), ylabel('Tidal Volume (L)')
    
    subplot(212), 
    xlabel('Weight (kg)'), ylabel('% TLC_{est}')
    xlim([50 300])
    adjustfigurefont
    set(gcf,'position',[360.3333   47.6667  560.0000  570.0000],'paperpositionmode','auto')
    print([cd '\AnalysisFigures\plotMassVT'],'-dpng')
end

