%% load data

addpath(genpath('../post'));

markers=['o--';'s--';'d--';'^--';'<--';'x--'];
% markers=['.-';'.-';'.-';'.-';'.-';'.-'];
colors=['r';'g';'b';'c';'m';'k'];

Nsnap=99; RunNum='6114'; name='msfun'; skip='';
% Nsnap=71;RunNum='8511';name='msfun';skip='';
% Nsnap=71;RunNum='6620';name='msfun';skip='';
% Nsnap=41;RunNum='8213';name='msfun';skip='';
virtype=1;
% xref=logspace(9.5,14.,5);
xref=logspace(9,14.,5);

outputdir=['/work/Projects/HBT/code/data/show/massfun/'];
datadir=['/mnt/A4700/data/',RunNum,'/Analysis/'];
% datadir=['/mnt/A4700/data/',RunNum,'/subcat',skip,'/anal/massfun/'];
% datadir=['/mnt/uv/',RunNum,'/subcat',skip,'/anal/massfun/'];
% datadir=['/mnt/charon/HBT/data/',RunNum,'/subcat',skip,'/anal/massfun/1Rvir/'];
[data,redshift]=read_massfun([datadir,'massfun_',num2str(Nsnap,'%03d'),'.',num2str(virtype,'%d')]);%,'.R0.0-2.0']);
nfun=numel(data);

Mhost=zeros(nfun,1);
for i=1:nfun
    Mhost(i)=data(i).Mhost;
end
%% plot specific mass function
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

yref=10^-3.2*(xref).^-1.9*10^20;plot(log10(xref),yref,'--k','linewidth',2,'displayname','Gao04');hold on;
yref2=10^-3.03*(xref).^-1.9*10^20;plot(log10(xref),yref2,'-k','linewidth',2,'displayname','G10,z=0');hold on;
% yref3=10^-4.15*(xref).^-1.8*10^20;plot(log10(xref),yref3,'-k','linewidth',2,'displayname','fit'); 
% yref3=10^-6.7*(xref).^-1.62*10^20;plot(log10(xref),yref3,'--k','linewidth',2,'displayname','-1.62'); 

for i=1:nfun
    mfun=data(i).mfunspec/Mhost(i);
    xmass=data(i).xmass(:,2);
    plot(log10(xmass)+10,mfun(:,1),markers(i,:),...
        'color',colors(i),'markerfacecolor',colors(i),...
        'displayname',[num2str(log10(data(i).Mbin(1))+10,'%2.1f'),'$\sim$',num2str(log10(data(i).Mbin(2))+10,'%2.1f')]);
%     errorbar(log10(xmass)+10,mfun(:,1),mfun(:,2),markers(i,:),...
%         'color',colors(i),'markerfacecolor',colors(i),...
%         'displayname',[num2str(data(i).Mhost/data(i).Nhost*1e10,'%2.1e'),'$M_{\odot}/h$']);
    hold on;
end

hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$log(M_{sub}/(M_{\odot}/h)$)','interpreter','latex');
ylabel('$dN/dM_{sub}/M_{host}\times(10^{10}M_{\odot}/h)^2$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
% title(['z=',num2str(redshift,'%2.1f')]);
title([RunNum, ',z=', num2str(redshift,'%2.1f')]);
% xlim([10,14.5]);

fname=[name,'_',RunNum,'S',num2str(Nsnap),'V',num2str(virtype)];
% print('-depsc',[outputdir,fname,'.eps']);
% hgsave([outputdir,fname,'.fig']);
%% plot logspaced specific mass function
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

alpha=1 %multiply by power alpha
for i=1:2:nfun
    mfun=data(i).mfunspecln/Mhost(i);
%     mfun=data(i).mfunspec.*repmat(data(i).xmass(:,2),1,2)/Mhost(i);
    xmass=data(i).xmass(:,2);
    plot(log10(xmass)+10,mfun(:,1).*(xmass).^alpha,markers(i,:),...
        'color',colors(i),'markerfacecolor',colors(i),...
        'displayname',[num2str(log10(data(i).Mbin(1))+10,'%2.1f'),'$\sim$',num2str(log10(data(i).Mbin(2))+10,'%2.1f')]);
%     errorbar(log10(xmass)+10,mfun(:,1),mfun(:,2),markers(i,:),...
%         'color',colors(i),'markerfacecolor',colors(i),...
%         'displayname',[num2str(data(i).Mhost/data(i).Nhost*1e10,'%2.1e'),'$M_{\odot}/h$']);
    hold on;
end  

yref=10^-3.2*(xref).^-0.9*10^10;plot(log10(xref),yref.*(xref/1e10).^alpha,'--k','linewidth',2,'displayname','Gao04');hold on;
yref2=10^-3.03*(xref).^-0.9*10^10;plot(log10(xref),yref2.*(xref/1e10).^alpha,'-k','linewidth',2,'displayname','G10,z=0');hold on;
% yref3=10^-4.15*(xref).^-0.6*10^10/120;plot(log10(xref),yref3.*(xref/1e10).^alpha,'--k','linewidth',2,'displayname','$\alpha$=-0.6');
% yref3=10^-4.18*(xref).^-0.8*10^10;plot(log10(xref),yref3.*(xref/1e10).^alpha,'-k','linewidth',2,'displayname','$\alpha$=-0.8');

hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$\log(M_{sub}/(M_{\odot}/h)$)','interpreter','latex');
% ylabel('$dN/d\ln M_{sub}/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
ylabel('$M_{sub}dN/d\ln M_{sub}/M_{host}$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
title([RunNum, ',z=',num2str(redshift,'%2.1f')]);
% ylim([1e-3,1e-1]);
xlim([9.,14]);

fname=[name,'ln_',num2str(RunNum),'S',num2str(Nsnap),'V',num2str(virtype)];
% print('-depsc',[outputdir,fname,'.eps']);
% hgsave([outputdir,fname,'.fig']);
%% plot cumulative mass function
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

% yref=1/0.9*10^-3.2*(xref).^-0.9*10^10;plot(log10(xref),yref,'-k','linewidth',2,'displayname','Gao04');hold on;
yref2=1/0.9*10^-3.03*(xref).^-0.9*10^10;plot(log10(xref),yref2,'-k','linewidth',2,'displayname','G10,z=0');hold on;
% yref3=1/0.9*10^-6.5*(xref).^-0.62*10^10;plot(log10(xref),yref3,'--k','linewidth',2,'displayname','-0.62');hold on;

for i=1:nfun
    mfun=data(i).mfuncum/Mhost(i);
    xmass=data(i).xmass(:,1);
    plot(log10(xmass)+10,mfun(:,1),markers(i,:),...
        'color',colors(i),'markerfacecolor',colors(i),...
        'displayname',[num2str(log10(data(i).Mbin(1))+10,'%2.1f'),'$\sim$',num2str(log10(data(i).Mbin(2))+10,'%2.1f')]);
%     errorbar(log10(xmass)+10,mfun(:,1),mfun(:,2),markers(i,:),...
%         'color',colors(i),'markerfacecolor',colors(i),...
%         'displayname',[num2str(data(i).Mhost/data(i).Nhost*1e10,'%2.1e'),'$M_{\odot}/h$']);
    hold on;
end
   
hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$\log(M_{sub}/(M_{\odot}/h)$)','interpreter','latex');
ylabel('$N(>M_{sub})/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
title(['z=',num2str(redshift,'%2.1f')]);

fname=[name,'cum_',num2str(RunNum),'S',num2str(Nsnap),'V',num2str(virtype)];
% print('-depsc',[outputdir,fname,'.eps']);
% hgsave([outputdir,fname,'.fig']);
