%% data preparation

% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show/massfun/resim';
outputdir='/home/kam/Projects/HBT/code/data/show/massfun/resim';
addpath(genpath('../post'));

virtype=0;
rmin=0;rmax=1;
nbin=9;
Nsnap=99;grpid=0;
RunName='6702DM';
scaleF_file=['/mnt/A4700/data/',RunName,'/subcat/Redshift.dat'];
a=load_scaleF(scaleF_file);
z=1/a(Nsnap+1)-1;

xref=logspace(-6,-1,5);
datadir=['/mnt/A4700/data/',RunName,'/subcat/anal/massfun/'];
[Mlist,M0,R0]=Msublist_in_radii(datadir,virtype,Nsnap,grpid,rmin,rmax,'bindata','norm');
xmin=min(Mlist);xmax=max(Mlist)*1.001;
[xmass,mfunspec,mfunspecln,mfuncum]=mass_sumcount(Mlist,nbin,xmin,xmax);
datadir=['/mnt/A4700/data/',RunName,'/subcatS/anal/massfun/'];
[Mlist,M0,R0]=Msublist_in_radii(datadir,virtype,Nsnap,grpid,rmin,rmax,'bindata','norm');
[xmass2,mfunspec2,mfunspecln2,mfuncum2]=mass_sumcount(Mlist,nbin,xmin,xmax);
%% fractional cumulative mass function
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

% axes('position',[0.1,0.5,0.85,0.45]);
% set(gca,'xaxis','top');

    mfun=mfuncum;
    plot(log10(xmass(:,1)),mfun(:,1),'c^-',...
        'displayname','HBT');
    hold on;

    mfun=mfuncum2;
    plot(log10(xmass2(:,1)),mfun(:,1),'mo-',...
        'displayname','SubFind');
   
% set(gca,'yscale','log','yminortick','on');
% xlabel('$\log(M_{sub}/M_{vir})$','interpreter','latex');
ylabel('$M(>M_{sub})/M_{vir}$','interpreter','latex');
hl=legend('show','location','northeast');set(hl,'interpreter','latex');
title(['z=',num2str(z,'%2.1f')]);

% axes('position',[0.1,0.15,0.85,0.35]);
% mfun=mfuncum./mfuncum2;
% plot(log10(xmass2(:,1)),mfun(:,1),'-');
% ylabel('$M_{HBT}/M_{SF}$','interpreter','latex');
xlabel('$\log(M_{sub}/M_{vir})$','interpreter','latex');

print('-depsc',[outputdir,'/msfunFcum_',RunName,'.eps']);

%% ratio of mass weighted specific mass function

figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

mfun=mfunspec./mfunspec2;
plot(log10(xmass2(:,1)),mfun(:,1),'-','displayname','data');
hold on;
% plot([-6,-0.5],[1,1],':');
ymean=mean(mfun(1:end-3,1));
plot([-6,-0.5],[ymean,ymean],':','displayname',['y=',num2str(ymean,'%3.2f')]);
set(gca,'xlim',[-6,-0.5],'ytick',[0,1,2]);
ylabel('$M_{HBT}/M_{SF}$','interpreter','latex');
xlabel('$\log(M_{sub}/M_{vir})$','interpreter','latex');
hl=legend('show','location','northeast');set(hl,'interpreter','latex');

print('-depsc',[outputdir,'/msfunRat_',RunName,'.eps']);

%% mass weighted specific mass function
myfigure;

axes('position',[0.25,0.55,0.7,0.4]);

    mfun=mfunspec;
%     plot(log10(xmass(:,2)),mfun(:,1),'c^-',...
%         'displayname','HBT');
    errorbar(log10(xmass(:,2)),mfun(:,1),mfun(:,2).*sqrt(xmass(:,2)),'c^-',...
        'displayname','HBT');
    hold on;

    mfun=mfunspec2;
%     plot(log10(xmass2(:,2)),mfun(:,1),'mo-',...
%         'displayname','SubFind');
    errorbar(log10(xmass2(:,2)),mfun(:,1),mfun(:,2).*sqrt(xmass2(:,2)),'mo-',...
        'displayname','SUBFIND');

yref=10^-3.02*(M0*1e10)^0.1*(xref).^-0.9;
plot(log10(xref),yref,'-k','displayname','G10');hold off;
set(gca,'yscale','log','yminortick','on');
set(gca,'xlim',[-6,-0.5],'xticklabel',[]);
% ylabel('$dN/d\ln(M_{sub}/M_{vir})$','interpreter','latex');
ylabel('$M_{sub}dN/{dM_{sub}}$','interpreter','latex');
hl=legend('show','location','northeast');set(hl,'interpreter','latex');
% title(['z=',num2str(z,'%2.1f')]);

axes('position',[0.25,0.15,0.7,0.4]);
mfun=mfunspecln./mfunspecln2;
mfun(:,2)=sqrt((mfunspec(:,2).*sqrt(xmass(:,2))./mfunspec(:,1)).^2+(mfunspec2(:,2).*sqrt(xmass2(:,2))./mfunspec2(:,1)).^2);
mfun(:,2)=mfun(:,2).*abs(mfun(:,1));
% plot(log10(xmass2(:,2)),mfun(:,1),'-','displayname','data');
errorbar(log10(xmass2(:,2)),mfun(:,1),mfun(:,2),'-','displayname','data');
hold on;
% plot([-6,-0.5],[1,1],':');
ymean=mean(mfun(1:end-3,1));
% plot([-6,-0.5],[ymean,ymean],':','displayname',['y=',num2str(ymean,'%3.2f')]);
set(gca,'xlim',[-6,-0.5],'ytick',[0,1,2]);
ystr={'$dM_{HBT}/dM_{SF}$','\ '};
ylabel(ystr,'interpreter','latex');
xlabel('$\log(M_{sub}/M_{vir})$','interpreter','latex');
ylim([0.6,3]);
% h2=legend('show','location','northeast');set(h2,'interpreter','latex');
plot([-6,-0.5],[1,1],'k:');

print('-depsc',[outputdir,'/msfunFspec_',RunName,'.eps']);