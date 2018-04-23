% SL is source level in different frequency bands

RES = [];
width = 1000;
lowc =  width/2:100:2000-width;
highc = 2000-width:100:8000;
for i = 1:length(lowc) % all low bands
    for j = 1:length(highc) % across all high bands
        for k = 1:size(SL_o,2)
            SLlow_o(k) = mean(SL_o(F>lowc(i)-width/2 & F <lowc(i)+width/2,k));
            SLhigh_o(k) = mean(SL_o(F>highc(j)-width/2 & F <highc(j)+width/2,k));
        end
        if exist('minflow') == 1
        [~,RES(j,i)] = evalcorr(SLhigh_o(pon3)-SLlow_o(pon3),[minflow{:}],0,'g',0);
        else 
            [~,RES(j,i)] = evalcorr(SLhigh_o(pon3)-SLlow_o(pon3),all_SUMMARYDATA(pnum,4)',0,'g',0);
        end
    end
end

figure(10)
mesh(lowc,highc,RES)
xlabel('Low component, Hz'), ylabel('High component, Hz'), zlabel('R^2')

[m,ind] = max(max(RES));
bestlow = lowc(ind);
[m,ind2] = max(RES);
besthigh = highc(ind2(ind));


% recompute SL with the best bands, for both inhales and exhales
for k = 1:size(SL_o,2)
    SLlow_o(k) = mean(SL_o(F>bestlow-width/2 & F <bestlow+width/2,k));
    SLhigh_o(k) = mean(SL_o(F>besthigh-width/2 & F <besthigh+width/2,k));
    if exist('SL_i') == 1 % only if also have exhales
    SLlow_i(k) = mean(SL_i(F>bestlow-width/2 & F <bestlow+width/2,k));
    SLhigh_i(k) = mean(SL_i(F>besthigh-width/2 & F <besthigh+width/2,k));
    end 
end

SLdiff_o = SLlow_o - SLhigh_o;
