% plotMassVT

figure(2), hold on 
plot(Sarasota{f,3}+rand(1,length(VTesti)),nanmean(VTesti),'bv')
plot(Sarasota{f,3}+rand(1,length(VTi_rest)),VTi_rest,'rv')
plot(Sarasota{f,3}+rand(1,length(VTi_swim)),VTi_swim,'kv')
plot(Sarasota{f,3}+rand(1,length(VTi)),VTi,'k.')

M = 160:300; % range of masses
TLCest = 0.135*M.^0.92; % TLCestimate from Kooyman 1973
plot(M,TLCest,'k--')
plot(M,(7.69/1000)*M,'k:') %Stahl 

ylabel('Volume (L)')
xlabel('Body Mass (Kg)')