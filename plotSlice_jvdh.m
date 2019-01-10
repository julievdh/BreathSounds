function [xs, y, yci] = plotSlice_jvdh(x,fitobj); 

in = fitobj.Formula.InModel;
d = fitobj.Variables;
vi = fitobj.VariableInfo;

if isa(d,'table')
    d = d(ones(size(x,1),1),:);
    vn = d.Properties.VariableNames;
    cols = find(in);
    for j=1:length(cols)
        vnum = cols(j);
        newdj = d.(vn{vnum});
        if vi.IsCategorical(vnum)
            range = vi.Range{cols(j)};
            for k=1:size(x,1)
                catnum = round(x(k,j));
                if iscell(range)
                    newdj(k) = range(catnum)';
                elseif ischar(range)
                    row = range(catnum,:);
                    newdj(k,:) = ' ';
                    newdj(k,1:length(row)) = row;
                else
                    newdj(k) = range(catnum);
                end
            end
        else
            newdj = x(:,j);
        end
        d.(vn{cols(j)}) = newdj;
    end
else
    d = zeros(size(x,1),length(in));
    d(:,in) = x;
end
args = {};
args(end+(1:2)) = {'Simultaneous' true};
[y,yci] = predict(fitobj,d,args{:});
xs = x(:,1); % save x 