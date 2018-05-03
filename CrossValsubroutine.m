

VTest = NaN(size(f12.VTest)); VTesti = NaN(size(f12.VTest)); % initialize VT estimate from sound
% Sint1 = NaN(1,length(CUE_R)); Sint2 = NaN(1,length(CUE_R));

% extract fit info
%a = f12.fitinfo.a; ai = f12.fitinfo.ai; b = f12.fitinfo.b; bi = f12.fitinfo.bi; 
%afs = f12.afs; ffs = 1/diff(f12.cuts(1).flow(1:2,1));
%dr = round(afs/ffs); % decimation rate


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

% calculate VTerre and VTerri
VTerre = VTest(1,:) - f12.VTe;
VTerri = VTesti(1,:) - f12.VTi;

figure(5), hold on 
plot(VTerre)
plot(f12.VTerre')
plot(VTerri)
plot(f12.VTerri')

figure(3), clf 
set(gcf,'paperpositionmode','auto')
subplot(2,2,1), hold on 
plot(VTest(1,:),[f12(:).VTest(1,:)],'^')
plot(VTesti(1,:),[f12(:).VTesti(1,:)],'v')
xlabel('VT Estimate - Crossed'), ylabel('VT Estimate - Own')
plot([0 10],[0 10],'k:')
text(0.5,9,'A','FontSize',16,'FontWeight','Bold')


[~,pt(1),~,statt] = ttest(VTest(1,:)',f12.VTest(1,:)');
[~,pt(2),~,statt(2)] = ttest(VTesti(1,:)',f12.VTesti(1,:)');
% linear model here - error as a function of volume?

subplot(2,2,2), hold on 
plot(f12.VTe(~isnan([f12.VTest(1,:)])),[f12.allstore(:).erroro],'k^')
plot(f12.VTi(~isnan([f12.VTest(1,:)])),[f12.allstore(:).errori]','kv')

plot(f12.VTe,[f12.allstore2(:).erroro],'^')
plot(f12.VTi,[f12.allstore2(:).errori],'v')
xlabel('Measured Volume (L)'), ylabel('Mean Flow Error (L/s)')
xlim([0 10]), ylim([-20 20])
text(0.5,16,'B','FontSize',16,'FontWeight','Bold')

erroro1 = [f12.allstore(:).erroro]; 
erroro2 = [f12.allstore2(:).erroro];
erroro2(isnan(erroro2)) = []; 
errori1 = [f12.allstore(:).errori]; 
errori1(isnan(errori1)) = []; 
errori2 = [f12.allstore2(:).errori];
errori2(isnan(errori2)) = []; 


[~,pf(1),~,statf] = ttest(erroro1',erroro2');
[~,pf(2),~,statf(2)] = ttest(errori1',errori2');
mean(erroro2), mean(errori2)

subplot(2,2,3), hold on 
plot(VTest(1,:),[f12(:).VTe],'k^')%,'markerfacecolor','k')
plot(VTesti(1,:),[f12(:).VTi],'kv')%,'markerfacecolor','k')
plot([f12(:).VTest(1,:)],[f12(:).VTe],'^')
plot([f12(:).VTesti(1,:)],[f12(:).VTi],'v')
ylabel('Measured Volume (L)'), xlabel('Estimated volume (L)')
plot([0 10],[0 10],'k:')
text(0.5,9,'C','FontSize',16,'FontWeight','Bold')

% rmse
rmse(f12.VTe(~isnan(f12.VTest(1,:))),f12.VTest(1,~isnan(f12.VTest(1,:))))
rmse(f12.VTe(~isnan(VTest(1,:))),VTest(1,~isnan(VTest(1,:))))

% difference between the two 
dfe = f12.VTest(1,:)-VTest(1,:); 
dfi = f12.VTesti(1,:)-VTesti(1,:); 

[nanmean(dfe) nanstd(dfe)]; 
[nanmean(dfi) nanstd(dfi)];

pdfe = dfe./f12.VTest(1,:);
pdfi = dfi./f12.VTesti(1,:);

subplot(2,2,4), hold on 
plot(f12.VTe,pdfe*100,'^')
plot(f12.VTi,pdfi*100,'v')
xlabel('measured volume (L)'), ylabel('% Difference in Estimated VT')
xlim([0 10]),text(0.5,15,'D','FontSize',16,'FontWeight','Bold')

% compare variance of VT estimates 
[~,pvar(1),~,statvar(1)] = vartest2(VTest(1,:),f12.VTest(1,:)-VTest(1,:));
[~,pvar(2),~,statvar(2)] = vartest2(VTesti(1,:),f12.VTesti(1,:)-VTesti(1,:));

figure, hold on 
[ax1, ax2, ax3] = scatterhist3(f12.VTest(1,:),VTest(1,:),'^',1);
[ax1, ax2, ax3] = scatterhist3(f12.VTesti(1,:),VTesti(1,:),'v',1);
