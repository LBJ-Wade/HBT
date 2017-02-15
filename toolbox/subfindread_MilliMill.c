#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "datatypes.h"
#include "intra_vars.h"
#include "iovars.h"
#include "proto.h"

#define myfread(a,b,c,d) fread_swap(a,b,c,d,ByteOrder)

//~ typedef IDatReal MyReal; //shit, the real type for subfind is not necessarily the same as snapshot
//~ typedef double MyReal;
typedef float MyReal;  
typedef IDatInt MyInt;


static int *GroupLen,*GroupOffset;
static MyReal *GroupMass,*GroupPos;
static long long TotNids;
static int Ngroups,Nids,TotNgroups,TotNsubhalos,NFiles;
static int *groupIDs, *SubMostBoundID;
static int Nsubhalos, *SubParentSub, *SubOffset, *SubLen, *FirstSubOfHalo, *NsubPerHalo,*SubHostHalo;
static MyReal *SubPos, *SubVel, *SubVelDisp, *SubVmax, *SubSpin;
static MyReal *Halo_M_Mean200, *Halo_R_Mean200, *Halo_M_Crit200, *Halo_R_Crit200, *Halo_M_TopHat200,
*Halo_R_TopHat200;
static MyReal *SubMass, *SubCoM, *SubRmax, *SubRHalf;
static int *Ncontam;  //number of contamination particles
static MyReal *Mcontam;

void subread(int Nsnap,char *subdir)
{
  FILE *fd;
  char buf[1024];
   int SnapshotNum,ByteOrder;
   int i;
   #ifdef SNAPLIST
   SnapshotNum=snaplist[Nsnap];
   #else
   SnapshotNum=Nsnap;
   #endif
   int FileCounts, grpfile_type;
   
  long long Nloadgrp=0, Nloadsub=0;
  TotNids=0;TotNsubhalos=0;
  FileCounts=find_group_file(SnapshotNum, subdir, &grpfile_type);
  for(i=0;i<FileCounts;i++)
  {
  sprintf(buf, "%s/postproc_%03d/sub_tab_%03d.%d",subdir,SnapshotNum,SnapshotNum,i);
  printf("Reading %s...\n", buf);fflush(stdout);
  
   ByteOrder=check_grpcat_byteorder(buf, FileCounts);
  
  myfopen(fd,buf,"r");
    
  myfread(&Ngroups, sizeof(int), 1, fd);
  myfread(&Nids, sizeof(int), 1, fd);
  TotNids+=Nids;
  myfread(&TotNgroups, sizeof(int), 1, fd);
  myfread(&NFiles, sizeof(int), 1, fd);
  myfread(&Nsubhalos, sizeof(int), 1, fd);
  TotNsubhalos+=Nsubhalos;
  if(FileCounts!=NFiles)
	  {
		  fprintf(stderr,"error: number of files specified not the same as stored: %d,%d\n",
		  FileCounts,NFiles);
		  fflush(stderr);
		  exit(1);
	  }
  }
  for(i=0;i<FileCounts;i++)
  {
 // if(FileCounts>0)	  
  sprintf(buf, "%s/postproc_%03d/sub_tab_%03d.%d",subdir,SnapshotNum,SnapshotNum,i);
  printf("Reading %s...\n", buf);fflush(stdout);
 // else
 // sprintf(buf, "%s/subhalo_tab_%03d",subdir,SnapshotNum);
  
   ByteOrder=check_grpcat_byteorder(buf, FileCounts);
  
  myfopen(fd,buf,"r");
    
  myfread(&Ngroups, sizeof(int), 1, fd);
  myfread(&Nids, sizeof(int), 1, fd);
  myfread(&TotNgroups, sizeof(int), 1, fd);
  myfread(&NFiles, sizeof(int), 1, fd);
  myfread(&Nsubhalos, sizeof(int), 1, fd);
  
  if(0==i)
  {
  GroupLen=malloc(TotNgroups * sizeof(int));
  GroupOffset=malloc(TotNgroups * sizeof(int));
  GroupMass=malloc(TotNgroups * sizeof(MyReal));
  GroupPos=malloc(TotNgroups * sizeof(MyReal)*3);	    
  NsubPerHalo = malloc(TotNgroups * sizeof(int));
  FirstSubOfHalo =malloc(TotNgroups * sizeof(int));
  Halo_M_Mean200 = malloc(TotNgroups * sizeof(MyReal));
  Halo_R_Mean200 = malloc(TotNgroups * sizeof(MyReal));
  Halo_M_Crit200 = malloc(TotNgroups * sizeof(MyReal));
  Halo_R_Crit200 = malloc(TotNgroups * sizeof(MyReal));
  Halo_M_TopHat200 = malloc(TotNgroups * sizeof(MyReal));
  Halo_R_TopHat200 = malloc(TotNgroups * sizeof(MyReal));
  SubLen = malloc(TotNsubhalos * sizeof(int));
  SubOffset = malloc(TotNsubhalos * sizeof(int));
  SubParentSub = malloc(TotNsubhalos * sizeof(int));
  SubPos = malloc(TotNsubhalos * 3 * sizeof(MyReal));//center of minimum potential
  SubVel = malloc(TotNsubhalos * 3 * sizeof(MyReal));
  SubCoM = malloc(TotNsubhalos * 3 * sizeof(MyReal));
  SubVelDisp = malloc(TotNsubhalos * sizeof(MyReal));
  SubVmax = malloc(TotNsubhalos * sizeof(MyReal));
  SubSpin = malloc(TotNsubhalos * 3 * sizeof(MyReal));
  SubMostBoundID = malloc(TotNsubhalos * sizeof(MyInt));
  SubRHalf = malloc(TotNsubhalos * sizeof(MyReal));
  Ncontam=malloc(sizeof(int)*TotNgroups);
  Mcontam=malloc(sizeof(MyReal)*TotNgroups);
  SubMass=malloc(sizeof(MyReal)*TotNsubhalos);
  SubRmax=malloc(sizeof(MyReal)*TotNsubhalos);
  SubHostHalo=malloc(sizeof(int)*TotNsubhalos);
  }
  myfread(NsubPerHalo+Nloadgrp, sizeof(int), Ngroups, fd);
  myfread(FirstSubOfHalo+Nloadgrp, sizeof(int), Ngroups, fd);
  
  myfread(SubLen+Nloadsub, sizeof(int), Nsubhalos, fd);
  myfread(SubOffset+Nloadsub, sizeof(int), Nsubhalos, fd);
  myfread(SubParentSub+Nloadsub, sizeof(int), Nsubhalos, fd);

  myfread(Halo_M_Mean200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  myfread(Halo_R_Mean200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  myfread(Halo_M_Crit200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  myfread(Halo_R_Crit200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  myfread(Halo_M_TopHat200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  myfread(Halo_R_TopHat200+Nloadgrp, sizeof(MyReal), Ngroups, fd);
  
  Nloadgrp+=Ngroups;

  myfread(SubPos+Nloadsub*3, 3 * sizeof(MyReal), Nsubhalos, fd);
  myfread(SubVel+Nloadsub*3, 3 * sizeof(MyReal), Nsubhalos, fd);
  myfread(SubVelDisp+Nloadsub, sizeof(MyReal), Nsubhalos, fd);
  myfread(SubVmax+Nloadsub, sizeof(MyReal), Nsubhalos, fd);
  myfread(SubSpin+Nloadsub*3, 3 * sizeof(MyReal), Nsubhalos, fd);
  myfread(SubMostBoundID+Nloadsub, sizeof(MyInt), Nsubhalos, fd);
  myfread(SubRHalf+Nloadsub, sizeof(MyReal), Nsubhalos, fd);

  Nloadsub+=Nsubhalos;
  
  if(feof(fd))
  {
  fprintf(stderr,"early end: file format not expected! for file %s\n",buf);
  fflush(stderr);
  exit(1);
  }
  fclose(fd);
}
int offset=0;
for(i=0;i<TotNgroups;i++)
{
  FirstSubOfHalo[i]=offset;
  offset+=NsubPerHalo[i];
}
if(offset!=TotNsubhalos)
{
  printf("Error: subhalo count mismatch: %d, %d\n", offset, TotNsubhalos);
  exit(1);
}

#ifdef CONVERT_LENGTH_MPC_KPC
for(i=0;i<TotNsubhalos*3;i++)
{
	SubPos[i]*=1000;
	SubCoM[i]*=1000;
}
for(i=0;i<TotNsubhalos;i++)
{
	SubRHalf[i]*=1000;
	SubRmax[i]*=1000;
}
for(i=0;i<TotNgroups;i++)
{
	Halo_R_Crit200[i]*=1000;
	Halo_R_Mean200[i]*=1000;
	Halo_R_TopHat200[i]*=1000;
}
#endif

  printf("tab ok\n");fflush(stdout);
   
  long long Nloadid=0;
  for(i=0;i<FileCounts;i++)
  {
//  if(FileCounts>1)	  
  sprintf(buf, "%s/postproc_%03d/sub_ids_%03d.%d",subdir,SnapshotNum,SnapshotNum,i); //gadget3 always output this way
//  else
//  sprintf(buf, "%s/subhalo_ids_%03d",subdir,Nsnap);
  myfopen(fd,buf,"r");
	
  myfread(&Ngroups, sizeof(int), 1, fd);
  myfread(&Nids, sizeof(int), 1, fd);
  myfread(&TotNgroups, sizeof(int), 1, fd);
  myfread(&NFiles, sizeof(int), 1, fd);
 
  if(0==i)
  groupIDs = malloc(sizeof(MyInt) * TotNids);
  
  myfread(groupIDs+Nloadid, sizeof(MyInt), Nids, fd);
  Nloadid+=Nids;
  fclose(fd);
  }
	#ifdef SHIFT_PID_0_1
	for(i=0;i<TotNids;i++)
		groupIDs[i]++;
	#endif
// 	#define ID_MASK 0x00000003FFFFFFFF
// 	for(i=0;i<TotNids;i++)
// 	  groupIDs[i]&=ID_MASK;
	if(Nloadid!=TotNids)
	{
		fprintf(stderr,"error: TotNids Loaded Mismatch: %ld, %ld\n",Nloadid,TotNids);
		fflush(stderr);
		exit(1);
	}
	
  printf("%d Subhalos loaded.\n",TotNsubhalos);fflush(stdout);  
  }

static int comp_MyInt(const void *a, const void *b)//used to sort PID in ascending order; 
{
  if((*(MyInt *)a) > (*(MyInt *)b))
    return +1;

  if((*(MyInt *)a) < (*(MyInt *)b))
    return -1;

  return 0;
}

#ifdef PARAM_FILE_INCLUDED
void subfindcat2BT(SUBCATALOGUE *SubCat)
{
  HBTInt subid,grpid,i,j;
  
  SubCat->Ngroups=TotNgroups;
  SubCat->Nsubs=TotNsubhalos;
  SubCat->Nids=TotNids;
  #ifndef HBT_INT8
  SubCat->GrpLen_Sub=NsubPerHalo;
  SubCat->GrpOffset_Sub=FirstSubOfHalo;
  #else
  SubCat->GrpLen_Sub=mymalloc(sizeof(HBTInt)*SubCat->Ngroups);
  SubCat->GrpOffset_Sub=mymalloc(sizeof(HBTInt)*SubCat->Ngroups);
  for(i=0;i<SubCat->Ngroups;i++)
  {
	SubCat->GrpLen_Sub[i]=NsubPerHalo[i];
	SubCat->GrpOffset_Sub[i]=FirstSubOfHalo[i];
  }
  #endif
  if(FirstSubOfHalo[0]!=0)
  {
	printf("error,subhaloid not start from 0\n");
	exit(1);
  }
  if(SubHostHalo[0]!=0)
  {
	printf("error,Host haloid not start from 0\n");
	exit(1);
  }
  #ifndef HBT_INT8
  SubCat->SubLen=SubLen;
  SubCat->SubOffset=SubOffset;
  #else
  SubCat->SubLen=mymalloc(sizeof(HBTInt)*SubCat->Nsubs);
  SubCat->SubOffset=mymalloc(sizeof(HBTInt)*SubCat->Nsubs);
  for(i=0;i<SubCat->Nsubs;i++)
  {
	SubCat->SubLen[i]=SubLen[i];
	SubCat->SubOffset[i]=SubOffset[i];
  }	
  #endif
  
  SubCat->HaloChains=mymalloc(sizeof(struct Chain_data)*TotNsubhalos);
  SubCat->SubRank=mymalloc(sizeof(HBTInt)*TotNsubhalos);
  SubCat->Property=mymalloc(sizeof(struct SubProperty)*TotNsubhalos);
  SubCat->PSubArr=mymalloc(sizeof(HBTInt *)*TotNsubhalos);
  #ifdef HBTPID_RANKSTYLE
  MyInt *PIDs,*p;  
  PIDs=load_PIDs_Sorted();
  #endif
  for(grpid=0;grpid<TotNgroups;grpid++)
  {
	for(i=0,subid=FirstSubOfHalo[grpid];subid<FirstSubOfHalo[grpid]+NsubPerHalo[grpid];subid++,i++)
	{
	  SubCat->SubRank[subid]=i;
	  SubCat->PSubArr[subid]=mymalloc(sizeof(HBTInt)*SubCat->SubLen[subid]);
	  for(j=0;j<SubCat->SubLen[subid];j++)
	  {
		#ifdef HBTPID_RANKSTYLE
		p=bsearch(groupIDs+SubOffset[subid]+j,PIDs,NP_DM,sizeof(MyInt),comp_MyInt);
		SubCat->PSubArr[subid][j]=p-PIDs;
		#else
		SubCat->PSubArr[subid][j]=groupIDs[SubOffset[subid]+j];
		#endif
	  }
	  
	  SubCat->HaloChains[subid].HostID=grpid;
	  for(j=0;j<3;j++)
	  {
		SubCat->Property[subid].CoM[j]=SubPos[subid*3+j];//center of minimum potential
		SubCat->Property[subid].VCoM[j]=SubVel[subid*3+j];//average vel?
	  }
	}
  }
  #ifdef HBTPID_RANKSTYLE
  myfree(PIDs);
  #endif
  //~ for(subid=0;subid<TotNsubhalos-1;subid++)
  //~ {
  //~ if(SubLen[subid]+SubOffset[subid]!=SubOffset[subid+1])
  //~ {
  //~ printf("error,lastsubid=%d,suboffset=%d,sub.offset=%d,lastsublen=%d,lastsuboffset=%d\n",subid,SubOffset[subid+1],SubLen[subid]+SubOffset[subid],SubLen[subid],SubOffset[subid]);
  //~ exit(1);
  //~ }
  //~ }
  SubCat->sub_hierarchy=NULL;
  SubCat->Nbirth=0;
  SubCat->Ndeath=0;
  SubCat->NQuasi=0;
  SubCat->Nsplitter=0;
}
void load_subfind_catalogue(int Nsnap,SUBCATALOGUE *SubCat,char *inputdir)
{
	subread(Nsnap,inputdir);
	subfindcat2BT(SubCat);
}
void load_subfind_halo_size(float Mvir[][3],float Rvir[][3],float partmass, HBTInt Ngroups, int Nsnap)
{
	HBTInt i;
	if(Ngroups!=TotNgroups)
	{
		fprintf(stderr,"error: number of groups mismatch when loading subfind halosize: %d,%d\n",Ngroups,TotNgroups);
		fflush(stderr);
		exit(1);
	}
	for(i=0;i<TotNgroups;i++)
	{
		Mvir[i][0]=Halo_M_TopHat200[i];
		Mvir[i][1]=Halo_M_Crit200[i];
		Mvir[i][2]=Halo_M_Mean200[i];
		Rvir[i][0]=Halo_R_TopHat200[i];
		Rvir[i][1]=Halo_R_Crit200[i];
		Rvir[i][2]=Halo_R_Mean200[i];
	}
}
#endif	
#ifdef STANDALONE
int main()
{
	int Nsnap=63;
	char inputdir[1024]="/gpfs/data/jch/MilliMillennium/Snapshots/";
// 	char inputdir[1024]="/gpfs/data/aquarius/halo_data/Aq-A/3";
	logfile=stdout;
	
	subread(Nsnap,inputdir);
	SUBCATALOGUE SubCat;
	subfindcat2BT(&SubCat);
	printf("M200=%g, R200=%g\n", Halo_M_Crit200[0], Halo_R_Crit200[0]);
	return 0;
}
#endif
