%% To check which is the best representation of subhalo center, across cosmic time
% in general both the most-bound and the min-pot particle are good
% representation for the center, with min-pot particles have slightly larger dispersion;
% with only very rare occassions that
% min-pot particle can have substantial positional/velocity offset, i.e.,
% being ejected from the core.
% the velocity of min-pot particle also has low dispersion, ganranteed by
% the velocity dispersion profile (rho/sigma^3~r^alpha-->sigma~r^..., -->0
% as r-->0. i.e., the core is coherent and tight.
%%
cd /work/Projects/HBT/code/data/
% 
data=load('check_centers_120_1');
dataf=load('check_centers_120_1.final');
% data=load('check_centers_99_1');
% dataf=load('check_centers_99_1.final');
% dataf=reshape(dataf,numel(dataf)/13,13);
nsnap=data(:,1);
subid=data(:,2);
subrank=data(:,3);
bid=data(:,4);
pid=data(:,5);
xc=data(:,6:8);
vc=data(:,9:11);
xb=data(:,12:14);
xp=data(:,15:17);
vb=data(:,18:20);
vp=data(:,21:23);
xbf=dataf(:,2:4);
xpf=dataf(:,5:7);
vbf=dataf(:,8:10);
vpf=dataf(:,11:13);

%%
figure;
f=nsnap+1;
% plot(xc(f,1),xc(f,2),'.');
hold on;
plot(xbf(f,1),xbf(f,2),'o');
plot(xpf(f,1),xpf(f,2),'r*');
axis equal;

figure;
f=nsnap+1;
% plot(vc(f,1),vc(f,2),'.');
hold on;
plot(vbf(f,1),vbf(f,2),'o');
plot(vpf(f,1),vpf(f,2),'r*');
axis equal;
%%
figure;
x0=repmat(xc(1,:),numel(nsnap),1);
rc=sqrt(sum((xc-x0).^2,2));
rb=sqrt(sum((xbf-x0).^2,2));
rp=sqrt(sum((xpf-x0).^2,2));
% plot(nsnap,rc);
hold on;
plot(nsnap,rb,'o');
plot(nsnap,rp,'r*');
% set(gca,'yscale','log');

figure;
v0=repmat(vc(1,:),numel(nsnap),1);
rvc=sqrt(sum((vc-v0).^2,2));
rvb=sqrt(sum((vbf-v0).^2,2));
rvp=sqrt(sum((vpf-v0).^2,2));
plot(nsnap,rvc);
hold on;
plot(nsnap,rvb,'o');
plot(nsnap,rvp,'r*');
% set(gca,'yscale','log');