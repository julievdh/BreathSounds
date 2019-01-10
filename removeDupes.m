%remove duplicate breaths
 [a,ii] = sort(breath.cue);
    a([false(1,size(a,2));diff(a) == 0]) = NaN;
    [~,i1] = sort(ii);
    out = a(sub2ind(size(breath.cue),i1,ones(size(breath.cue,1),1)*(1:size(breath.cue,2)))); 
    breath.cue = breath.cue(~isnan(out(:,1)),:);
    breath.stype = breath.stype(~isnan(out(:,1)));

    