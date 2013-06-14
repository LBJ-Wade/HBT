G=43007.1;pmass=0.008848;gmass=0.00156133;

hist_bin=load_hist_bin('/mnt/A4700/data/6702/subcat/anal/history_000_005.dat');
a=load('/home/kam/Documents/research/Galaxy/code/BoundTracing/v7.9/anal/Matlab/outputs_zoom.txt');
age=a;
for i=1:100
    age(i)=cosmo_time(0,a(i),0.3,0.7,0.1);
end
Nhist=size(hist_bin,1);
file='/mnt/A4700/data/6702/subcat/anal/historypar_000_005.dat';
[Snappar,Mratepar,Mhostpar,Rhostpar,Kpar,j2par,Kerrpar,j2errpar,Chostpar,Csatpar]=load_hist_par(file);

j2=j2par(:,2);
e2=1-j2;
K=Kpar(:,2);
%%
HUBBLE0=0.1;Omega0=0.3;OmegaLambda=0.7;
%  Hz=HUBBLE0 * sqrt(Omega0 /scaleF^3+ (1 -Omega0 -OmegaLambda) / scaleF^2 +OmegaLambda);
%%
% params: E,h,Mhost,Msat/Mhost,T
G=43007.1;
set(0,'DefaultFigureWindowStyle','docked') ;
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    t=zeros(Nnode,1);
    r=zeros(Nnode,1);
    mdm=zeros(Nnode,1);
    mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    mcen=zeros(Nnode,1);
    for s=1:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        t(s)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(s)=hist_bin{h}.node(s).mass(1);
        mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        mcen(s)=hist_bin{h}.node(s).mass(3);
        r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if Snappar(h,3)>=40
            Nodeinfall(h)=s-1;
            else
            Nodeinfall(h)=-1;
            end
        end
    end
    s=Nodeinfall(h);
    smerge=Nnode+1;%host major merger happens at this snap
    s0=max(s,2);
    for sm=s0:Nnode
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
%     smerge=Nnode+1;
    snapsmooth=s:smerge-1;
    if s>0&&~isempty(snapsmooth)
        if e2(h)>0&&e2(h)<0.4 
          %           subplot(2,1,1); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)/mgas(s),'- .');hold on;
          %           subplot(2,1,2); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),'- .');hold on;
         figure(1);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if e2(h)>0.6&&e2(h)<0.9 
         figure(2);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if e2(h)>0.9&&e2(h)<1 
         figure(3);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if e2(h)>1.2&&e2(h)<1.4 
         figure(4);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
    end
    
end 
% for i=1:4
% figure(i);
% subplot(2,1,1);axis([0,0.2,0,1]);hold off;set(gca,'yscale','linear');
% subplot(2,1,2);axis([0,0.2,0,1]);hold off;set(gca,'yscale','linear');
% end
%%
G=43007.1;
set(0,'DefaultFigureWindowStyle','docked') ;
es=[];
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    t=zeros(Nnode,1);
    r=zeros(Nnode,1);
    mdm=zeros(Nnode,1);
    mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    mcen=zeros(Nnode,1);
    for s=1:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        t(s)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(s)=hist_bin{h}.node(s).mass(1);
        mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        mcen(s)=hist_bin{h}.node(s).mass(3);
        r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if Snappar(h,3)>=40
            Nodeinfall(h)=s-1;
            else
            Nodeinfall(h)=-1;
            end
        end
    end
    s=Nodeinfall(h);
    smerge=Nnode+1;%host major merger happens at this snap
    s0=max(s,2);
    for sm=s0:Nnode
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
%     smerge=Nnode+1;
    snapsmooth=s:smerge-1;
    if s>0&&~isempty(snapsmooth) %&&e2(h)>0&&e2(h)<0.9
%         es=[es;log10(Mhostpar(h,2))];
        if Mhostpar(h,2)>10^4&&Mhostpar(h,2)<10^5 
          %           subplot(2,1,1); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)/mgas(s),'- .');hold on;
          %           subplot(2,1,2); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),'- .');hold on;
         figure(1);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Mhostpar(h,2)>10^5&&Mhostpar(h,2)<10^6
         figure(2);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Mhostpar(h,2)>10^6&&Mhostpar(h,2)<10^7
         figure(3);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Mhostpar(h,2)>10^7&&Mhostpar(h,2)<10^8
         figure(4);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
    end
    
end 
for i=1:4
figure(i);
subplot(2,1,1);axis([0,0.2,0,1]);hold off;%set(gca,'yscale','log');
subplot(2,1,2);axis([0,0.2,0,1]);hold off;%set(gca,'yscale','log');
end
% hist(es,40)
%%
G=43007.1;
set(0,'DefaultFigureWindowStyle','docked') ;
es=[];
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    t=zeros(Nnode,1);
    r=zeros(Nnode,1);
    mdm=zeros(Nnode,1);
    mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    mcen=zeros(Nnode,1);
    for s=1:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        t(s)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(s)=hist_bin{h}.node(s).mass(1);
        mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        mcen(s)=hist_bin{h}.node(s).mass(3);
        r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if Snappar(h,3)>=40
            Nodeinfall(h)=s-1;
            else
            Nodeinfall(h)=-1;
            end
        end
    end
    s=Nodeinfall(h);
    smerge=Nnode+1;%host major merger happens at this snap
    s0=max(s,2);
    for sm=s0:Nnode
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
%     smerge=Nnode+1;
    snapsmooth=s:smerge-1;
    if s>0&&~isempty(snapsmooth) %&&e2(h)>0&&e2(h)<0.9
%         es=[es;log10(Mhostpar(h,2))];
        if Kpar(h,2)>10^-1&&Kpar(h,2)<1
          %           subplot(2,1,1); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)/mgas(s),'- .');hold on;
          %           subplot(2,1,2); plot((t(snapsmooth)-t(s))/T(h),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),'- .');hold on;
         figure(1);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Kpar(h,2)>1&&Kpar(h,2)<1.5
         figure(2);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Kpar(h,2)>1.5&&Kpar(h,2)<2
         figure(3);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Kpar(h,2)>2&&Kpar(h,2)<3
         figure(4);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Kpar(h,2)>3&&Kpar(h,2)<5
         figure(5);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
        if Kpar(h,2)>5&&Kpar(h,2)<100
         figure(6);
            subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),' .');hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)./mdm(snapsmooth)/(mgas(s)/mdm(s)),' .');hold on;
        end
    end
end 
for i=1:6
figure(i);
subplot(2,1,1);axis([0,0.2,0,1]);hold off;%set(gca,'yscale','log');
subplot(2,1,2);axis([0,0.2,0,1]);hold off;%set(gca,'yscale','log');
end
%set(0,'DefaultFigureWindowStyle','normal') ;
%%
% set(0,'DefaultFigureWindowStyle','docked') ;
es=[];
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    for s=1:Nnode
        if hist_bin{h}.node(s).Nsnap==Snappar(h,2)
            if Snappar(h,2)>=40
            Node_infall=s-1;
            else
            Node_infall=-1;
            end
            break;
        end
    end
     Ninfall=Nnode-Node_infall+1;
    if Node_infall>0
    t=zeros(Ninfall,1);
%     r=zeros(Nnode,1);
    mdm=zeros(Ninfall,1);
    mgas=zeros(Ninfall,1);
    mhost=zeros(Ninfall,1);
    mcen=zeros(Ninfall,1);
    df_dt=zeros(Ninfall,1);
    ft=ones(Ninfall,1);
    for s=Node_infall:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        snapnum=hist_bin{h}.node(s).Nsnap;
        i=s-Node_infall+1;
        t(i)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(i)=hist_bin{h}.node(s).mass(1);
        mgas(i)=hist_bin{h}.node(s).mass(5);
        mhost(i)=hist_bin{h}.node(s).mass(2);
        mcen(i)=hist_bin{h}.node(s).mass(3);
%         r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        Vel=hist_bin{h}.node(s).vel;
        Pos=hist_bin{h}.node(s).pos*a(snapnum+1);%physical
        r=sqrt(sum(Pos.^2,1));
        v=sqrt(sum(Vel.^2,1));
%         Mvir=halo{snapnum+1}.Mvir(hist_bin{h}.node(s).HostID+1,1);
%         Rvir=halo{snapnum+1}.Rvir(hist_bin{h}.node(s).HostID+1,1)*a(snapnum+1);
        scaleF=a(snapnum+1);
        Hz=HUBBLE0 * sqrt(Omega0 /scaleF^3+ (1 -Omega0 -OmegaLambda) / scaleF^2 +OmegaLambda);
        Hratio=Hz/HUBBLE0;
        OmegaZ=Omega0/scaleF^3/Hratio^2;
    	virialF=18.0*3.1416*3.1416+82.0*(1-OmegaZ)-39.0*(1-OmegaZ)^2;
        if i>1
        ft(i)=ft(i-1)+df_dt(i-1)*0.0116;
        end
        mrate=mdm(i)/mhost(i);
%         mrate=Mratepar(h,2);
        df_dt(i)=(sqrt(178)-ft(i)*mrate^(-1./3)*(v/r)/Hz)/2/pi;
%         df_dt(i)=(sqrt(virialF)-par_gas(h,1)*(ft(i)^par_gas(h,3))*mrate^(-1./3)*(v/r/Hz))/2/pi/par_gas(h,2);
%       df_dt(i)=-sqrt(178)+178/ft(i)*mrate^(1./3)*(r/v)*Hz;
    end
    
    smerge=Ninfall+1;%host major merger happens at this snap
    for sm=2:Ninfall
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
% smerge=Nnode+1;
% smerge=min(s+8,smerge);
    snapsmooth=1:smerge-1;
    if ~isempty(snapsmooth)&&numel(snapsmooth)>6 %&&e2(h)>0&&e2(h)<0.9
%         es=[es;log10(Mhostpar(h,2))];
%         if Mratepar(h,2)>0.01&&Mratepar(h,2)<0.012
       Astrp=sum(mgas(snapsmooth)/mgas(1));
       Cstrp=Astrp/sqrt(8*sum((mgas(snapsmooth)/mgas(1)).^2));
         figure(1);
            subplot(2,1,1); plot((t(snapsmooth)-t(1)),mgas(snapsmooth)/mgas(1),'- .','userdata',h);hold on;
            subplot(2,1,2); plot((t(snapsmooth)-t(1)),ft(snapsmooth),'r-- o','userdata',h);hold on;
%         end
%         if Mratepar(h,2)>0.09&&Mratepar(h,2)<0.1
%         figure(2);
%             subplot(2,1,1); plot((t(snapsmooth)-t(s)),mgas(snapsmooth)/mgas(s),'- .','userdata',h);hold on;
%             subplot(2,1,2); plot((t(snapsmooth)-t(s)),cumsum([0;df_dt(snapsmooth(1:end-1))])*0.0116+1,'r-- o','userdata',h);hold on;
%         end
    end
    end
end 
for i=1:1
figure(i);
subplot(2,1,1);axis([0,0.3,0,1]);hold off;xlabel('\Deltaln(a)');ylabel('Mgas/Mgas(0)');title('simulation,z_{infall}>1,m/M~[0.01,0.1]')%set(gca,'yscale','log');
subplot(2,1,2);axis([0,0.3,0,1]);hold off;xlabel('\Deltaln(a)');ylabel('Mgas/Mgas(0)');title('Model: df/dln(a)=2-(M/m)^{1/3}*(v/r)*\tau_h');%set(gca,'yscale','log');
end
%%
G=43007.1;
set(0,'DefaultFigureWindowStyle','docked') ;
Astrp=zeros(Nhist,1);
Cstrp=zeros(Nhist,1);
flagstrp=zeros(Nhist,1);
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    t=zeros(Nnode,1);
    r=zeros(Nnode,1);
    mdm=zeros(Nnode,1);
    mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    mcen=zeros(Nnode,1);
    for s=1:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        t(s)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(s)=hist_bin{h}.node(s).mass(1);
        mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        mcen(s)=hist_bin{h}.node(s).mass(3);
        r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if Snappar(h,3)>=40
            Nodeinfall(h)=s-1;
            else
            Nodeinfall(h)=-1;
            end
        end
    end
    s=Nodeinfall(h);
    smerge=Nnode+1;%host major merger happens at this snap
    s0=max(s,2);
    for sm=s0:Nnode
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
%     smerge=Nnode+1;
smerge=min(s+8,smerge);
    snapsmooth=s:smerge-1;
    if s>0&&~isempty(snapsmooth)
       Astrp(h)=sum(mgas(snapsmooth)/mgas(s));
       Cstrp(h)=Astrp(h)/sqrt(8*sum((mgas(snapsmooth)/mgas(s)).^2));
    end 
end
% figure;plot3(K(Astrp>0),e2(Astrp>0),Astrp(Astrp>0),'.');set(gca,'xscale','log','yscale','log');
% figure;plot3(K(Astrp>0),e2(Astrp>0),Cstrp(Astrp>0),'.');set(gca,'xscale','log','yscale','log');xlabel('K');ylabel('e2');zlabel('C');
figure;subplot(2,1,1);semilogx(K(Astrp>0),Cstrp(Astrp>0),'.');xlabel('2K/U');ylabel('Correlation coeff');
subplot(2,1,2);semilogx(e2(Astrp>0),Cstrp(Astrp>0),'.');xlabel('e^2');ylabel('Correlation coeff');
figure;subplot(2,1,1);semilogx(K(Astrp>0),Astrp(Astrp>0),'.');xlabel('2K/U');ylabel('Area');
subplot(2,1,2);semilogx(e2(Astrp>0),Astrp(Astrp>0),'.');xlabel('e^2');ylabel('Area');
%%
set(0,'DefaultFigureWindowStyle','normal') ;
h=730
    Nnode=hist_bin{h}.Nnode;
    t=zeros(Nnode,1);
    r=zeros(Nnode,1);
    mdm=zeros(Nnode,1);
    mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    mcen=zeros(Nnode,1);
    for s=1:Nnode
%         t(s)=age(hist_bin{h}.node(s).Nsnap+1);
        t(s)=log(a(hist_bin{h}.node(s).Nsnap+1));
        mdm(s)=hist_bin{h}.node(s).mass(1);
        mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        mcen(s)=hist_bin{h}.node(s).mass(3);
        r(s)=sqrt(sum((hist_bin{h}.node(s).pos*a(hist_bin{h}.node(s).Nsnap+1)).^2,1));
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if Snappar(h,3)>=40
            Nodeinfall(h)=s-1;
            else
            Nodeinfall(h)=-1;
            end
        end
    end
    s=Nodeinfall(h);
    smerge=Nnode+1;%host major merger happens at this snap
    s0=max(s,2);
    for sm=s0:Nnode
        if mhost(sm)>1.5*mhost(sm-1)
            smerge=sm;
            break;
        end
        if mgas(sm)<30
            smerge=sm;
            break;
        end
    end
%     smerge=Nnode+1;
    snapsmooth=s:smerge-1;
cftool(t(snapsmooth)-t(s),mgas(snapsmooth)/mgas(s))
