function [Ninfall,t,r,v,vt2,kt,mdm,mhost,chost,Hz,Rvir,virialF,virsub]=get_DMstrp_history(hist_bin,pmass,SnapInfall,infall_trunc,merger_trunc,mass_cut)

global G a HUBBLE0 Omega0 OmegaLambda

vc2=@(x) (log(1+x)-x./(1+x))./x;

Nnode=hist_bin.Nnode;
if infall_trunc
    if SnapInfall>=0&&SnapInfall<100
        for s=1:Nnode
            if hist_bin.node(s).Nsnap==SnapInfall
                Node_infall=s;
                break;
            end
        end
        % [mmax,Node_infall]=max(mdm);%pick global maximum as infall
        if mass_cut
        mcut=zeros(Nnode,1);
        if mass_cut==1
            for s=1:Nnode
            mcut(s)=hist_bin.node(s).mass(1);
            end
        end
        [mmax,s]=max(mcut(Node_infall:end));
        Node_infall=s+Node_infall-1;%pick maximum after strip as infall
        end
    else
        Node_infall=-1;
    end%pick strip as infall
else
    Node_infall=1;
end

if merger_trunc
    for sm=Node_infall:-1:max(2,Node_infall-1)%discard this history if a major merger has just happened within two snapshots before
        if hist_bin.node(sm).mass(2)>1.5*hist_bin.node(sm-1).mass(2);
            Node_infall=-1;
            break;
        end
    end
end

if Node_infall>0
    Ninfall=Nnode-Node_infall+1;
    t=zeros(Ninfall,1);
    mdm=zeros(Ninfall,1);
    mhost=zeros(Ninfall,1);
%     mcen=zeros(Ninfall,1);
    chost=zeros(Ninfall,1);
    r=zeros(Ninfall,1);
    v=zeros(Ninfall,1);
    vt2=zeros(Ninfall,1);
    kt=zeros(Ninfall,1);
    Hz=zeros(Ninfall,1);
    Rvir=zeros(Ninfall,1);
    virialF=zeros(Ninfall,1);
%     virsub=hist_bin.node(Node_infall).mass(4)/hist_bin.node(Node_infall).mass(1);
    virsub=zeros(Ninfall,1);
    for s=Node_infall:Nnode
        snapnum=hist_bin.node(s).Nsnap;
        i=s-Node_infall+1;
        t(i)=log(a(hist_bin.node(s).Nsnap+1));
        mdm(i)=hist_bin.node(s).mass(1);
%         mdm(i)=hist_bin.node(s).mass(4);%including sub-in-sub mass
        mhost(i)=hist_bin.node(s).mass(2);
%         mcen(i)=hist_bin.node(s).mass(3);
        chost(i)=hist_bin.node(s).chost;
        Vel=hist_bin.node(s).vel;
        Pos=hist_bin.node(s).pos*a(snapnum+1);%physical
        r(i)=sqrt(sum(Pos.^2,1));
        v(i)=sqrt(sum(Vel.^2,1));
        mu=G*mhost(i)*pmass;
        vt2(i)=v(i)^2*(1-(Pos'*Vel/r(i)/v(i))^2);
        scaleF=a(snapnum+1);
%         Rvir(i)=halo{snapnum+1}.Rvir(hist_bin.node(s).HostID+1,1)*scaleF;
        Hz(i)=HUBBLE0 * sqrt(Omega0 /scaleF^3+ (1 -Omega0 -OmegaLambda) / scaleF^2 +OmegaLambda);
        Hratio=Hz(i)/HUBBLE0;
        OmegaZ=Omega0/scaleF^3/Hratio^2;
    	virialF(i)=18.0*pi^2+82.0*(OmegaZ-1)-39.0*(OmegaZ-1)^2;
        Rvir(i)=(2.0*G*mhost(i)*pmass/virialF(i)/Hz(i)^2)^(1.0/3);%physical
        kt(i)=vt2(i)/(mu/Rvir(i))*vc2(chost(i))/vc2(r(i)*chost(i)/Rvir(i));
        virsub(i)=hist_bin.node(s).mass(4)/hist_bin.node(s).mass(1);
    end
else
    Ninfall=0;
    t=0;
    mdm=0;
    mhost=0;
    chost=0;
    r=0;
    v=0;
    vt2=0;
    kt=0;
    Hz=0;
    Rvir=0;
    virialF=0;
    virsub=0;
end

if Ninfall>0  %truncate for merger
if merger_trunc    
smerge=Ninfall+1;%host major merger happens at this snap
for sm=2:Ninfall
    if mhost(sm)>1.5*mhost(sm-1)
        smerge=sm;
%         smerge=max(2,sm-3);
        break;
    end
end
Ninfall=smerge-1;
end
if mass_cut==1 %DM mass trunc   
smerge=Ninfall+1;%host major merger happens at this snap
for sm=2:Ninfall
    if mdm(sm)<100
        smerge=sm;
        break;
    end
    if mdm(sm)/mdm(1)<0.01
        smerge=sm;
        break;
    end
end
Ninfall=smerge-1;
elseif mass_cut~=0
    error('wrong mass_cut');
end
t=t(1:Ninfall);
mdm=mdm(1:Ninfall);
mhost=mhost(1:Ninfall);
% mhost=mcen(1:Ninfall);
chost=chost(1:Ninfall);
r=r(1:Ninfall);
v=v(1:Ninfall);
vt2=vt2(1:Ninfall);
kt=kt(1:Ninfall);
Hz=Hz(1:Ninfall);
Rvir=Rvir(1:Ninfall);
virialF=virialF(1:Ninfall);
virsub=virsub(1:Ninfall);
end