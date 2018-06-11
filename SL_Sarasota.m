% find Pxx in bands 
B1 = find(F<1000);
B2 = find(F>=2500 & F <= 3500);

figure(88), clf, hold on
mnflowI = nan(1,length(allstore));
mxflowI = nan(1,length(allstore));

for i = 1:length(allstore)
if ~isempty(allstore(i).Pxx_i)
    subplot(1,3,1:2), hold on
plot(mean(allstore(i).Pxx_i(B1)),allstore(i).mnflowI,'o')
plot(mean(allstore(i).Pxx_i(B2)),allstore(i).mnflowI,'o')
subplot(1,3,3), hold on
plot(mean(allstore(i).Pxx_i(B2))-mean(allstore(i).Pxx_i(B1)),allstore(i).mnflowI,'o')

mnflowI(i) = allstore(i).mnflowI; 
Pxx_i(i,1) = mean(allstore(i).Pxx_i(B1));
Pxx_i(i,2) = mean(allstore(i).Pxx_i(B2));
mxflowI(i) = min(allstore(i).flow); 
end
end
mxflowI(mxflowI == 0) = NaN; 

lm_mn = fitlm(Pxx_i(:,2)-Pxx_i(:,1), mnflowI);
lm_mx = fitlm(Pxx_i(:,2)-Pxx_i(:,1), mxflowI);

plot(lm_mn)
plot(lm_mx)
legend off 

% figure(89), clf, hold on 
% for i = 1:length(allstore)
% if ~isempty(allstore(i).Pxx_i)
%     subplot(1,3,1:2), hold on
% plot(mean(allstore(i).SL_i(B1)),allstore(i).mnflowI,'+')
% plot(mean(allstore(i).SL_i(B2)),allstore(i).mnflowI,'+')
% 
%     subplot(1,3,3), hold on
%   plot(mean(allstore(i).SL_i(B1))-mean(allstore(i).SL_i(B2)),allstore(i).mnflowI,'o')
%   
% end
% end

figure(89), clf, hold on 
plot(breath.cue(pon)/60,Pxx_i(:,1)-Pxx_i(:,2),'v')

q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
for i = 1:length(q) % rest, prior to release
plot(breath.cue(q(i))/60,mean(reststore(i).Pxx_i(B1))-mean(reststore(i).Pxx_i(B2)),'+')
% plot(breath.cue(q(i))/60,mean(reststore(i).Pxx_i(B2)),'+')
end

for i = 1:30 % free-swimming
    if ~isempty(surfstore(i).Pxxi)
plot(breath.cue(q20(i))/60,mean(surfstore(i).Pxxi(B1))-mean(surfstore(i).Pxxi(B2)),'+')
    end 
end

