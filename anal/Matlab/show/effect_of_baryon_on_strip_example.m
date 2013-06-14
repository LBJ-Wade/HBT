outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
scaleF_file='/home/kam/Documents/research/Galaxy/code/BoundTracing/v7.9/anal/Matlab/outputs_zoom.txt';
a=load(scaleF_file);

datadir='/mnt/A4700/data/6702/subcat/anal/follow';
%position: columns: [snapshot,sublen,hostgrplen,r/rvir]
GasPos=load([datadir,'/follow_051_78.pos']);

datadir='/mnt/A4700/data/6702DM/subcat/anal/follow';
%halo 6702S51G78==halo 6702DMS51G86
%position: columns: [snapshot,sublen,hostgrplen,r/rvir]
DMPos=load([datadir,'/follow_051_86.pos']);
%%
figure;
set(gcf,...
    'DefaultLineLineWidth',1,'DefaultAxesLineWidth',.5,...
    'DefaultAxesFontName','Helvetica',...
    'DefaultAxesFontSize',10,...
    'DefaultAxesTickLength',[0.02,0.02],... 
    'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on',... 
    'DefaultLegendFontsize',8);

subplot(2,1,1);
plot(1./a(GasPos(:,1)+1)-1,GasPos(:,2),'bo-','displayname','adiabatic');
hold on;
plot(1./a(DMPos(:,1)+1)-1,DMPos(:,2),'g^-','displayname','DM only');
set(gca,'xdir','reverse','ylim',[0,10000]);
legend('show','location','NorthEast');legend('boxoff');
xlabel('Redshift');ylabel('Bound Mass (particles)');

subplot(2,1,2);
plot(1./a(GasPos(:,1)+1)-1,GasPos(:,4),'bo','displayname','adiabatic');
hold on;
plot(1./a(DMPos(:,1)+1)-1,DMPos(:,4),'g^','displayname','DM only');
set(gca,'xdir','reverse');
% legend('show','location','NorthEast');%legend('boxoff');
xlabel('Redshift');ylabel('D/Rvir');

set(gcf,'papertype','A4');
set(gcf,'paperunits','centimeters','paperposition',[3,2,15,25]);
print('-depsc',[outputdir,'/baryon_effect_strip_example']);
hgsave([outputdir,'/baryon_effect_strp_example.fig']);
