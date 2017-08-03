runnum='6702DM';
file=['/mnt/A4700/data/',runnum,'/subcat/anal/history_099_000.txt'];
A=importdata(file,',',1);
data=A.data;
scaleF_file=['/mnt/A4700/data/',runnum,'/subcat/Redshift.dat'];
tmp=load(scaleF_file);a=tmp(:,2);z=1./a-1;
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);
M=data(:,3);t=a(data(:,1)+1);r=diff(log(M))./diff(log(t));
% plot(data(2:end,1),r);
plot(a(data(2:end,1)+1),r,'o-');
% semilogy(a(data(:,1)+1),data(:,3),'o-');
xlabel('$a$','interpreter','latex');ylabel('$d\ln M_{vir}/d\ln a$','interpreter','latex');
outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show/massfun/resim';
print('-depsc',[outputdir,'/AccRate_',runnum,'.eps']);