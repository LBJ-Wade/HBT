global HUBBLE0 G RUN_NUM snapdir fofdir subcatdir outputdir
HUBBLE0=0.1;G=43007.1;RUN_NUM=6120
snapdir='/data/A4700r3d1/ypjing'
fofdir='/data/A4700r2d2/ypjing/fofcat'
subcatdir='/data/A4700r2d1/kambrain/6120/subcat'
outputdir=[subcatdir,'/anal']

global Pdat header snaplist;
Pdat=struct('PID',[],'Pos',[],'Vel',[],'snap',-1);
header=struct('Np',0,'ips',0,'z',0,'Omegat',0,'Lambdat',0,'rLbox',0,'xscale',0,'vscale',0,'Hz',0,'vunit',0,'mass',zeros(2,1),'time',0,'snap',-1);

snaplist=[247,256,266, 275 , 285 , 295 ,305,  316,  327,...
338 , 350 , 362 , 374,  387,  399,  413,  427,  441,  455,  470,  485,  ...
501,  517,  534,  551,  569,  587,  605,  625,  644,  665,  685,  707, ... 
729,  752,  775,  799,  824,  849,  875,  902,  929,  958,  987, 1017, ...
1048, 1080, 1112, 1146, 1180, 1216, 1252, 1290, 1328, 1368, 1409 ,1451, 1494, 1539, 1584,...
1631, 1679, 1729, 1780, 1833, 1887, 1942, 2000, 2058, 2119, 2181, 2245, 2310, 2378, 2448, ...
2519, 2593, 2668, 2746, 2826, 2908, 2993, 3080, 3169, 3261, 3356, 3453, 3553, 3656, 3762,...
3871, 3982, 4098, 4216, 4338, 4463, 4591, 4724, 4860, 5000];
