clear;
addpath('../post');
runnum='8213';Nsnap=59;SofteningHalo=3.3;

datadir=['/mnt/A4700/data/',runnum,'/subcat/anal/subparticles/'];
s1=load([datadir,'subparticle_059_6311']);
s2=load([datadir,'subparticle_059_6317']);

figure;
plot(s1(1:2:end,1),s1(1:2:end,2),'.','markersize',2);
hold on;
plot(s2(1:1:end,1),s2(1:1:end,2),'r.','markersize',2);
% plot([3.675e4,3.725e4],[7.65e4,7.65e4],'k-');
% plot([3.675e4,3.675e4],[7.649e4,7.651e4],'k-');
% plot([3.725e4,3.725e4],[7.649e4,7.651e4],'k-');
% text(3.68e4,7.66e4,'0.5Mpc/h');
% set(gca,'xtick',[],'ytick',[]);
axis equal;
% axis([3.5e4,3.75e4,7.64e4,7.89e4]);
% plot(s3(:,1),s3(:,2),'ko','markersize',5);
% plot(s4(:,1),s4(:,2),'co','markersize',5);
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
% print('-depsc',[outputdir,'/suboverlap.eps']);

%%
clear;
addpath('../post');
runnum='8213';Nsnap=59;SofteningHalo=3.3;

datadir=['/mnt/A4700/data/',runnum,'/subcatS/anal/subparticles/'];
s1=load([datadir,'subparticle_059_2196']);
s2=load([datadir,'subparticle_059_2227']);
s3=load([datadir,'subparticle_059_2428']);
s4=load([datadir,'subparticle_059_2783']);
datadir=['/mnt/A4700/data/',runnum,'/subcat/anal/subparticles/'];
s22=load([datadir,'subparticle_059_2576']);

figure;
plot(s1(1:5:end,3),s1(1:5:end,2),'.','markersize',2);
hold on;
% plot(s22(1:5:end,3),s22(1:5:end,2),'c.','markersize',2);
plot(s2(1:1:end,3),s2(1:1:end,2),'r.','markersize',2);
% plot([3.675e4,3.725e4],[7.65e4,7.65e4],'k-');
% plot([3.675e4,3.675e4],[7.649e4,7.651e4],'k-');
% plot([3.725e4,3.725e4],[7.649e4,7.651e4],'k-');
% text(3.68e4,7.66e4,'0.5Mpc/h');
set(gca,'xtick',[],'ytick',[]);
axis equal;
% axis([3.5e4,3.75e4,7.64e4,7.89e4]);
plot(s3(:,3),s3(:,2),'ko','markersize',5);
plot(s4(:,3),s4(:,2),'co','markersize',5);
outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
% print('-depsc',[outputdir,'/suboverlap.eps']);