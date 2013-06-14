function DMmax=Dist_Mmax(hist_bin,Snappar,pmass,Mratepar)
global a
G=43007.1;

Nhist=size(hist_bin,1);
%    rgasmax=zeros(Nhist,1)-1;
   rdmmax=zeros(Nhist,1)-1;
   mrate=zeros(Nhist,1)-1;
   Diststrp=zeros(Nhist,1)-1;
for h=1:Nhist
    Nnode=hist_bin{h}.Nnode;
    mdm=zeros(Nnode,1);
%     mgas=zeros(Nnode,1);
    mhost=zeros(Nnode,1);
    Node_infall=-1;
    Node_strp=-1;
    for s=1:Nnode
        mdm(s)=hist_bin{h}.node(s).mass(1);
%         mgas(s)=hist_bin{h}.node(s).mass(5);
        mhost(s)=hist_bin{h}.node(s).mass(2);
        if hist_bin{h}.node(s).Nsnap==Snappar(h,2)
            if s==1||mdm(s)>mdm(s-1)
            Node_strp=s;
            else
                Node_strp=s-1;
            end
        end
        if hist_bin{h}.node(s).Nsnap==Snappar(h,3)
            if mdm(s)>300
            Node_infall=s;
            end
        end
    end
    if Node_strp>0
        Diststrp(h)=norm(hist_bin{h}.node(Node_strp).pos)/comoving_virial_radius(mhost(Node_strp)*pmass,a(hist_bin{h}.node(Node_strp).Nsnap+1));
    end
    if Node_infall>0
    [tmp,idm]=max(mdm(1:Node_infall));
%     [tmp,igas]=max(mgas(1:Node_infall));
%     rdmmax(h)=norm(hist_bin{h}.node(idm).pos)/halo{hist_bin{h}.node(idm).Nsnap+1}.Rvir(hist_bin{h}.node(idm).HostID+1,1);
    rdmmax(h)=norm(hist_bin{h}.node(idm).pos)/comoving_virial_radius(mhost(idm)*pmass,a(hist_bin{h}.node(idm).Nsnap+1));
%     rgasmax(h)=norm(hist_bin{h}.node(igas).pos)/comoving_virial_radius(mhost(igas)*pmass,a(hist_bin{h}.node(igas).Nsnap+1));
%     mrate(h)=mdm(idm)/mhost(idm);
    mrate(h)=Mratepar(h,2);
    end
end
% DMmax=[Diststrp,rdmmax,rgasmax,mrate];
DMmax=[Diststrp,rdmmax,mrate];