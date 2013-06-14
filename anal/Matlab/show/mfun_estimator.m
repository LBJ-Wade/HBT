f1=@(k) 10/9*(1-k.^-0.9)./log(k).*(9*(k.^0.1-1)./(1-k.^-0.9)).^0.9;
f2=@(k) 10*(k.^0.1-1)./(k-1).*(9*(k.^0.1-1)./(1-k.^-0.9)).^0.9;
k=logspace(0,1,20);
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',20,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on');
set(gcf,'DefaultLineMarkerSize',6);
set(gcf,'DefaultTextInterpreter','Latex');
plot(log10(k),f1(k),'r-','linewidth',1,'displayname','$f_a/f$');
hold on;
plot(log10(k),f2(k),'k-','linewidth',2,'displayname','$f_b/f$');
% plot([0,1],[1,1],'-');
xlabel('$\Delta\log(m)$');
ylabel('bias');
l=legend('show','location','southwest');set(l,'interpreter','latex');

outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show/';
print('-depsc',[outputdir,'estimators.eps']);