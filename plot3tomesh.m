function [xq,yq,zq] = plot3tomesh(Px,Py,Pz,fig)
% plot mesh with three vectors
% reshapes for you and subsamples at default length/100 resolution

% create the grid 
X = linspace(min(Px),max(Px),100); 
Y = linspace(min(Py),max(Py),100);
[xq,yq] = meshgrid(X,Y); 
% interpolate the scattered data over the grid
ii = find(~isnan(mean([Px Py Pz]'))); % find all non-nans and keep only these 
zq = griddata(Px(ii),Py(ii),Pz(ii),xq,yq,'natural');
% plot the data together
figure(fig)
mesh(xq,yq,zq)
hold on
plot3(Px,Py,Pz,'o')