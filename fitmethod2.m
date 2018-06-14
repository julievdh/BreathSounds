sndi = extractfield(allstore,'soundi'); 
flwi = extractfield(allstore,'flowi');
% subsample
%inhflow = find(flw < -1);

figure(2), clf, hold on
plot(snd-min(sndi),-flwi,'o')
%plot(snd(inhflow)-min(snd(inhflow)),-flw(inhflow),'.')

% sndi = snd-min(snd);  
% flwi = flw; 
sndi(sndi == 0) = NaN; 
flwi = flwi(~isnan(sndi)); % remove NaNs in snVTdi 
sndi = sndi(~isnan(sndi)); % remove Nans in sndi

for kk = 1:500
chs = randi([1 length(sndi)],1,floor(length(sndi)/4)); % choose 25% of 

figure(339), 
plot(sndi(chs),-flwi(chs),'.')

[curvei,gofi] = fit(sndi(chs)',-flwi(chs)','a*x^b','robust','bisquare');
h = plot(curvei); legend off
h.LineWidth = 2; 

as(kk) = curvei.a;
bs(kk) = curvei.b;
rmse1(kk) = gofi.rmse; 
rsq1(kk) = gofi.rsquare; 

    VTest = NaN(2,length(CUE_R)); VTesti = NaN(2,length(CUE_R)); % initialize VT estimate from sound
    VTe2 = NaN(1,length(CUE_R)); VTi2 = NaN(1,length(CUE_R)); % initialize VT calculation from fow
    Sint1 = NaN(1,length(CUE_R)); Sint2 = NaN(1,length(CUE_R));
    if f == 22
        VTest = NaN(2,23); VTesti = NaN(2,23); % because of tag move
    end
    
    figure(19), clf, hold on
    for n = 1:length(CUE_R)
        if aligned(n) == 1,
            %%
            if size(allstore(n).soundi,2) > 1
                allstore(n).soundi = allstore(n).soundi';
            end
            
            %         ex = find(allstore(n).flow > 0);
            %         in = find(allstore(n).flow < -1);
            %         if isempty(in) == 0
            %             if isempty(ex) == 0
            %                 in = in(in > ex(1));  ex = ex(ex < in(1)); % no inhaled points prior to exhale, no exhaled points after inhale
            %             end
            %         end
            %
            % apply that relationship
            if sum(~isnan(allstore(n).soundi)) > 2 % if there are more than 2 entries
                allstore(n).sfill = naninterp(allstore(n).soundi);                           % interpolate NaNs
                allstore(n).sfill(find(allstore(n).sfill<0)) = 0;                           % zero out any negative values at the beginning
                allstore(n).sfill(find(allstore(n).sfill>max(allstore(n).soundi))) = 0;    % interpolation should never exceed max envelope
                if allstore(n).sfill(1) == 0;
                    allstore(n).sfill(1) = NaN;
                end
            else allstore(n).sfill = NaN(length(allstore(n).soundi),1);
            end
            % estimate flow from sound
            %allstore(n).Fest = a*(allstore(n).sfill).^b;
            % calculate error
            %allstore(n).erroro = rmse(allstore(n).Fest(ex),allstore(n).flow(ex)); % (mean(allstore(n).Fest(ex))-mean(allstore(n).flow(ex)));
            
            % calculate Sint as previously - just do it all together here
            %Sint1(n) = trapz(allstore(n).sound(ex)); % integral of filtered sound
            
            % for inhale
            ai = curvei.a; bi = curvei.b; 
            allstore(n).Festi = ai*(allstore(n).sfill).^bi;
            allstore(n).Festi(isinf(allstore(n).Festi)) = 0; % replace Inf with 0
            
            % calculate error
            gd = ~isnan(allstore(n).Festi); % find any NaNs
            allstore(n).errori = rmse(-allstore(n).flowi(gd),allstore(n).Festi(gd)); %(mean(allstore(n).flow(in))-mean(-allstore(n).Festi(in)));
            
            % estimate exh and inh tidal volume from flow
            %VTest(1,n) = trapz(allstore(n).Fest(ex))/(afs/dr);
            VTesti(1,n) = trapz(allstore(n).Festi(gd))/(afs/dr);
            
            % calculate VT from flow instead -- as a check
            VTi2(:,n) = trapz(allstore(n).flowi(gd))/(afs/dr);
            %VTe2(:,n) = trapz(allstore(n).flowe)/(afs/dr);
            
            allstore(n).mnflowE = mean(allstore(n).flowe);
            allstore(n).mnflowI = mean(allstore(n).flowi);
            %allstore(n).ex = ex; allstore(n).dex = length(ex)/(afs/dr);
            %allstore(n).in = in; allstore(n).din = length(in)/(afs/dr);
            
            plot(allstore(n).idxe,allstore(n).flowe)
            plot(allstore(n).idxi,allstore(n).flowi)
            %plot(allstore(n).idxe,allstore(n).Feste,'.')
            plot(allstore(n).idxi,-allstore(n).Festi,'.')
            
            % Second hydrophone if exists
            if isfield(allstore,'sound2') == 1
                if sum(~isnan(allstore(n).sound2)) > 2 % if there are more than 2 entries
                    % fill sound
                    allstore(n).sfill2 = naninterp(allstore(n).sound2);                   % interpolate NaNs
                    allstore(n).sfill2(find(allstore(n).sfill2<0)) = 0;                           % zero out any negative values at the beginning
                    allstore(n).sfill2(find(allstore(n).sfill2>max(allstore(n).sound2))) = 0;    % interpolation should never exceed max envelope
                    
                    allstore(n).Fest2 = a*(allstore(n).sfill2).^b;
                    allstore(n).erroro2 = (mean(allstore(n).Fest2(ex))-mean(allstore(n).flow(ex)));
                    allstore(n).Festi2 = ai*(allstore(n).sfill2).^bi;
                    allstore(n).Festi2(isinf(allstore(n).Festi2)) = 0;
                    allstore(n).errori2 = (mean(allstore(n).flow(in))-mean(-allstore(n).Festi2(in)));
                    
                    % estimate exh and inh tidal volume from flow
                    VTest(2,n) = trapz(allstore(n).Fest2(ex))/(afs/dr);
                    VTesti(2,n) = trapz(allstore(n).Festi2(in))/(afs/dr);
                    
                    Sint2(n) = trapz(allstore(n).sound2(ex)); % integral of filtered sound
                    
                    plot(ex,allstore(n).Fest2(ex),'.')
                    plot(in,-allstore(n).Festi2(in),'.')
                end
            end
            % pause
        end
    end
    figure(331), hold on 
    plot(VTesti(1,:)--VTi2)
    VTrmse2(kk) = rmse(VTesti(1,:),-VTi2); 
end

xlabel('Sound'), ylabel('Flow (L/s)')
adjustfigurefont

%% plot all vs. standard method
figure(49), clf
subplot(2,2,1), hold on 
plot(as2), plot(as)
ylabel('a'), xlim([0 500])
subplot(2,2,2), hold on 
plot(bs2), plot(bs)
ylabel('b'), xlim([0 500])
subplot(2,2,3), hold on 
plot(rsq2), plot(rsq)
xlabel('Iteration'), ylabel('R^2'), xlim([0 500])
subplot(2,2,4), hold on 
plot(rmse2), plot(rmse1)
xlabel('Iteration'), ylabel('RMSE (L/s)'), xlim([0 500])
legend('Fit Breaths','Fit Points')

print([cd '\AnalysisFigures\FitCompare_' tag],'-dpng','-r300')

figure(50), clf, hold on 
plot(VTrmse), plot(VTrmse2)
xlabel('Iteration'), ylabel('RMSE on Inhaled VT') 
legend('Fit Breaths','Fit Points')

print([cd '\AnalysisFigures\FitCompare2_' tag],'-dpng','-r300')