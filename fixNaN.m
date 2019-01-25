fid = fopen(char('all_VTesti.txt'),'rt');
X = fread(fid); 
fclose(fid);
X = char(X.'); 
Y = strrep(X,'NaN',''); 
fid2 = fopen(char('all_VTesti.txt'),'wt');
fwrite(fid2,Y); 
fclose(fid2); 

