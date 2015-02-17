RunNum='6702DM';Nsnap=99;
file=['/mnt/A4700/data/',RunNum,'/subcat/anal/Kt_99'];
kt=load(file);
figure;semilogy(kt(:,2),kt(:,1),'.');
figure;loglog(kt(:,3),kt(:,1),'.');
% x=logspace(-2,2,12)';
x=[0:0.2:5]';
[n,bin]=histc(kt(:,1),x);
% n=n/sum(n);
y=n(1:end-1)./diff(x);
xm=y;
for i=1:numel(x)-1
xm(i)=mean(kt(bin==i,1));
end

figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);
set(gcf,'DefaultTextInterpreter','latex');
semilogy(xm,y,'o-');
xlabel('$\kappa_t$');
ylabel('$dN/d\kappa_t$');

% kt(kt(:,3)<100,:)=[];%mass limit
kt(kt(:,2)>1,:)=[];%distance limit
[n,bin]=histc(kt(:,1),x);
% n=n/sum(n);
y=n(1:end-1)./diff(x);
xm=y;
for i=1:numel(x)-1
xm(i)=mean(kt(bin==i,1));
end
hold on;
semilogy(xm,y,'rx-');

outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
print('-depsc',[outputdir,'/Kt_',RunNum,'.eps']);