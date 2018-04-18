

VTest = NaN(size(f12.VTest)); VTesti = NaN(size(f12.VTest)); % initialize VT estimate from sound
% Sint1 = NaN(1,length(CUE_R)); Sint2 = NaN(1,length(CUE_R));

figure(19), clf, hold on
for n = 1:length(f12.allstore)
    % estimate flow from sound
    f12.allstore2(n).Fest = a*(f12.allstore(n).sfill).^b;
    ex = f12.allstore(n).ex; in = f12.allstore(n).in; % cause it's easier this way
    % calculate error - between estimated and measured
    f12.allstore2(n).erroro = (mean(f12.allstore2(n).Fest(ex))-mean(f12.allstore(n).flow(ex)));
    % between estimate 1 and estimate 2
    f12.allstore2(n).erroroF = (mean(f12.allstore2(n).Fest(ex))-mean(f12.allstore(n).Fest(ex)));
    
    plot(f12.allstore(n).Fest)
    plot(f12.allstore2(n).Fest)
    
    % for inhale
    f12.allstore2(n).Festi = ai*(f12.allstore(n).sfill).^bi;
    f12.allstore2(n).Festi(isinf(f12.allstore2(n).Festi)) = 0; % replace Inf with 0
    
    % calculate error - between estimated and measured
    f12.allstore2(n).errori = (mean(f12.allstore(n).flow(in))-mean(-f12.allstore2(n).Festi(in)));
    f12.allstore2(n).erroriF = (mean(f12.allstore2(n).Festi(in))-mean(f12.allstore(n).Festi(in)));
        
    % estimate exh and inh tidal volume from flow
    VTest(1,n) = trapz(f12.allstore2(n).Fest(ex))/(afs/dr);
    VTesti(1,n) = trapz(f12.allstore2(n).Festi(in))/(afs/dr);
    
end

% remove outliers 
VTesti(VTesti < 0.5) = NaN; VTesti(VTesti > 25) = NaN;  
VTest(VTest < 0.5) = NaN; VTest(VTest > 25) = NaN; 


figure(3), clf 
subplot(2,2,1), hold on 
plot(VTest,[f12(:).VTest],'^')
plot(VTesti,[f12(:).VTesti],'v')
xlabel('other relationship'), ylabel('proper relationship')
plot([0 10],[0 10],'k:')

[~,pt(1),~,statt] = ttest(VTest(1,:),f12.VTest(1,:));
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:),f12.VTesti(1,:));

% linear model here - error as a function of volume

subplot(2,2,2), hold on 
plot(f12.VTe(~isnan([f12.VTest(1,:)])),[f12.allstore(:).erroro],'^')
plot(f12.VTi(~isnan([f12.VTest(1,:)])),[f12.allstore(:).errori]','v')

plot(f12.VTe,[f12.allstore2(:).erroro],'^')
plot(f12.VTi,[f12.allstore2(:).errori],'v')
xlabel('measured volume (L)'), ylabel('mean flow error - meas vs est')

[~,pf(1),~,statf] = ttest2([f12.allstore(:).erroro],[f12.allstore2(:).erroro]);
[~,pf(2),~,statf(2)] = ttest2([f12.allstore(:).errori],[f12.allstore2(:).errori]);


subplot(2,2,3), hold on 
plot(VTest,[f12(:).VTe],'^','markerfacecolor','k')
plot(VTesti,[f12(:).VTi],'v','markerfacecolor','k')
plot([f12(:).VTest],[f12(:).VTe],'^')
plot([f12(:).VTesti],[f12(:).VTi],'v')
ylabel('measured volume (L)'), xlabel('estimated volume (L)')
plot([0 10],[0 10],'k:')

subplot(2,2,4), hold on 
plot(f12.VTe,[f12.allstore2(:).erroroF],'^')
plot(f12.VTi,[f12.allstore2(:).erroriF],'v')
xlabel('measured volume (L)'), ylabel('mean flow error - est1 vs est2 (L/s)')

% rmse
rmse(f12.VTe(~isnan(f12.VTest(1,:))),f12.VTest(1,~isnan(f12.VTest(1,:))))
rmse(f12.VTe(~isnan(VTest(1,:))),VTest(1,~isnan(VTest(1,:))))

