%% data preparation
% addpath('massfun_io');

Nsnap=99;
RunNum=6113;
file=['/mnt/A4700/data/',num2str(RunNum),'/subcat/anal/massfun/biggestsub_',num2str(Nsnap,'%03d')];
mass=read_biggestsub(file);
mass(mass(:,3)==0,:)=[];
mass(mass(:,1)==0,:)=[];
mass(mass(:,2)==0,:)=[];
%%
Mh=mass(:,3)*1e10;
M2=mass(:,2)*1e10;
M2_norm=M2./Mh;
Mbin=logspace(log10(min(Mh)),log10(max(Mh)),10);
Rm=zeros(9,1);Mm=Rm;M2m=Rm;
for i=1:9
    Rm(i)=median(M2_norm(Mh>Mbin(i)&Mh<Mbin(i+1)));
    M2m(i)=median(M2(Mh>Mbin(i)&Mh<Mbin(i+1)));
    Mm(i)=mean(Mh(Mh>Mbin(i)&Mh<Mbin(i+1)));
figure;hist(log10(M2_norm(Mh>Mbin(i)&Mh<Mbin(i+1))));
end

% x=logspace(11,16,5);
% x0=1.5e13;
% y=9*(x/x0).^-0.13;
% yu=y*exp(0.25);
% yl=y/exp(0.25);
% x=log10(x);
%%
% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data';
figure;
set(gcf,...
    'DefaultLineLineWidth',2,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

loglog(Mh(:),M2_norm(:),'.','displayname','halos');hold on;
loglog(Mm,Rm,'r-','displayname','median');
% plot(x,y,'k-','displayname','$c=9(\frac{M}{M^*})^{\frac{\ }{\ }0.13}$');
hl=legend('show');set(hl,'interpreter','latex');
% plot(x,yu,'k--');plot(x,yl,'k--');set(gca,'yscale','log');
xlabel('$log(M_{vir}/(M_{\odot}/h))$','interpreter','latex');ylabel('${Ms}_{max}/M_{vir}$','interpreter','latex');
title('z=0');

% print('-depsc',[outputdir,'/M_c_',num2str(RunNum),'S',num2str(Nsnap),'.eps']);
% hgsave([outputdir,'/M_c_',num2str(RunNum),'S',num2str(Nsnap),'.fig']);

figure;
set(gcf,...
    'DefaultLineLineWidth',2,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);

loglog(Mh(:),M2(:),'.','displayname','halos');hold on;
loglog(Mm,M2m,'r-','displayname','median');
% plot(x,y,'k-','displayname','$c=9(\frac{M}{M^*})^{\frac{\ }{\ }0.13}$');
hl=legend('show');set(hl,'interpreter','latex');
% plot(x,yu,'k--');plot(x,yl,'k--');set(gca,'yscale','log');
xlabel('$log(M_{vir}/(M_{\odot}/h))$','interpreter','latex');ylabel('${Ms}_{max}h/M_{\odot}$','interpreter','latex');
title('z=0');