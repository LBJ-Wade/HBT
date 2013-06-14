clear;
outputdir='/home/kam/Documents/research/Galaxy/code/BoundTracing/data/show';
% SnapMax=63;subid=6;SnapMin=43;
% SnapMin=51;subid=7990;SnapMax=80;
SnapMin=43;subid=5562;SnapMax=66;
n=SnapMax-SnapMin+1;
datadir='/mnt/A4700/data/6702DM/subcat/anal/image/';
% Emap=load([datadir,'energymap_',num2str(SnapMax,'%03d'),'_',num2str(subid,'%d'),'.',num2str(SnapMax)]);
Emap=load([datadir,'energymap_',num2str(SnapMin,'%03d'),'_',num2str(subid,'%d'),'.',num2str(SnapMax)]);
Emap=zeros(size(Emap,1),2,n);
% Xmap=zeros(size(Emap,1),3,n);
i=1;
for Nsnap=SnapMin:SnapMax
% Emap(:,:,i)=load([datadir,'energymap_',num2str(SnapMax,'%03d'),'_',num2str(subid,'%d'),'.',num2str(Nsnap)]);
% Xmap(:,:,i)=load([datadir,'posmap_',num2str(SnapMax,'%03d'),'_',num2str(subid,'%d'),'.',num2str(Nsnap)]);
Emap(:,:,i)=load([datadir,'energymap_',num2str(SnapMin,'%03d'),'_',num2str(subid,'%d'),'.',num2str(Nsnap)]);
% Xmap(:,:,i)=load([datadir,'posmap_',num2str(SnapMin,'%03d'),'_',num2str(subid,'%d'),'.',num2str(Nsnap)]);
i=i+1;
end
% Pm=-mean(Emap(:,2,end));
Pm=-mean(Emap(:,2,1));
Emap=Emap/Pm;
%%
figure;
t=25;
hist(Emap(:,1,t)+Emap(:,2,t),100);

%%
figure('position',[1,1,1200,900]);
set(gca,'nextplot','replacechildren');
for i=1:2:n
% figure;    
plot(Emap(1:1:end,1,i),Emap(1:1:end,2,i),'b.','markersize',2);hold on;
% plot(Emap(1:5000:end,1,i),Emap(1:5000:end,2,i),'ro','markersize',6);hold on;
plot(Emap(1,1,i),Emap(1,2,i),'b.','markersize',6);hold on;
plot(Emap(1000,1,i),Emap(1000,2,i),'g^','markersize',6);hold on;
plot(Emap(5000,1,i),Emap(5000,2,i),'c*','markersize',6);hold on;
plot(Emap(10000,1,i),Emap(10000,2,i),'k>','markersize',6);hold on;
plot(Emap(20000,1,i),Emap(20000,2,i),'mo','markersize',6);hold on;
plot(Emap(50000,1,i),Emap(50000,2,i),'bx','markersize',6);hold on;
plot(Emap(100000,1,i),Emap(100000,2,i),'bp','markersize',6);hold on;
plot([0,3],[0,-3],'k-');
hold off;
axis([0,12,-3,0]);
title(num2str(i));
fr(i)=getframe(gca,[-40,-20,1000,800]);
end
figure('position',[1,1,1200,900]);
movie(fr,10,3);
%%
figure('position',[1,1,1200,900]);
set(gca,'nextplot','replacechildren');
for i=1:n
% plot(0,Emap(1:5000:end,1,i)+Emap(1:5000:end,2,i),'b.','markersize',6);%hold on;
plot(0,Emap(1,1,i)+Emap(1,2,i),'b.','markersize',6);hold on;
plot(0,Emap(1000,1,i)+Emap(1000,2,i),'g^','markersize',6);hold on;
plot(0,Emap(5000,1,i)+Emap(5000,2,i),'c*','markersize',6);hold on;
plot(0,Emap(10000,1,i)+Emap(10000,2,i),'k>','markersize',6);hold on;
plot(0,Emap(20000,1,i)+Emap(20000,2,i),'mo','markersize',6);hold on;
plot(0,Emap(50000,1,i)+Emap(50000,2,i),'bx','markersize',6);hold on;
plot(0,Emap(100000,1,i)+Emap(100000,2,i),'bp','markersize',6);hold on;
% plot(0,Emap(1:5000:end,1,i)+Emap(1:5000:end,2,i),'ro','markersize',6);hold on;
hold off;
axis([0,1,-4.5,12]);
title(num2str(i));
fr(i)=getframe(gca,[-40,-20,1000,800]);
end
figure('position',[1,1,1200,900]);
movie(fr,10,5);
%%
xmin=min(min(Xmap,[],1),[],3);
xmax=max(max(Xmap,[],1),[],3);
figure('position',[1,1,1200,900]);
set(gca,'nextplot','replacechildren');
for i=1:n
plot3(Xmap(1:1:end,1,i),Xmap(1:1:end,2,i),Xmap(1:1:end,3,i),'b.','markersize',2);hold on;
plot3(Xmap(1,1,i),Xmap(1,2,i),Xmap(1,3,i),'b+','markersize',6);hold on;
plot3(Xmap(1000,1,i),Xmap(1000,2,i),Xmap(1000,3,i),'g^','markersize',6);hold on;
plot3(Xmap(5000,1,i),Xmap(5000,2,i),Xmap(5000,3,i),'c*','markersize',6);hold on;
plot3(Xmap(10000,1,i),Xmap(10000,2,i),Xmap(10000,3,i),'k>','markersize',6);hold on;
plot3(Xmap(20000,1,i),Xmap(20000,2,i),Xmap(20000,3,i),'mo','markersize',6);hold on;
plot3(Xmap(50000,1,i),Xmap(50000,2,i),Xmap(50000,3,i),'bx','markersize',6);hold on;
plot3(Xmap(100000,1,i),Xmap(100000,2,i),Xmap(100000,3,i),'bp','markersize',6);hold on;
% plot(Xmap(1:5000:end,1,i),Xmap(1:5000:end,2,i),'ro','markersize',6);hold on;
hold off;
axis([xmin(1),xmax(1),xmin(2),xmax(2),xmin(3),xmax(3)]);
title(num2str(i));
fr(i)=getframe(gca,[-40,-20,1000,800]);
end
figure('position',[1,1,1200,900]);
movie(fr,10,5);

%%
figure;
for i=1:n
subplot(2,3,i);
plot(Emap(:,1,i),Emap(:,2,i),'b.','markersize',2);
hold on;
plot([0,4.5],[0,-4.5],'k-');
axis([0,12,-4.5,0]);
title(num2str(i));
end
