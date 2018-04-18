% Determine effect of depth for a given tow

% So your model is:
%     Y = b x**c exp(e)
%
% (i.e., a power model with multiplicative lognormal error).  This can be log transformed:
%
%     log Y = d + c * log x + e
%
% which is a simple linear regression of log Y on log x.  Here, d = log b.
% Each 'experiment' consists of trials at 3 different depths.
% The first problem is to test the null hypothesis that there is no difference between depths -
% that is, that d and c are the same for all 3 depths.
% To test this, you would:


% load data
close all; clear all; clc

% load data
cd /Users/julievanderhoop/Documents/MATLAB/TOW/ExportFiles
load('TOWDRAG')
cd /Users/julievanderhoop/Documents/MATLAB/

% gear set number
for n = 1:21
    
    
    close all
    
    %% 1.  pool the data for all 3 depths, fit the model, and record the residual sum of squares - call this RSSo
    % RSS = SSE (same thing): sum over (y - yhat)^2
    [yfit(:,n),speed,coefs(:,n),sse(:,n)] = towfit_power([TOWDRAG(n).mn_speed' TOWDRAG(n).mn_dragN]);
    
    RSSo = sse(n);
    
    %% 2.  fit the model separately to each depth and record the sum of the residual sums of squares. Sum of each model's RSS = RSS1
    
    [yfit0(:,n),speed,coeffs0(:,n),sse0(:,n)] = towfit_power([TOWDRAG(n).mn_speed(1:3)' TOWDRAG(n).mn_dragN(1:3)]);
    [yfit3(:,n),speed,coeffs3(:,n),sse3(:,n)] = towfit_power([TOWDRAG(n).mn_speed(4:6)' TOWDRAG(n).mn_dragN(4:6)]);
    [yfit6(:,n),speed,coeffs6(:,n),sse6(:,n)] = towfit_power([TOWDRAG(n).mn_speed(7:9)' TOWDRAG(n).mn_dragN(7:9)]);
    
    RSS1 = sse0(:,n) + sse3(:,n) + sse6(:,n);
    
    legend('Pooled','Pooled','0m','0 m','3 m','3 m','6 m','6 m','Location','NW')
    title(regexprep(TOWDRAG(n).filename,'_',' '))
    xlabel('Speed (m/s)'); ylabel('Drag (N)')
    
    %% 3.  form the F statistic:
    %     F = ((RSSo - RSS1)/4) / (RSS1/(n - 6))
    % where n is the total number of data points (as I recall, n = 9)
    
    F = ((RSSo - RSS1)/4) / (RSS1/(9-6));
    
    %% 4.  reject the null hypothesis of no difference at significance level alpha
    % if F exceeds the upper alpha-quantile of the F distribution with 4 degrees of freedom in the numerator
    % and n - 6 degrees of freedom in the denominator.
    
    % compute critical value
    crit = finv((1-0.05),4,3);
    
    % reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
    % (do not reject)
    h(n) = F>crit;
    
    p(n) = 1-fcdf(F,4,3);
    
    figure(1)
    text(1.6, 25, num2str(h(n)))
    
    % pause
    
end




%% 5. For those where Ho is rejected, do pairwise comparisons

reject = find(h);

for i = 1:length(reject)
    
    n = reject(i);
    %%
    % 0 and 3
    % pool data
%     [yfit03(:,i),speed,coeffs03(:,i),RSSo] = towfit_power([TOWDRAG(reject(i)).mn_speed(1:6)' TOWDRAG(reject(i)).mn_dragN(1:6)]);
%     
%     % RSSo = rss of pooled data
%     
%     % compute RSS if fit separately
%     RSS1 = sse0(:,reject(i)) + sse3(:,reject(i));
%     
%     % compute F statistic
%     F = ((RSSo - RSS1)/2) / (RSS1/(6-4));
%     
%     % calculate critical value w/ bonferroni correction
%     crit = finv((1-(0.05/3)),2,2);
%     
%     % does F exceed critical value?
%     h03(i) = F>crit;
%     
%     % 3 and 6
%     % pool data
%     [yfit36(:,i),speed,coeffs36(:,i),RSSo] = towfit_power([TOWDRAG(reject(i)).mn_speed(4:9)' TOWDRAG(reject(i)).mn_dragN(4:9)]);
%     
%     % compute RSS if fit separately
%     RSS1 = sse3(:,reject(i)) + sse6(:,reject(i));
%     
%     % compute F statistic
%     F = ((RSSo - RSS1)/2) / (RSS1/(6-4));
%     
%     h36(i) = F>crit;
%     

% compare only 0m and 6m as these are shallowest and deepest, minimizes
% number of pairwise comparisons, increases power.

    % 0 and 6
    % pool data
    [yfit06(:,n),speed,coeffs06(:,n),RSSo] = towfit_power([[TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]' [TOWDRAG(n).mn_dragN(1:3); TOWDRAG(n).mn_dragN(7:9)]]);
    
    % compute pooled RSS
    RSS1 = sse0(:,n) + sse6(:,n);
    
    % compute F statistic
    F = ((RSSo - RSS1)/2) / (RSS1/(6-4));
    
    % critical value with NO BONFERRONI CORRECTION
    crit = finv((1-0.05),2,2);
    
    h06(i) = F>crit;
    
    p06(i) = 1-fcdf(F,2,2);
    
    % pause
    
end

%% plot these ones where significant pairwise difference between 0 and 6 m

% find where significant differences
reject = reject(find(h06));

for i = 1:length(reject)
    
    n = reject(i);
    figure(1); clf

[yfit06(:,i),speed,coeffs06(:,i),RSSo] = towfit_power([[TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]' [TOWDRAG(n).mn_dragN(1:3); TOWDRAG(n).mn_dragN(7:9)]]);
[yfit0(:,i),speed,coeffs0(:,i),sse0(:,i)] = towfit_power([TOWDRAG(n).mn_speed(1:3)' TOWDRAG(n).mn_dragN(1:3)]);
[yfit6(:,i),speed,coeffs6(:,i),sse6(:,i)] = towfit_power([TOWDRAG(n).mn_speed(7:9)' TOWDRAG(n).mn_dragN(7:9)]);

xlabel('Speed (m/s)'); ylabel('Drag (N)')
title(regexprep(TOWDRAG(n).filename,'_',' '))
box on
legend('0 and 6','0 and 6','0 only','0 only','6 only','6 only')
adjustfigurefont

end


 
%% 6. Fix slope == 2 and test for intercept difference?
% 
% % DO FOR first one: reject(1) = 6
% for i = 1:4
% n = reject(i)
% 
% % calculate lin fit for 0 3 and 6 m depths
% ylinhat0 = coeffs0(1,n)*log(TOWDRAG(n).mn_speed(1:3))+coeffs0(2,n);
% 
% % calculate residuals and SSE
% resid0 = (log(TOWDRAG(n).mn_dragN(1:3)) - ylinhat0');
% sse_0 = sum(real(resid0).^2);
% 
% % calculate lin fit for with fixed slope = 2
% % for separate depths
% ylinhat0_fixedslope = 2*log(TOWDRAG(n).mn_speed(1:3)+coeffs0(2,n));
% ylinhat3_fixedslope = 2*log(TOWDRAG(n).mn_speed(4:6)+coeffs3(2,n));
% ylinhat6_fixedslope = 2*log(TOWDRAG(n).mn_speed(7:9)+coeffs6(2,n));
% 
% % calculate residuals and SSE
% resid0_fs = (log(TOWDRAG(n).mn_dragN(1:3)) - ylinhat0_fixedslope');
% sse_0_fs = sum(real(resid0_fs).^2);
% resid3_fs = (log(TOWDRAG(n).mn_dragN(4:6)) - ylinhat3_fixedslope');
% sse_3_fs = sum(real(resid3_fs).^2);
% resid6_fs = (log(TOWDRAG(n).mn_dragN(7:9)) - ylinhat6_fixedslope');
% sse_6_fs = sum(real(resid6_fs).^2);
% 
% % for pooled: 0 and 3, 3 and 6, 0 and 6
% ylinhat03_fixedslope = 2*log(TOWDRAG(n).mn_speed(1:6)+coeffs03(2,i));
% ylinhat36_fixedslope = 2*log(TOWDRAG(n).mn_speed(4:9)+coeffs36(2,i));
% ylinhat06_fixedslope = 2*log([TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]+coeffs06(2,i));
% 
% % calculate residuals and SSE
% resid03_fs = (log(TOWDRAG(n).mn_dragN(1:6)) - ylinhat03_fixedslope');
% sse_03_fs = sum(real(resid03_fs).^2);
% resid36_fs = (log(TOWDRAG(n).mn_dragN(4:9)) - ylinhat36_fixedslope');
% sse_36_fs = sum(real(resid36_fs).^2);
% resid06_fs = (log([TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]) - ylinhat06_fixedslope);
% sse_06_fs = sum(real(resid06_fs).^2);
% 
% % calculate Fs
% F(:,1) = ((sse_03_fs - (sse_0_fs+sse_3_fs))/2) / ((sse_0_fs+sse_3_fs)/(6-4));
% F(:,2) = ((sse_36_fs - (sse_3_fs+sse_6_fs))/2) / ((sse_3_fs+sse_6_fs)/(6-4));
% F(:,3) = ((sse_06_fs - (sse_0_fs+sse_6_fs))/2) / ((sse_0_fs+sse_6_fs)/(6-4));
% 
% F>crit
% end
% 
% %% 7. fix intercept == 1 and test for difference in slope?
% 
% % DO FOR first one: reject(1) = 6
% for i = 1:4
% n = reject(i)
% 
% % calculate lin fit for with fixed slope = 2
% % for separate depths
% ylinhat0_fixedint = coeffs0(1,n)*log(TOWDRAG(n).mn_speed(1:3)+2);
% ylinhat3_fixedint = coeffs3(1,n)*log(TOWDRAG(n).mn_speed(4:6)+2);
% ylinhat6_fixedint = coeffs6(1,n)*log(TOWDRAG(n).mn_speed(7:9)+2);
% 
% % calculate residuals and SSE
% resid0_fi = (log(TOWDRAG(n).mn_dragN(1:3)) - ylinhat0_fixedint');
% sse_0_fi = sum(real(resid0_fi).^2);
% resid3_fi = (log(TOWDRAG(n).mn_dragN(4:6)) - ylinhat3_fixedint');
% sse_3_fi = sum(real(resid3_fi).^2);
% resid6_fi = (log(TOWDRAG(n).mn_dragN(7:9)) - ylinhat6_fixedint');
% sse_6_fi = sum(real(resid6_fi).^2);
% 
% % for pooled: 0 and 3, 3 and 6, 0 and 6
% ylinhat03_fixedint = coeffs03(1,i)*log(TOWDRAG(n).mn_speed(1:6)+2);
% ylinhat36_fixedint = coeffs36(1,i)*log(TOWDRAG(n).mn_speed(4:9)+2);
% ylinhat06_fixedint = coeffs06(1,i)*log([TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]+2);
% 
% % calculate residuals and SSE
% resid03_fi = (log(TOWDRAG(n).mn_dragN(1:6)) - ylinhat03_fixedint');
% sse_03_fi = sum(real(resid03_fi).^2);
% resid36_fi = (log(TOWDRAG(n).mn_dragN(4:9)) - ylinhat36_fixedint');
% sse_36_fi = sum(real(resid36_fi).^2);
% resid06_fi = (log([TOWDRAG(n).mn_speed(1:3) TOWDRAG(n).mn_speed(7:9)]) - ylinhat06_fixedint);
% sse_06_fi = sum(real(resid06_fi).^2);
% 
% % calculate Fs
% F(:,1) = ((sse_03_fi - (sse_0_fi+sse_3_fi))/2) / ((sse_0_fi+sse_3_fi)/(6-4));
% F(:,2) = ((sse_36_fi - (sse_3_fi+sse_6_fi))/2) / ((sse_3_fi+sse_6_fi)/(6-4));
% F(:,3) = ((sse_06_fi - (sse_0_fi+sse_6_fi))/2) / ((sse_0_fi+sse_6_fi)/(6-4));
% 
% F>crit
% end
% 
% %
% % %% 6. Plot to illustrate which are rejected (white) and not rejected (black)
% % figure
% % imagesc(h); colormap gray
% % title('White = reject; Black = do not reject')
% % set(gca,'Gridlinestyle','-','XGrid','on','YGrid','on')
% % set(gca,'Xtick',[0.5 1.5 2.5],'Ytick',[0.5:1:20.5])
% %
% % % illustrate slope and intercept differences from pooled
% % figure(4)
% % subplot(211); hold on
% % for n = 1:15
% % plot([0 3 6],[diff0(1,n) diff3(1,n) diff6(1,n)],'.-')
% % end
% % title('Slope')
% % subplot(212); hold on
% % for n = 1:15
% % plot([0 3 6],[diff0(2,n) diff3(2,n) diff6(2,n)],'.-')
% % end
% % title('Intercept')
% %
% % %% 7. Plot only those that are different (h = 1)
% %
% % % find entries of h that are being rejected
% % % h(find(h))  are all ones
% %
% % ii = find(find(h) <= n);
% % reject = find(h);
% % reject0 = reject(ii);
% %
% % ii = find(find(h) > n & find(h) <= n*2);
% % reject = find(h);
% % reject3 = reject(ii)-n;
% %
% % ii = find(find(h) > n*2 & find(h) <= n*3);
% % reject = find(h);
% % reject6 = reject(ii)-n*2;
% %
% % figure(5)
% % subplot(131)
% % boxplot(diff0(:,reject0)')
% % ylim([-0.9 0.8])
% %
% % subplot(132)
% % boxplot(diff3(:,reject3)')
% % ylim([-0.9 0.8])
% %
% % subplot(133)
% % boxplot(diff6(:,reject6)')
% % ylim([-0.9 0.8])