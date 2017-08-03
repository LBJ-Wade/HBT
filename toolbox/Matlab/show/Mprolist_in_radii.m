function [Msubs,Mhost,Rvir]=Mprolist_in_radii(basedir,virtype,Nsnap,grpid,rmin,rmax,datatype,plottype)
% list subhalo masses inside radius [rmin*Rvir,rmax*Rvir]
% return Msubs and host virial mass in units 10^10Msun/h

switch datatype
    case 'textdata'
%         datadir=['/mnt/A4700/data/',RunName,'/subcat/anal/massfun/'];
        massdata=load([datadir,'sub_mass_',num2str(Nsnap,'%03d')]);
        groupdata=load([datadir,'group_offset_',num2str(Nsnap,'%03d')]);
        halo=readhalo_size(['/mnt/A4700/data/',num2str(RunNum),'/subcat/profile/logbin'],Nsnap,'halo');

        partmass=groupdata(grpid+1,3)/halo.mass(grpid+1);
        Mhost=halo.Mvir(grpid+1,virtype+1)*partmass;
        Rvir=halo.Rvir(grpid+1,virtype+1);           %almost all subs within Rvir are within the
        %fof halo rather than from other halos
        center_id=groupdata(grpid+1,1)+1;
        Rsub=sqrt(sum((massdata(:,2:4)-repmat(massdata(center_id,2:4),size(massdata,1),1)).^2,2));
        massdata(center_id,:)=[];Rsub(center_id,:)=[];%exclude central sub
        Msubs=massdata(Rsub>rmin*Rvir&Rsub<rmax*Rvir,1);
    case 'bindata'
%         datadir=['/mnt/A4700/data/',RunName,'/subcat/anal/massfun/'];
        Minf=importdata([basedir,'steller/SnapInfall_first_',num2str(Nsnap,'%03d')],',',1);
%         Minf=importdata([basedir,'steller/SnapInfall_',num2str(Nsnap,'%03d')],',',1);
        submass=Minf.data(:,1);%SubLenInfall
%         submass=read_submass([basedir,'massfun/submass_',num2str(Nsnap,'%03d')]);
        subcom=read_subcom([basedir,'massfun/subcom_',num2str(Nsnap,'%03d')]);
        massdata=[submass,subcom];
        clear submass subcom
        cenid=read_cid([basedir,'massfun/cid_',num2str(Nsnap,'%03d')]);
        switch virtype
            case 0
                grpsize=read_grpsize([basedir,'massfun/grpsizeVIR_',num2str(Nsnap,'%03d')]);
            case 1
                grpsize=read_grpsize([basedir,'massfun/grpsizeC200_',num2str(Nsnap,'%03d')]);
            case 2
                grpsize=read_grpsize([basedir,'massfun/grpsizeB200_',num2str(Nsnap,'%03d')]);
        end
        Mhost=grpsize(grpid+1,1);
        Rvir=grpsize(grpid+1,2);
        clear grpsize
        center_id=cenid(grpid+1)+1;
        Rsub=sqrt(sum((massdata(:,2:4)-repmat(massdata(center_id,2:4),size(massdata,1),1)).^2,2));
        massdata(center_id,:)=[];Rsub(center_id,:)=[];%exclude central sub
        Msubs=massdata(Rsub>rmin*Rvir&Rsub<rmax*Rvir,1);
        Msubs=Msubs(Msubs>0);
%         Msubs(Msubs<5*min(Msubs))=[];%exclude subs with less than 100 particles
    otherwise
        error('wrong datafile type');
end
switch plottype
    case 'norm'
%uncomment for normalized mass function:
         Msubs=Msubs/Mhost;
    otherwise
end