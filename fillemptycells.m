function mycellmat = fillemptycells(mycellarray)

emptyIndex = cellfun(@isempty,mycellarray);       %# Find indices of empty cells
mycellarray(emptyIndex) = {NaN};                    %# Fill empty cells with 0
% mylogicalarray = logical(cell2mat(mycellarray));  %# Convert the cell array
mycellmat = cell2mat(mycellarray); 

