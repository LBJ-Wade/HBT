clear;
addpath('../post');

runnum='8213';Nsnap=59;
TIDALMAX=2;

datadir=['/mnt/A4700/data/',runnum,'/subcat/profile/'];
basedir='logbin/aqua';
sizefile=fullfile(datadir,basedir,['sat_size_',num2str(Nsnap,'%03d'),'.',num2str(TIDALMAX)]);
btsize=load_subsize(sizefile);

datadir=['/mnt/A4700/data/',runnum,'/subcatS/profile/'];
basedir='logbin/aqua';
sizefile=fullfile(datadir,basedir,['sat_size_',num2str(Nsnap,'%03d'),'.',num2str(TIDALMAX)]);
sfsize=load_subsize(sizefile);

f=@(x) x.*(3*(log(1+x)-x./(1+x))-(x./(1+x)).^2).^(-1.0/3);%ritdal_sub/rvir_sub as a function of rcen_sub/rs_host
%%
nplotBT=1:btsize.nsubs;
nplotBT=nplotBT(~btsize.flag_badbins(nplotBT)&logical(btsize.rcen(nplotBT)));%all the satellites
nplotSF=1:sfsize.nsubs;
nplotSF=nplotSF(~btsize.flag_badbins(nplotSF)&logical(btsize.rcen(nplotSF)));%all the satellites
%==calculate median line==%
x=logspace(1,3,10);
[n,bin]=histc(btsize.rtidal(nplotBT),x);
bty1=zeros(9,1);bty02=bty1;btxm=bty1;
for i=1:9
bty1(i)=median(btsize.req_all_1(nplotBT(bin==i)));
bty02(i)=median(btsize.req_all_02(nplotBT(bin==i)));
btxm(i)=median(btsize.rtidal(nplotBT(bin==i)));
end
x=logspace(1,3,10);[n,bin]=histc(sfsize.rtidal(nplotSF),x);
sfy1=zeros(9,1);sfy02=sfy1;sfxm=sfy1;
for i=1:9
sfy1(i)=median(sfsize.req_all_1(nplotSF(bin==i)));
sfy02(i)=median(sfsize.req_all_02(nplotSF(bin==i)));
sfxm(i)=median(sfsize.rtidal(nplotSF(bin==i)));
end
%===plots===%
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on',...
    'DefaultTextInterpreter','latex');
set(gcf,'DefaultLineMarkerSize',5);
set(gcf,'DefaultTextFontName','Helvetica','DefaultTextFontSize',20);
axes('position',[.1,.5,.4,.4]);loglog(btsize.rtidal(nplotBT),btsize.req_all_1(nplotBT),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req/(kpc/h)$');set(gca,'xaxislocation','top','xtick',[10,100],'ytick',[10,100]);axis([10,1e3,10,1e3]);text(14,500,'HBT');
loglog(btxm,bty1,'r');
axes('position',[.5,.5,.4,.4]);loglog(sfsize.rtidal(nplotSF),sfsize.req_all_1(nplotSF),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req/(kpc/h)$');set(gca,'xaxislocation','top','xtick',[10,100,1000],'yaxislocation','right');axis([10,1e3,10,1e3]);text(14,500,'SUBFIND');
loglog(sfxm,sfy1,'r');
axes('position',[.1,.1,.4,.4]);loglog(btsize.rtidal(nplotBT),btsize.req_all_02(nplotBT),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req_{0.02}/(kpc/h)$');axis([10,1e3,10,1e3]);set(gca,'ytick',[10,100],'xtick',[10,100]);xlabel('$Rtidal/(kpc/h)$');text(14,500,'HBT');
loglog(btxm,bty02,'r');
loglog(sfxm,sfy02,'--','linewidth',3,'color','g');
axes('position',[.5,.1,.4,.4]);loglog(sfsize.rtidal(nplotSF),sfsize.req_all_02(nplotSF),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req_{0.02}/(kpc/h)$');set(gca,'yaxislocation','right','ytick',[10,100],'xtick',[10,100,1000]);axis([10,1e3,10,1e3]);text(14,500,'SUBFIND');
xlabel('$Rtidal/(kpc/h)$');
loglog(sfxm,sfy02,'r');

set(gcf,'paperposition',[0.6,6,20,18]);
outputdir='/home/kam/Projects/HBT/code/data/show';
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
print('-depsc',[outputdir,'/subsize_aqua_',runnum,'.',num2str(TIDALMAX),'.eps']);
%%
clear;
addpath('../post');

TIDALMAX=2;
runnum='6702DM';Nsnap=99;

datadir=['/mnt/A4700/data/',runnum,'/subcat/profile/'];
basedir='logbin/aqua';
sizefile=fullfile(datadir,basedir,['sat_size_',num2str(Nsnap,'%03d'),'.',num2str(TIDALMAX)]);
btsize=load_subsize(sizefile);

datadir=['/mnt/A4700/data/',runnum,'/subcatS/profile/'];
basedir='logbin/aqua';
sizefile=fullfile(datadir,basedir,['sat_size_',num2str(Nsnap,'%03d'),'.',num2str(TIDALMAX)]);
sfsize=load_subsize(sizefile);
%%
% req_02 for SUBFIND is 20~30 percent smaller than HBT
nplotBT=1:btsize.nsubs;
nplotBT=nplotBT(~btsize.flag_badbins(nplotBT)&logical(btsize.rcen(nplotBT)));%all the satellites
nplotSF=1:sfsize.nsubs;
nplotSF=nplotSF(~btsize.flag_badbins(nplotSF)&logical(btsize.rcen(nplotSF)));%all the satellites
%==calculate median line==%
x=logspace(1,3,10);
[n,bin]=histc(btsize.rtidal(nplotBT),x);
bty1=zeros(9,1);bty02=bty1;btxm=bty1;
for i=1:9
bty1(i)=median(btsize.req_all_1(nplotBT(bin==i)));
bty02(i)=median(btsize.req_all_02(nplotBT(bin==i)));
btxm(i)=median(btsize.rtidal(nplotBT(bin==i)));
end
x=logspace(1,3,10);[n,bin]=histc(sfsize.rtidal(nplotSF),x);
sfy1=zeros(9,1);sfy02=sfy1;sfxm=sfy1;
for i=1:9
sfy1(i)=median(sfsize.req_all_1(nplotSF(bin==i)));
sfy02(i)=median(sfsize.req_all_02(nplotSF(bin==i)));
sfxm(i)=median(sfsize.rtidal(nplotSF(bin==i)));
end
%===plots===%
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on',...
    'DefaultTextInterpreter','latex');
set(gcf,'DefaultLineMarkerSize',5);
set(gcf,'DefaultTextFontName','Helvetica');
set(gcf,'DefaultTextFontSize',20);
axes('position',[.1,.5,.4,.4]);loglog(btsize.rtidal(nplotBT),btsize.req_all_1(nplotBT),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req/(kpc/h)$');set(gca,'xaxislocation','top','xtick',[10,100],'ytick',[10,100]);axis([10,1e3,10,1e3]);text(14,500,'HBT');
loglog(btxm,bty1,'r');
axes('position',[.5,.5,.4,.4]);loglog(sfsize.rtidal(nplotSF),sfsize.req_all_1(nplotSF),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req/(kpc/h)$');set(gca,'xaxislocation','top','xtick',[10,100,1000],'yaxislocation','right');axis([10,1e3,10,1e3]);text(14,500,'SUBFIND');
loglog(sfxm,sfy1,'r');
axes('position',[.1,.1,.4,.4]);loglog(btsize.rtidal(nplotBT),btsize.req_all_02(nplotBT),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req_{0.02}/(kpc/h)$');axis([10,1e3,10,1e3]);set(gca,'ytick',[10,100],'xtick',[10,100]);xlabel('$Rtidal/(kpc/h)$');text(14,500,'HBT');
loglog(btxm,bty02,'r');
loglog(sfxm,sfy02,'c--');
axes('position',[.5,.1,.4,.4]);loglog(sfsize.rtidal(nplotSF),sfsize.req_all_02(nplotSF),'.');hold on;loglog([10,1e3],[10,1e3]);
ylabel('$Req_{0.02}/(kpc/h)$');set(gca,'yaxislocation','right','ytick',[10,100],'xtick',[10,100,1000]);axis([10,1e3,10,1e3]);text(14,500,'SUBFIND');
xlabel('$Rtidal/(kpc/h)$');
loglog(sfxm,sfy02,'r');

set(gcf,'paperposition',[0.6,6,20,18]);
outputdir='/home/kam/Projects/HBT/code/data/show';
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
print('-depsc',[outputdir,'/subsize_aqua_',runnum,'.',num2str(TIDALMAX),'.eps']);
%%
datadir=['/mnt/A4700/data/',runnum,'/subcat/profile/'];
newsize=load_subRmax([datadir,'RmaxVmax_',num2str(Nsnap,'%d'),'.COM']);
%%  Conclusion: r2sig~rpoisson~rtidal2~req02>~rtidal3
f=1:1500;
% x=btsize.rtidal(f);
% x=btsize.req_all_1(f);
x=btsize.req_all_02(f);
figure;
loglog(x,newsize.rhalf(1+f),'r.');
hold on;
loglog(x,newsize.r1sig(f+1),'b.');
loglog(x,newsize.r2sig(f+1),'g.');
loglog(x,newsize.r3sig(f+1),'k.');
loglog(x,newsize.rpoisson(f+1),'mo');
loglog([10,1e3],[10,1e3]);
%%
f=logical(btsize.rcen);
figure;
loglog(newsize.rmax(f),newsize.vmax(f),'.');
hold on;
loglog(newsize.rmax(~f),newsize.vmax(~f),'ro');
%%
figure;
loglog(newsize.rmax,newsize.r2sig,'r.');
hold on;
loglog(newsize.rmax,newsize.rpoisson,'go');