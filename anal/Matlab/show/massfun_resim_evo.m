%% data preparation
% to add: 6702low, cosmo

outputdir='/home/kam/Projects/HBT/code/data/show/massfun/resim';
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show/massfun/resim';
addpath(genpath('../post'));

markers=['s--';'o--';'d--';'^--';'<--';'>--';'p--';'x--';'+--';'.--'];
colors=['r';'g';'b';'c';'m';'k';'r';'g';'b';'c'];

virtype=0;
rmin=0;rmax=1;
nbin=9;
Nsnap=[37,39:20:99];grpid=0;
% runs={'6702','6702DM'};
runs='6702DM';
RunName='6702DMEvo';
a=load_scaleF(runs);
z=1./a(Nsnap+1)-1;
 
xref=logspace(10,13,5);
N=numel(Nsnap);
M0=zeros(1,N);R0=M0;
xmass=cell(1,N);mfunspec=cell(1,N);mfunspecln=cell(1,N);mfuncum=cell(1,N);
datadir=['/mnt/A4700/data/',runs,'/subcat/anal/massfun/'];
for i=1:N
    [Mlist,M0(i),R0(i)]=Msublist_in_radii(datadir,virtype,Nsnap(i),grpid,rmin,rmax,'bindata','');
    [xmass{i},mfunspec{i},mfunspecln{i},mfuncum{i}]=mass_count(Mlist,nbin);
end
%% plot specific mass function
figure;%('visible','off');
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

for i=1:N
    mfun=mfunspec{i}/M0(i);
    plot(log10(xmass{i}(:,2))+10,mfun(:,1),markers(i,:),...
        'color',colors(i),...
        'displayname',['z=',num2str(z(i),'%2.1f')]);
    hold on;
end
  
yref=10^-3.03*(xref).^-1.9*10^20;
plot(log10(xref),yref,'-k','displayname','G10');hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
ylabel('$dN/dM_{sub}/M_{host}\times(10^{10}M_{\odot}/h)^2$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
title(runs);

print('-depsc',[outputdir,'/msfun_',RunName,'.eps']);
hgsave([outputdir,'/msfun_',RunName,'.fig']);
%% plot logspaced specific mass function
figure;%('visible','off');
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

for i=1:N
    mfun=mfunspecln{i}/M0(i);
%     mfun=mfunspec{i}.*repmat(xmass{i}(:,2),1,2);
    plot(log10(xmass{i}(:,2))+10,mfun(:,1),markers(i,:),...
        'color',colors(i),...
        'displayname',['z=',num2str(z(i),'%2.1f')]);
    hold on;
end

    
yref=10^-3.03*(xref).^-0.9*10^10;
plot(log10(xref),yref,'-k','displayname','G10,z=0');hold off;
set(gca,'yscale','log','yminortick','on');
set(gca,'xlim',[9.2,14.2],'ylim',[1e-6,1e-1]);
axis square;
xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
ylabel('$dN/d\ln M_{sub}/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
% title(runs);

print('-depsc',[outputdir,'/msfunln_',RunName,'.eps']);
% hgsave([outputdir,'/msfunln_',RunName,'.fig']);
%% plot cumulative mass function
figure;%('visible','off');
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

for i=1:N
    mfun=mfuncum{i}/M0(i);
    plot(log10(xmass{i}(:,1))+10,mfun(:,1),markers(i,:),...
        'color',colors(i),...
        'displayname',['z=',num2str(z(i),'%2.1f')]);
    hold on;
end
    
yref=1/0.9*10^-3.03*(xref).^-0.9*10^10;
plot(log10(xref),yref,'-k','displayname','G10');hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
ylabel('$N(>M_{sub})/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
title(runs);

print('-depsc',[outputdir,'/msfuncum_',RunName,'.eps']);
hgsave([outputdir,'/msfuncum_',RunName,'.fig']);
