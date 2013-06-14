RunNum='8213';Nsnap=59;grpid=3;
datadir=['/mnt/A4700/data/',RunNum,'/subcat/anal/image/conf/'];
fofmap=load([datadir,'fofmap2xz_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d'),'.',num2str(Nsnap,'%03d')]);
btpos=load([datadir,'subcen_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d'),'.',num2str(Nsnap,'%03d')]);  %position of most bound particle better marks subhalo than CoM
fofsize=load([datadir,'fofsize_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d'),'.',num2str(Nsnap,'%03d')]);

datadir=['/mnt/A4700/data/',RunNum,'/subcatS/anal/image/'];
sfpos=load([datadir,'subcen_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d')]);

dims=[1,3];
outputdir='/home/kam/Projects/HBT/code/data/show';
%%
figure;
axes('position',[0.05,0.05,0.45,0.45]);
% I=imfilter((fofmap),fspecial('disk',4));
I=fofmap;
I=log(I);
% I=histeq(I);
% cmap=contrast(I);
imagesc(fofsize(dims(1),:),fofsize(dims(2),:),I');
% colormap(cmap);
% colormap('gray');
colormap('bone');
% hcb = colorbar('Location','South','XTickLabel',...
% {'low','high'}); set(hcb,'xtick',get(hcb,'xlim')); set(hcb,'YTickMode','manual','position',[0.52,0.05,0.3,0.05])
set(gca,'ydir','normal');
hold on;
l=plot_circle([btpos(2,dims(1)),btpos(2,dims(2))], 839);
set(l,'color','r','linestyle','--');
axis equal
axis([fofsize(dims(1),:),fofsize(dims(2),:)]);
set(gca,'xtick',[],'ytick',[]);
% x=linspace(fofsize(dims(1),1),fofsize(dims(1),2),size(I,1));
% y=linspace(fofsize(dims(2),1),fofsize(dims(2),2),size(I,2));
% l=contour(x,y,I','w');
%%
datadir=['/mnt/A4700/data/',RunNum,'/subcat/anal/image/conf_zoom/'];
fofmap=load([datadir,'fofmap2xz_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d'),'.',num2str(Nsnap,'%03d')]);
fofsize=load([datadir,'fofsize_',num2str(Nsnap,'%03d'),'_',num2str(grpid,'%d'),'.',num2str(Nsnap,'%03d')]);
%%
x=fofsize(dims,:);
plot([x(1,1),x(1,2)],[x(2,1),x(2,1)],'r');
plot([x(1,1),x(1,2)],[x(2,2),x(2,2)],'r');
plot([x(1,1),x(1,1)],[x(2,1),x(2,2)],'r');
plot([x(1,2),x(1,2)],[x(2,1),x(2,2)],'r');
l=annotation('line',[0.258928571428571 0.367857142857143],...
    [0.291857142857143 0.895238095238095]);
set(l,'color','r');
l=annotation('line',[0.291071428571429 0.830357142857143],...
    [0.246619047619048 0.3]);set(l,'color','r');
axes('position',[0.3,0.3,0.6,0.6]);
%%
I=imfilter((fofmap),fspecial('disk',3));
% I=fofmap;
I=log(I);
% cmap=contrast(I);
% imagesc(fofsize(dims(1),:),fofsize(dims(2),:),I');
% colormap(cmap);
% colormap('gray');
set(gca,'ydir','normal');
hold on;
x=linspace(fofsize(dims(1),1),fofsize(dims(1),2),size(I,1));
y=linspace(fofsize(dims(2),1),fofsize(dims(2),2),size(I,2));
l=contourf(x,y,I','w');
%%
l=zeros(4,1);
l(1)=plot(btpos(2,dims(1)),btpos(2,dims(2)),'rp','markersize',15,'linewidth',1);%subid 2571
l(2)=plot(btpos(7,dims(1)),btpos(7,dims(2)),'rx','markersize',15,'linewidth',2);%subid 2576
l(3)=plot(sfpos(2,dims(1)),sfpos(2,dims(2)),'gp','markersize',15,'linewidth',1); %subid 2196
l(4)=plot(sfpos(33,dims(1)),sfpos(33,dims(2)),'gx','markersize',15,'linewidth',2);%subid 2221
% l=legend(l,'HBT0','HBT1','SUBFIND0','SUBFIND1');set(l,'location','southOutside');
axis equal
axis([fofsize(dims(1),:),fofsize(dims(2),:)]);
set(gca,'xtick',[],'ytick',[]);
% title(RunNum);

print('-depsc',[outputdir,'/match_switch.new.eps']);
% print('-depsc',[outputdir,'/halo_image',RunNum,'S',num2str(Nsnap),'G',num2str(grpid),'.sf.eps']);
%hgsave([outputdir,'/halo_image_',RunNum,'.fig']);
