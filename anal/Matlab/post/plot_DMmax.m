function plot_DMmax(DMmax,kt_max)

Dstrp=@(x) 3^(1/3)+x.^(1/3)/3+(2*x.^(2/3))/(9*3^(1/3))+x/(9*(3^(1/3))^2);
Dcomp=@(x) 3/2*3^(1/3)+x.^(1/3)/3+x.^(2/3)/3^(4/3)-7/9*x./3^(2/3);
Dmean=@(x) 5/4*3^(1/3)+x.^(1/3)/3+5/18*x.^(2/3)/3^(1/3)-x./3^(5/3);

Diststrp=DMmax(:,1);
rdmmax=DMmax(:,2);
% rgasmax=DMmax(:,3);
mrate=DMmax(:,end);
% tidalrategas=rgasmax./Diststrp;
tidalratedm=rdmmax./Diststrp;
x=0:0.1:10;
y1=histc(rdmmax(rdmmax>0),x);
% y2=histc(rgasmax(rgasmax>0),x);
y11=histc(Diststrp(rdmmax>0),x);
y3=histc(tidalratedm(rdmmax>0),x);
% y4=histc(tidalrategas(rgasmax>0),x);
figure;subplot(2,1,1);stairs(x,y1./sum(y1),'r-');hold on;
% stairs(x,y2/sum(y2),'b-');
plot([1.8,1.8],[0,0.1],'k-');
stairs(x,y11./sum(y11),'r:');
xlabel('D_{Mmax}/R_{vir,host}');ylabel('Fraction');
% legend('DM sub Mmax','gas sub Mmax','D/R_{vir}=1.8','Model-found Distance');
legend('DM sub Mmax','D/R_{vir}=1.8','Model-found Distance');
title('Distribution of Stripping Distance')
subplot(2,1,2);stairs(x,y3/sum(y3),'r-');hold on;
% stairs(x,y4/sum(y4),'b-.');
xlabel('D_{Mmax}/D_{Mmax,theory}');ylabel('Fraction');
% legend('dm','gas');
legend('dm');
x=logspace(-5,-1,10);[n,bin]=histc(mrate,x);
y=zeros(9,1);
for i=1:9
y(i)=median(rdmmax(bin==i&rdmmax>0));
end
figure;loglog(mrate(rdmmax>0),rdmmax(rdmmax>0),'*','markersize',2);
hold on;
plot(mrate(rdmmax>0),Diststrp(rdmmax>0),'ko');
plot(x(2:10),y,'r-','linewidth',4);plot(x,Dstrp(x),'g',x,Dcomp(x),'g',x,Dmean(x),'g-');
xlabel('m/M at m_{max}');ylabel('D/R_{vir}');
set(gca,'xlim',[1e-5,1]);
figure;loglog((2+kt_max(rdmmax>0)),rdmmax(rdmmax>0),'*','markersize',2);xlabel('2+kt at Mmax');ylabel('D/R_{vir} at Mmax');
hold on; x=logspace(log10(2),log10(10),5);plot(x,x.^(1/3),'k-',x,1.25*x.^(1/3),'r-');