%%
RunNum=6409;Nsnap=99;grpid=0;
addpath('../post');
datadir=['/mnt/A4700/data/',num2str(RunNum),'/subcat/anal/massfun/'];
load([datadir,'sub_mass_',num2str(Nsnap,'%03d')]);
load([datadir,'group_offset_',num2str(Nsnap,'%03d')]);
halo=readhalo_size(['/mnt/A4700/data/',num2str(RunNum),'/subcat/profile/logbin'],Nsnap,'halo');

rmin=0;rmax=1;
nbin=15;
% x=logspace(-5.5,-0.8,nbin);
% x=logspace(-0.8,4.9,10);y=[linspace(-0.8,5,10),5+5.8/10];y=y(2:end);
partmass=group_offset_099(1,3)/halo.mass(1);
M0=halo.Mvir(1,2)*partmass;
Rvir=halo.Rvir(1,2);           %almost all subs within Rvir are within the
                               %fof halo rather than from other halos
% Rvir=SubFindgroup_offset_099(1,5);M0=SubFindgroup_offset_099(1,3)*Omega*(Rvir/((G*M0/100/Hz/Hz)^(1.0/3)))^3;%mean_200
% id=(0:size(sub_mass_099,1)-1)';
Rsub=sqrt(sum((sub_mass_099(:,2:4)-repmat(sub_mass_099(1,2:4),size(sub_mass_099,1),1)).^2,2));

figure(1);
subplot(2,2,1);
% subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir&id<group_offset_099(2,1)),1)/M0;
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1)/M0;
xmin=min(subinR);
xmax=max(subinR)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);dlnx=log(x(2))-log(x(1));
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));mfunspec=massfun(1:nbin-1)/dlnx;
loglog(x(2:nbin),summass(nbin:-1:2),'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.6],'--');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.4],':');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^1],'-.');
xlabel('M_{sub}/M_{host}');
ylabel('N(>M_{sub}/M_{host})');
title({[num2str(RunNum),',z=0,biggest fof: M_{crit200}=',num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})'];['for ',num2str(rmin),'*Rvir<R<',num2str(rmax),'*Rvir']})


subplot(2,2,2);
loglog(x(2:nbin),mfunspec,'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.6],'--');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.4],':');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^1],'-.');
xlabel('M_{sub}/M_{host}');
ylabel('dN/dln(M_{sub}/M_{host})');


subplot(2,2,3);
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1);
xmin=min(subinR);
xmax=max(subinR)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);dlnx=log(x(2))-log(x(1));
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));mfunspec=massfun(1:nbin-1)/dlnx;
loglog(x(2:nbin),summass(nbin:-1:2)/M0,'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^0,10^2],[10^0.4,10^-1.4]/100,'--');
hold on; plot([10^0,10^2],[10^0.4,10^-1.6]/100,':');
hold on; plot([10^0,10^2],[10^0.4,10^-1]/100,'-.');
xlabel('M_{sub}');
ylabel('N(>M_{sub})/M_{host})');

subplot(2,2,4);
loglog(x(2:nbin),mfunspec/M0,'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^0,10^2],[10^0.4,10^-1.4]/100,'--');
hold on; plot([10^0,10^2],[10^0.4,10^-1.6]/100,':');
hold on; plot([10^0,10^2],[10^0.4,10^-1]/100,'-.');
xlabel('M_{sub}');
ylabel('dN/dlnM_{sub}/M_{host}');

figure(2);
subplot(2,1,1);
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1)/M0;
xmin=min(subinR);
xmax=max(subinR)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);dlnx=log(x(2))-log(x(1));
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));mfunspec=massfun(1:nbin-1)'./diff(x);
loglog(x(2:nbin),mfunspec,'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^-3.5,10^-1.5],[10^4.8,10^1],'--');
xlabel('M_{sub}/M_{host}');
ylabel('dN/dln(M_{sub}/M_{host})');



subplot(2,1,2);
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1);
xmin=min(subinR);
xmax=max(subinR)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));mfunspec=massfun(1:nbin-1)'./diff(x);
loglog(x(2:nbin),mfunspec/M0,'-- .b','displayname',[num2str(M0*1e10,'%2.1e'),'(M_{sun}h^{-1})']);
hold on; plot([10^0,10^2],[10^-1.4,10^-5.2]/100,'--');
hold on; plot([10^0,10^2],[10^-1.4,10^-5.4]/100,':');
hold on; plot([10^0,10^2],[10^-1.4,10^-4.8]/100,'-.');
xlabel('M_{sub}');
ylabel('dN/dM_{sub}/M_{host}');



%%
rmin=0;rmax=1;
G=43007.1;
Hz=0.1;Omega=0.3;
partmass=0.008848;
% partmass=0.897207;
nbin=20;
x=logspace(-5.5,-0.8,nbin);
% x=logspace(-0.8,4.9,10);y=[linspace(-0.8,5,10),5+5.8/10];y=y(2:end);
M0=SubFindgroup_offset_099(1,3);
Rvir=(G*M0/100/Hz/Hz)^(1.0/3);%Critical_200
                               %almost all subs within Rvir are within the
                               %fof halo rather than from other halos
% Rvir=SubFindgroup_offset_099(1,5);M0=SubFindgroup_offset_099(1,3)*Omega*(Rvir/((G*M0/100/Hz/Hz)^(1.0/3)))^3;%mean_200
id=(0:size(sub_mass_099,1)-1)';id_v5=(0:size(sub_mass_099_v5,1)-1)';id_s=(0:size(SubFind_mass_099,1)-1)';
Rsub=sqrt(sum((sub_mass_099(:,2:4)-repmat(sub_mass_099(1,2:4),size(sub_mass_099,1),1)).^2,2));
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir&id<group_offset_099(2,1)),1)/M0;
% subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1)/M0;
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));
Rsub_v5=sqrt(sum((sub_mass_099_v5(:,2:4)-repmat(sub_mass_099_v5(1,2:4),size(sub_mass_099_v5,1),1)).^2,2));
subinR_v5=sub_mass_099_v5(find(Rsub_v5>rmin*Rvir&Rsub_v5<rmax*Rvir&id_v5<group_offset_099_v5(2,1)),1)/M0;
% subinR_v5=sub_mass_099_v5(find(Rsub_v5>rmin*Rvir&Rsub_v5<rmax*Rvir),1)/M0;
massfun_v5=histc(subinR_v5,x);summass_v5=cumsum(massfun_v5(nbin:-1:1));
Rsub_s=sqrt(sum((SubFind_mass_099(:,3:5)-repmat(SubFind_mass_099(1,3:5),size(SubFind_mass_099,1),1)).^2,2));
subinR_s=SubFind_mass_099(find(Rsub_s>rmin*Rvir&Rsub_s<rmax*Rvir&id_s<SubFindgroup_offset_099(2,2)),1)*partmass/M0;
% subinR_s=SubFind_mass_099(find(Rsub_s>rmin*Rvir&Rsub_s<rmax*Rvir),1)*partmass/M0;
massfun_s=histc(subinR_s,x);summass_s=cumsum(massfun_s(nbin:-1:1));
% figure;
% subplot(3,1,1);loglog(10.^(y+10),summass(10:-1:1)/summass(10),'-- sg');
% subplot(3,1,2);
figure;
subplot(2,1,1);
loglog(x(2:nbin),summass(nbin:-1:2),'- *b');
hold on;
loglog(x(2:nbin),summass_v5(nbin:-1:2),'- or');
loglog(x(2:nbin),summass_s(nbin:-1:2),'- sk');
% cftool(log10(10.^(y)./sub_mass(1)),log10(summass(10:-1:1)));
% subplot(3,1,3);loglog(10.^(y+10),massfun,'-- sg');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.6],'--');
% xlabel('M_{sub}/M_{host}');
ylabel('N(>M_{sub}/M_{host})');
title({'6702,z=0,biggest fof: M_{crit200}=10^{15} (M_{sun}h^{-1})';['for ',num2str(rmin),'*Rvir<R<',num2str(rmax),'*Rvir']})
legend({'BT6','BT5','SUBFIND','slope=-0.9'});

subplot(2,1,2);
Rvir=SubFindgroup_offset_099(1,5);M0=SubFindgroup_offset_099(1,3)*Omega*(Rvir/((G*M0/100/Hz/Hz)^(1.0/3)))^3;%mean_200
Rsub=sqrt(sum((sub_mass_099(:,2:4)-repmat(sub_mass_099(1,2:4),size(sub_mass_099,1),1)).^2,2));
subinR=sub_mass_099(find(Rsub<Rvir),1)/M0;
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));
Rsub_v5=sqrt(sum((sub_mass_099_v5(:,2:4)-repmat(sub_mass_099_v5(1,2:4),size(sub_mass_099_v5,1),1)).^2,2));
subinR_v5=sub_mass_099_v5(find(Rsub_v5<Rvir),1)/M0;
massfun_v5=histc(subinR_v5,x);summass_v5=cumsum(massfun_v5(nbin:-1:1));
Rsub_s=sqrt(sum((SubFind_mass_099(:,3:5)-repmat(SubFind_mass_099(1,3:5),size(SubFind_mass_099,1),1)).^2,2));
subinR_s=SubFind_mass_099(find(Rsub_s<Rvir),1)*partmass/M0;
massfun_s=histc(subinR_s,x);summass_s=cumsum(massfun_s(nbin:-1:1));
loglog(x(2:nbin),summass(nbin:-1:2),'- *b');
hold on;
loglog(x(2:nbin),summass_v5(nbin:-1:2),'- or');
loglog(x(2:nbin),summass_s(nbin:-1:2),'- sk');
% cftool(log10(10.^(y)./sub_mass(1)),log10(summass(10:-1:1)));
% subplot(3,1,3);loglog(10.^(y+10),massfun,'-- sg');
hold on; plot([10^-3.5,10^-1.5],[10^2.4,10^0.6],'--');
xlabel('M_{sub}/M_{host}');ylabel('N(>M_{sub}/M_{host})');
title('6702,z=0,biggest fof: M_{mean200}=10^{15} (M_{sun}h^{-1})')

%%
load group_offset_099
load SubFind_mass_099
load SubFindgroup_offset_099
load sub_mass_099
rmin=0;rmax=1;
G=43007.1;
Hz=0.1;Omega=0.3;
%partmass=0.008848;
partmass=0.897207;
nbin=20;
% x=logspace(-3.8,-0.8,nbin);
% x=logspace(-0.8,4.9,10);y=[linspace(-0.8,5,10),5+5.8/10];y=y(2:end);
M0=SubFindgroup_offset_099(1,3);
Rvir=(G*M0/100/Hz/Hz)^(1.0/3);%Critical_200
                               %almost all subs within Rvir are within the
                               %fof halo rather than from other halos
% Rvir=SubFindgroup_offset_099(1,5);M0=SubFindgroup_offset_099(1,3)*Omega*(Rvir/((G*M0/100/Hz/Hz)^(1.0/3)))^3;%mean_200
id=(0:size(sub_mass_099,1)-1)';id_s=(0:size(SubFind_mass_099,1)-1)';
Rsub=sqrt(sum((sub_mass_099(:,2:4)-repmat(sub_mass_099(1,2:4),size(sub_mass_099,1),1)).^2,2));
subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir&id<group_offset_099(2,1)&id>0),1);
%subinR=sub_mass_099(find(Rsub>rmin*Rvir&Rsub<rmax*Rvir),1);
xmin=min(subinR);
xmax=max(subinR)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);
massfun=histc(subinR,x);summass=cumsum(massfun(nbin:-1:1));
Rsub_s=sqrt(sum((SubFind_mass_099(:,3:5)-repmat(SubFind_mass_099(1,3:5),size(SubFind_mass_099,1),1)).^2,2));
subinR_s=SubFind_mass_099(find(Rsub_s>rmin*Rvir&Rsub_s<rmax*Rvir&id_s<SubFindgroup_offset_099(2,2)&id_s>0),1)*partmass;
%subinR_s=SubFind_mass_099(find(Rsub_s>rmin*Rvir&Rsub_s<rmax*Rvir),1)*partmass;
massfun_s=histc(subinR_s,x);summass_s=cumsum(massfun_s(nbin:-1:1));
figure;
loglog(x(2:nbin),summass(nbin:-1:2),'- *b');
hold on;
loglog(x(2:nbin),summass_s(nbin:-1:2),'- sk');
hold on; plot([10^1.5,10^3.5],[10^2.4,10^0.6],'--');
xlabel('M_{sub}(10^{10}Msun/h)');
ylabel('N(>M_{sub}/M_{host})');
title({'6702,z=0,biggest fof: M_{crit200}=10^{15} (M_{sun}h^{-1})';['for ',num2str(rmin),'*Rvir<R<',num2str(rmax),'*Rvir']})

load group_offset_099_h
load SubFind_mass_099_h
load SubFindgroup_offset_099_h
load sub_mass_099_h
partmass_h=0.008848;
nbin=30;
% x=logspace(-5.5,-0.8,nbin);
% x=logspace(-0.8,4.9,10);y=[linspace(-0.8,5,10),5+5.8/10];y=y(2:end);
M0_h=SubFindgroup_offset_099_h(1,3);
Rvir_h=(G*M0_h/100/Hz/Hz)^(1.0/3);%Critical_200
                               %almost all subs within Rvir are within the
                               %fof halo rather than from other halos
% Rvir=SubFindgroup_offset_099(1,5);M0=SubFindgroup_offset_099(1,3)*Omega*(Rvir/((G*M0/100/Hz/Hz)^(1.0/3)))^3;%mean_200
id_h=(0:size(sub_mass_099_h,1)-1)';id_s_h=(0:size(SubFind_mass_099_h,1)-1)';
Rsub_h=sqrt(sum((sub_mass_099_h(:,2:4)-repmat(sub_mass_099_h(1,2:4),size(sub_mass_099_h,1),1)).^2,2));
subinR_h=sub_mass_099_h(find(Rsub_h>rmin*Rvir_h&Rsub_h<rmax*Rvir_h&id_h<group_offset_099_h(2,1)&id_h>0),1);
%subinR_h=sub_mass_099_h(find(Rsub_h>rmin*Rvir_h&Rsub_h<rmax*Rvir_h),1);
xmin=min(subinR_h);
xmax=max(subinR_h)*1.001;
x=logspace(log10(xmin),log10(xmax),nbin);
massfun_h=histc(subinR_h,x);summass_h=cumsum(massfun_h(nbin:-1:1));
Rsub_s_h=sqrt(sum((SubFind_mass_099_h(:,3:5)-repmat(SubFind_mass_099_h(1,3:5),size(SubFind_mass_099_h,1),1)).^2,2));
subinR_s_h=SubFind_mass_099_h(find(Rsub_s_h>rmin*Rvir_h&Rsub_s_h<rmax*Rvir_h&id_s_h<SubFindgroup_offset_099_h(2,2)&id_s_h>0),1)*partmass_h;
%subinR_s_h=SubFind_mass_099_h(find(Rsub_s_h>rmin*Rvir_h&Rsub_s_h<rmax*Rvir_h),1)*partmass_h;
massfun_s_h=histc(subinR_s_h,x);summass_s_h=cumsum(massfun_s_h(nbin:-1:1));
hold on;
loglog(x(2:nbin),summass_h(nbin:-1:2),'-- *g');
hold on;
loglog(x(2:nbin),summass_s_h(nbin:-1:2),'-- sy');
legend({'BT6Low','SUBFINDLow','slope=-0.9','BT6high','SUBFINDhigh'});
M0/M0_h
Rvir/Rvir_h