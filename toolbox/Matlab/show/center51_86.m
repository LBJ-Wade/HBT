%CoM MinPot CoP 0.01 0.04 0.1 0.25 0.5 
% for 6702DM snap51 grp86

dat=[
149553,173718,148442,51.0932,-1420.31,406.658
149531,173707,148411,51.0932,-1420.31,406.658
149543,173708,148428,73.4144,-1542.63,474.861
149531,173706,148410,96.5707,-1736.65,605.194
149532,173706,148410,93.2508,-1726.88,589.901
149532,173706,148411,100.069,-1720.18,579.623
149532,173705,148411,99.2984,-1713.37,576.675
149535,173703,148412,92.9141,-1674.66,543.788
];
Cen=dat(:,1:3);
VCen=dat(:,4:6);

CoM=[149532,173705,148410];
VCoM=[104.601,-1723.54,587.719];
Rvir=247.948;
Vvir=185.647;

d=Cen-repmat(CoM,size(Cen,1),1);
d=sqrt(sum(d.^2,2))/Rvir;
v=VCen-repmat(VCoM,size(VCen,1),1);
v=sqrt(sum(v.^2,2))/Vvir;

myfigure;
plot(d(1),v(1),'k^','markerfacecolor','k','markersize',10,'displayname','CoM Frame');hold on;
plot(d(2),v(2),'ms','markerfacecolor','m','markersize',10,'displayname','MinPot Frame');
plot(d(3),v(3),'cd','markerfacecolor','c','markersize',10,'displayname','CoP Frame');
plot(d(4),v(4),'ro','markerfacecolor','r','markersize',6,'displayname','CoreFrac=0.01');
% plot(x,BndC5(:,2),'r-','displayname','CoreFrac=0.04');
% plot(x,BndC3(:,2),'- *');
plot(d(7),v(7),'bo','markerfacecolor','b','markersize',10,'displayname','CoreFrac=0.25');
plot(d(8),v(8),'go','markerfacecolor','g','markersize',14,'displayname','CoreFrac=0.5');
xlabel('$\Delta R/R_{vir}$','interpreter','latex');
ylabel('$\Delta V/V_{vir}$','interpreter','latex');
legend('show','location','southeast');

% outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
outputdir='/home/kam/Projects/HBT/code/data/show';
print('-depsc',[outputdir,'/center_51_86.eps']);