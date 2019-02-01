function fixNaN(filename)
fid = fopen(char(filename),'rt');
X = fread(fid); 
fclose(fid);
X = char(X.'); 
Y = strrep(X,'NaN',''); 
fid2 = fopen(char(filename),'wt');
fwrite(fid2,Y); 
fclose(fid2); 

