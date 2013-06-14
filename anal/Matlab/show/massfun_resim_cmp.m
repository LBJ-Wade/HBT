%% data preparation
% to add: 6702low, cosmo

outputdir=['/home/kam/Projects/HBT/code/data/show/massfun/resim'];
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show/massfun/resim';
addpath(genpath('../post'));

markers=['s--';'o--';'d--';'^--';'x--';'p--'];markers=repmat(markers,3,1);
colors=['r';'g';'b';'c';'m'];colors=repmat(colors,4,1);

virtype=0;
rmin=0;rmax=1;
nbin=10;
Nsnap=82;grpid=0;
% runs={'6702DM','6702'};
runs={'6402NEW','6402DM','6402U','6402U10','6402U100'};
% runs={'6402','6402S','6402U','6402U10','6402U100','6402a100','6402A100'};
RunName='6402NEW';
a=load_scaleF(runs{1});
z=1/a(Nsnap+1)-1;

xref=logspace(6,10,5);
N=numel(runs);
M0=zeros(1,N);R0=M0;
xmass=cell(1,N);mfunspec=cell(1,N);mfunspecln=cell(1,N);mfuncum=cell(1,N);
for i=1:N
    datadir=['/mnt/A4700/data/',runs{i},'/subcat/anal/massfun/'];
    [Mlist,M0(i),R0(i)]=Msublist_in_radii(datadir,virtype,Nsnap,grpid,rmin,rmax,'bindata','');
    [xmass{i},mfunspec{i},mfunspecln{i},mfuncum{i}]=mass_count(Mlist,nbin);
end
%% subfind data for 6702
% subfinddir='/home/kam/Documents/research/Galaxy/code/BoundTracing/v7.1/data/massfun/subfind';
% load([subfinddir,'/SubFind_mass_099']);
% load([subfinddir,'/SubFindgroup_offset_099']);
% G=43007.1;
% Hz=0.1;Omega=0.3;
% partmass=0.008848;
% % MS=SubFindgroup_offset_099(1,3);
% % Rvir=SubFindgroup_offset_099(1,4);%Critical_200
% Rsub_s=sqrt(sum((SubFind_mass_099(:,3:5)-repmat(SubFind_mass_099(1,3:5),size(SubFind_mass_099,1),1)).^2,2));
% id=1:size(SubFind_mass_099,1);id=id';
% Mlist_S=SubFind_mass_099(find(Rsub_s>rmin*R0(1)&Rsub_s<rmax*R0(1)&id~=1),1)*partmass;
% [xmassS,mfunspecS,mfunspeclnS,mfuncumS]=mass_count(Mlist_S,nbin);
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
        'displayname',runs{i});
    hold on;
end

%     mfun=mfunspecS/M0(1);
%     plot(log10(xmassS(:,2))+10,mfun(:,1),'mo-',...
%         'displayname','SubFind');
    
yref=10^-3.03*(xref).^-1.9*10^20;
plot(log10(xref),yref,'-k','displayname','Giocoli09');hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
ylabel('$dN/dM_{sub}/M_{host}\times(10^{10}M_{\odot}/h)^2$','interpreter','latex');
hl=legend('show','location','northeast');set(hl,'interpreter','latex');
title(['z=',num2str(z,'%2.1f')]);

% print('-depsc',[outputdir,'/msfun_',RunName,'.eps']);
% hgsave([outputdir,'/msfun_',RunName,'.fig']);
%% plot logspaced specific mass function
figure;%('visible','off');
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

for i=1
    mfun=mfunspecln{i}/M0(i);
   % plot(log10(xmass{i}(:,2))+10,mfun(:,1),markers(i,:),...
    errorbar(log10(xmass{i}(:,2))+10,mfun(:,1),mfun(:,2),markers(i,:),...        
        'color',colors(i),...
        'displayname',runs{i});
    hold on;
end
for i=2:N
    mfun=mfunspecln{i}/M0(i);
   plot(log10(xmass{i}(:,2))+10,mfun(:,1),markers(i,:),...    
        'color',colors(i),...
        'displayname',runs{i});
    hold on;
end
%     mfun=mfunspeclnS/M0(1);
%     plot(log10(xmassS(:,2))+10,mfun(:,1),'mo-',...
%         'displayname','SubFind');
    
yref=10^-3.03*(xref).^-0.9*10^10;
plot(log10(xref),yref,'-k','displayname','G10,z=0');
% plot(log10(xref),1.5*yref,'-r','displayname','G10,z=0');
hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
ylabel('$dN/d\ln M_{sub}/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
hl=legend('show','location','northeast');set(hl,'interpreter','latex');
title(['z=',num2str(z,'%2.1f')]);
%
print('-dpdf',[outputdir,'/msfunln_',RunName,'.pdf']);
% print('-depsc',[outputdir,'/msfunln_',RunName,'.eps']);
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
    mfun=mfuncum{i};
    plot(log10(xmass{i}(:,1))+10,mfun(:,1),markers(i,:),...
        'color',colors(i),...
        'displayname',runs{i});
    hold on;
end

%     mfun=mfuncumS/M0(1);
%     plot(log10(xmassS(:,1))+10,mfun(:,1),'mo-',...
%         'displayname','SubFind');
    
yref=1/0.9*10^-3.03*(xref).^-0.9*10^10;
%plot(log10(xref),yref,'-k','displayname','Giocoli09');hold off;
set(gca,'yscale','log','yminortick','on');
xlabel('$\log(M_{sub}/(M_{\odot}/h))$','interpreter','latex');
%ylabel('$N(>M_{sub})/M_{host}\times(10^{10}M_{\odot}/h)$','interpreter','latex');
ylabel('$N(>M_{sub})$','interpreter','latex');
hl=legend('show','location','southwest');set(hl,'interpreter','latex');
title(['z=',num2str(z,'%2.1f')]);

% print('-depsc',[outputdir,'/msfuncum_',RunName,'.eps']);
% hgsave([outputdir,'/msfuncum_',RunName,'.fig']);
