program read_example
! caution: whether to use 4byte or 8byte variables depend on the 
!          parameters of each simulation; check param/paramRUNNAME.h 
!          to see if HBT_INT8 and HBT_REAL8 are defined.
use sub_io
implicit none
type (SUBCATALOGUE) SubCat
character(len=1024):: SubDir
integer*4 Nsnap

integer*4,allocatable:: pro2dest(:)
integer*4 Nsubs

integer*4:: Npro,Nsplitter_dest
integer*4,allocatable:: sp2pro(:)

Nsnap=15
SubDir='/home/kambrain/data/6113/subcat' 
!subhalo catalogues for different simulations all located under /home/kambrain/data/***/subcat

call load_sub_catalogue(Nsnap, SubCat, SubDir)
write(*,*)  'Snapshot',Nsnap
write(*,*) 'Ngroups=',SubCat%Ngroups,'Nsubs=',SubCat%Nsubs,'Nids=',SubCat%Nids
write(*,*) 'Nbirth=',SubCat%Nbirth,'NQuasi=',SubCat%NQuasi,'Ndeath=',SubCat%Ndeath,'Nsplitter=',SubCat%Nsplitter 
write(*,*)  'SubLen[0]=',SubCat%SubLen(0),'SubLen[end]=',SubCat%SubLen(SubCat%Nsubs-1)
write(*,*) ''
call free_sub_catalogue(SubCat)

call load_pro2dest(Nsnap,pro2dest,Nsubs,SubDir)
write(*,*) 'Nsubs+Nsplitters_dest=',Nsubs
write(*,*) 'destid(-1:2)=',pro2dest(-1:2)
write(*,*) 'subid=4 has a descendent subid=',pro2dest(4)
write(*,*) ''
call free_pro2dest(pro2dest)

Nsnap=48
call load_sp2pro(Nsnap,Npro,Nsplitter_dest, sp2pro,SubDir)
write(*,*) 'For Descendent Snapshot',Nsnap
write(*,*) Npro,'subhalos at snapshot',Nsnap-1,'split out',Nsplitter_dest,'more'
write(*,*) 'the first splitter is from subid=',sp2pro(Npro),'the last splitter is from subid=',sp2pro(Npro+Nsplitter_dest-1)
write(*,*) 'the subhalo having ProSubID=',Npro+2,' is a descendent of subhalo ID=',sp2pro(Npro+2)
call free_sp2pro(sp2pro)
end program read_example
