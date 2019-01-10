%% Load in tag data
%% set path, tag

tag='tt14_125a';
path='E:\tt14\tt14_125a\';

[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt125a = load(strcat(tag,'_PQ'));
ZeroBreaths

%save R in tt125a structure
tt125a.R=R; 

%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_126y';
path = 'E:\tt14\tt14_126y\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt126y= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt126y.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_126z';
path = 'E:\tt14\tt14_126z\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt126z= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt126z.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_126x';
path = 'E:\tt14\tt14_126x\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt126x= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt126x.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_127z';
path = 'E:\tt14\tt14_127z\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt127z= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt127z.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_128z';
path = 'E:\tt14\tt14_128z\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt128z= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt128z.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_128y';
path = 'E:\tt14\tt14_128y\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt128y= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt128y.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_129z';
path = 'E:\tt14\tt14_129z\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt129z= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt129z.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_129y';
path = 'E:\tt14\tt14_129y\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt129y= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt129y.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_129x';
path = 'E:\tt14\tt14_129x\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt129x= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt129x.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_125b';
path = 'E:\tt14\tt14_125b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt125b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt125b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_126b';
path = 'E:\tt14\tt14_126b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt126b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt126b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_126a';
path = 'E:\tt14\tt14_126a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt126a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt126a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_128a';
path = 'E:\tt14\tt14_128a\';

% clear R
[R]=loadR(tag, path);

% %Load params
cd([path 'audit\'])
tt128a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt128a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_129a';
path = 'E:\tt14\tt14_129a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt129a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt129a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt14_129c';
path = 'E:\tt14\tt14_129c\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt129c= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt129c.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_267b';
path = 'D:\tt13\tt13_267b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt267b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt267b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_268c';
path = 'D:\tt13\tt13_268c\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt268c= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt268c.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_268d';
path = 'D:\tt13\tt13_268d\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt268d= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt268d.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_269b';
path = 'D:\tt13\tt13_269b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt269c= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt269c.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_271b';
path = 'D:\tt13\tt13_271b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt271b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt271b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_272a';
path = 'D:\tt13\tt13_272a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt272a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt272a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_273a';
path = 'D:\tt13\tt13_273a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt273a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt273a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_276a';
path = 'D:\tt13\tt13_276a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt276a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt276a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_276b';
path = 'D:\tt13\tt13_276b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt276b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt276b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_278a';
path = 'D:\tt13\tt13_278a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt278a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt278a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_279b';
path = 'D:\tt13\tt13_279b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt279b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt279b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_281a';
path = 'D:\tt13\tt13_281a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt281a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt281a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_282b';
path = 'D:\tt13\tt13_282b\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt282b= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt282b.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_283a';
path = 'D:\tt13\tt13_283a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt283a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt283a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_284a';
path = 'D:\tt13\tt13_284a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt284a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt284a.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_285d';
path = 'D:\tt13\tt13_285d\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt285d= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt285d.R=R;
%% load in next tag
% set path, tag
% change tag and path for different deployments
tag = 'tt13_288a';
path = 'D:\tt13\tt13_288a\';

clear R
[R]=loadR(tag, path);

%%Load params
cd([path 'audit\'])
tt288a= load(strcat(tag,'_PQ'));
   
% save R in tt126y structure
tt288a.R=R;