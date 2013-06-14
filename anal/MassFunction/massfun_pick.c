//massfunctions for selected grps
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "datatypes.h"
#include "intra_vars.h"
#include "iovars.h"
#include "proto.h"

#define NSAMPLE 30
//#define NORM  //produce normalized massfunction (in terms Msub/Mhost rather than Msub)
#define RMIN 0
#define RMAX 1	 //statistics done in RMIN*rvi<r<RMAX*rvir
#define NBIN 8  //bin number for Msub
#define NFUN NSAMPLE
//#define AUTOBIN
//~ #define FIX_XBIN  //define this to use preset xmass bin

struct MassList
{
	float *list;
	int Len;
};
struct MassFunc
{
	int nbin;
	float Mbin[2]; //host mass range
	int Nhost;//number of hosts in this host mass bin
	double Mhost;//total host mass in this bin
	float xmass[NBIN][2];//x coordinates,[Msub_lower_lim,Msub_av] for each Msub mass bin
	float mfunspec[NBIN][2];//[dN/dMsub,sqrt(dN)/dMsub], massfun plus Poison error for each Msub bin
	float mfunspecln[NBIN][2];//[dN/dlnMsub,...]
	float mfuncum[NBIN][2];//[N(>Msub_lower_lim),...]
};
size_t write_massfuncs(struct MassFunc *f,int nf,FILE *fp)
{
	int i;
	sizt_t nbuf=0;
	for(i=0;i<nf;i++)
	{
	nbuf+=fwrite(&f[i].nbin,sizeof(int),1,fp);
	nbuf+=fwrite(f[i].Mbin,sizeof(float),2,fp);
	nbuf+=fwrite(&f[i].Nhost,sizeof(int),1,fp);
	nbuf+=fwrite(&f[i].Mhost,sizeof(double),1,fp);
	nbuf+=fwrite(f[i].xmass,sizeof(float),NBIN*2,fp);
	nbuf+=fwrite(f[i].mfunspec,sizeof(float),NBIN*2,fp);
	nbuf+=fwrite(f[i].mfunspecln,sizeof(float),NBIN*2,fp);
	nbuf+=fwrite(f[i].mfuncum,sizeof(float),NBIN*2,fp);
	}
	return nbuf;
}

double partmass;
float (*Mvir)[3],(*Rvir)[3];
CATALOGUE Cat;
SUBCATALOGUE SubCat;
int VirType;

void logspace(double xmin,double xmax,int N,float *x);
void load_halo_virial_size(float Mvir[][3],float Rvir[][3],float partmass,int Ngroups,int Nsnap);
void makell_sub();
void collect_submass(int grpid,struct MassList *Mlist,float rmin,float rmax);
void freell_sub();
void mass_list(int grpid,struct MassList *Mlist,int *Nhost,double *Mhost);
void mass_count(struct MassList *Mlist,struct MassFunc *mfun,float xrange[2]);
void mass_fun(int grpid,struct MassFunc *mfun,float xrange[2]);
int main(int argc,char **argv)
{
	int Nsnap,i,j,grplist[NFUN];
	struct MassFunc mfun[NFUN];
	
	FILE *fp;
	char buf[1024];
	
	logfile=stdout;
	if(argc!=3)
	{
	printf("usage:%s [Snap] [VirialType]\n",argv[0]);
	exit(1);
	}
	Nsnap=atoi(argv[1]);
	VirType=atoi(argv[2]);

	load_group_catalogue(Nsnap,&Cat,GRPCAT_DIR);
	load_sub_catalogue(Nsnap,&SubCat,SUBCAT_DIR);
	load_particle_header(Nsnap,SNAPSHOT_DIR);
	partmass=header.mass[1];
	sprintf(buf,"%s/anal/massfun/samplehaloid.txt",SUBCAT_DIR);
	myfopen(fp,buf,"r");
	int SnapTmp;
	for(SnapTmp=MaxSnap-1;SnapTmp>=Nsnap;SnapTmp--)
	{
		for(i=0;i<NSAMPLE;i++)
			fscanf(fp,"%d,",grplist+i);
		fscanf(fp,"\n");
	}
	Mvir=mymalloc(sizeof(float)*3*Cat.Ngroups);
	Rvir=mymalloc(sizeof(float)*3*Cat.Ngroups);
	load_halo_virial_size(Mvir,Rvir,(float)partmass,Cat.Ngroups,Nsnap);
	
	
	makell_sub();
	
	float xrange[2]={0.620373,50};  //this only takes effect when FIX_XBIN is defined
							
	#pragma omp parallel for
	for(i=0;i<NSAMPLE;i++)
	{
		mfun[i].nbin=NBIN;
		mass_fun(grplist[i],mfun+i,xrange);	
	}
	freell_sub();
	
	char outputdir[1024];
	sprintf(outputdir,"%s/anal/massfun",SUBCAT_DIR);
	mkdir(outputdir,0755);
	
	#ifdef NORM
	sprintf(buf,"%s/anal/massfun/sample_massfunN_%03d.%d",SUBCAT_DIR,Nsnap,VirType);
	#else
	sprintf(buf,"%s/anal/massfun/sample_massfun_%03d.%d",SUBCAT_DIR,Nsnap,VirType);
	#endif
	myfopen(fp,buf,"w");	
	{
	int ntmp;
	float rtmp;
	rtmp=1./header.time-1;
	fwrite(&rtmp,sizeof(float),1,fp);
	ntmp=NFUN;
	fwrite(&ntmp,sizeof(int),1,fp);
	ntmp=VirType;
	fwrite(&ntmp,sizeof(int),1,fp);
	rtmp=RMIN;
	fwrite(&rtmp,sizeof(int),1,fp);
	rtmp=RMAX;
	fwrite(&rtmp,sizeof(int),1,fp);
	//~ fwrite(mfun,sizeof(struct MassFunc),NFUN,fp);
	write_massfuncs(mfun,NFUN,fp);
	ntmp=NFUN;
	fwrite(&ntmp,sizeof(int),1,fp);
	}
	fclose(fp);
	myfree(Mvir);
	myfree(Rvir);
	
	return 0;
}

void mass_list(int grpid,struct MassList *Mlist,int *Nhost,double *Mhost)
{
		if(grpid>=0)
		{	
			collect_submass(grpid,Mlist,RMIN*Rvir[grpid][VirType],RMAX*Rvir[grpid][VirType]);
			if(Mlist->Len>SubCat.Nsubs)
			{
				printf("error: too many subs listed\n");
				exit(1);
			}
			*Nhost=1;
			*Mhost=Mvir[grpid][VirType];;
		}
		else
		{
			Mlist->list=NULL;
			Mlist->Len=0;
			*Nhost=0;
			*Mhost=0;
		}
}
void mass_count(struct MassList *Mlist,struct MassFunc *mfun,float xrange[2])
{
/* divide Mlist into nbin and count dN
* xmass:size(nbin,2), [lower bin limits, center of mass bins]
* mfunspec: size(nbin,2), [dN/dMsub,error]
* mfunspecln: same as above for dN/dlnMsub
* mfuncum: size(nbin,2), cumulative mass counts N(>Msub) 
* */
float xmin,xmax,dlnx;
float x[NBIN+1],*list,len;
double mass[NBIN];
int i,j,count[NBIN];

list=Mlist->list;
len=Mlist->Len;
if(len==0)
{
for(i=NBIN-1;i>=0;i--)
{
	mfun->xmass[i][0]=0;
	mfun->xmass[i][1]=0;
	mfun->mfunspec[i][0]=0;
	mfun->mfunspec[i][1]=0;
	mfun->mfunspecln[i][0]=0;
	mfun->mfunspecln[i][1]=0;
	mfun->mfuncum[i][0]=0;
	mfun->mfuncum[i][1]=0;
}
return;	
}

xmin=list[Fmin_of_vec(list,len)];
#ifdef NORM
float xmin_rel=NBOUNDMIN*partmass/mfun->Mbin[0];
if(xmin<xmin_rel) xmin=xmin_rel;
#endif
xmax=list[Fmax_of_vec(list,len)]*1.001;

#ifdef FIX_XBIN
xmin=xrange[0];
xmax=xrange[1];
#endif

logspace(xmin,xmax,NBIN+1,x);
dlnx=logf(x[1]/x[0]);
printf("%f,%f\n",xmin,xmax);

for(i=0;i<NBIN;i++)
{
	count[i]=0;
	mass[i]=0;
}
for(j=0;j<len;j++)
{
	for(i=0;i<NBIN;i++)
		if(list[j]<x[i]) break;
	i--;	
	if(i>=0)
	{
		count[i]++;
		mass[i]+=list[j];
	}
}

j=0;
for(i=NBIN-1;i>=0;i--)
{
	j+=count[i];
	mfun->xmass[i][0]=x[i];
	mfun->xmass[i][1]=mass[i]/count[i];
	mfun->mfunspec[i][0]=count[i]/(x[i+1]-x[i]);
	mfun->mfunspec[i][1]=sqrt(count[i])/(x[i+1]-x[i]);
	mfun->mfunspecln[i][0]=count[i]/dlnx;//another way: <m>*dN/dm=xmass[i,1]*mfunspec;
	mfun->mfunspecln[i][1]=sqrt(count[i])/dlnx;
	mfun->mfuncum[i][0]=j;
	mfun->mfuncum[i][1]=sqrt(j);
}
}
void mass_fun(int grpid,struct MassFunc *mfun,float xrange[2])
{
	struct MassList Mlist;
	mass_list(grpid,&Mlist,&mfun->Nhost,&mfun->Mhost);
	mfun->Mbin[0]=mfun->Mhost;
	mfun->Mbin[1]=mfun->Mhost;
	mass_count(&Mlist,mfun,xrange);
	myfree(Mlist.list);
}

#define NDIV 200
static int hoc[NDIV][NDIV][NDIV],*ll;
static float range[3][2], step[3];
void makell_sub()
{
	int i,j,grid[3],np;
	
	#define POS(i,j) SubCat.Property[i].CoM[j]
	np=SubCat.Nsubs;
	printf("creating linked list..\n");
	ll=mymalloc(sizeof(int)*np);
	/*determining enclosing cube*/
	for(i=0;i<3;i++)
		for(j=0;j<2;j++)
			range[i][j]=POS(0,i);
	for(i=1;i<np;i++)
		for(j=0;j<3;j++)
		{
			if(POS(i,j)<range[j][0])
				range[j][0]=POS(i,j);
			else if(POS(i,j)>range[j][1])
				range[j][1]=POS(i,j);
		}
	for(j=0;j<3;j++)
		step[j]=(range[j][1]-range[j][0])/NDIV;
	
	/*initialize hoc*/
	int *phoc=&(hoc[0][0][0]);
	for(i=0;i<NDIV*NDIV*NDIV;i++,phoc++)
		*phoc=-1;
		
	for(i=0;i<np;i++)
	{
		for(j=0;j<3;j++)
		{
			grid[j]=floor((POS(i,j)-range[j][0])/step[j]);
			if(grid[j]<0) 
				grid[j]=0;
			else if(grid[j]>=NDIV)
				grid[j]=NDIV-1;
		}
		ll[i]=hoc[grid[0]][grid[1]][grid[2]];
		hoc[grid[0]][grid[1]][grid[2]]=i; /*use hoc(floor(xsat)+1) as swap varible to temporarily 
			      						store last ll index, and finally the head*/
	}
	#undef POS(i,j)
}
void freell_sub()
{
	myfree(ll);
}
void collect_submass(int grpid,struct MassList *Mlist,float rmin,float rmax)
{
	int i,j,k,cenid,pid,subbox_grid[3][2],maxlen,len;
	float *cen,rscale,dr,*Src;
	
	len=0;
	cenid=SubCat.GrpOffset_Sub[grpid];
	if(SubCat.SubLen[cenid])
	{
	maxlen=SubCat.GrpLen_Sub[grpid]*2;
	maxlen=((maxlen<SubCat.Nsubs)?maxlen:SubCat.Nsubs);
	Src=mymalloc(sizeof(float)*maxlen);
	cen=SubCat.Property[cenid].CoM;
	rscale=rmax;
	for(i=0;i<3;i++)
	{
	subbox_grid[i][0]=floor((cen[i]-rscale-range[i][0])/step[i]);
	if(subbox_grid[i][0]<0)subbox_grid[i][0]=0;
	subbox_grid[i][1]=floor((cen[i]+rscale-range[i][0])/step[i]);
	if(subbox_grid[i][1]>=NDIV)subbox_grid[i][1]=NDIV-1;
	}
	//~ printf("%d,%d,%d,%d,%d,%d\n",subbox_grid[0][0],subbox_grid[0][1],subbox_grid[1][0],subbox_grid[1][1],subbox_grid[2][0],subbox_grid[2][1]);fflush(stdout);
	for(i=subbox_grid[0][0];i<subbox_grid[0][1]+1;i++)
		for(j=subbox_grid[1][0];j<subbox_grid[1][1]+1;j++)
			for(k=subbox_grid[2][0];k<subbox_grid[2][1]+1;k++)
			{
				pid=hoc[i][j][k];
				while(pid>=0)
				{
					dr=distance(SubCat.Property[pid].CoM,cen);
					if(pid!=cenid&&SubCat.SubLen[pid]&&dr<rmax&&dr>rmin)
					{
						#ifdef NORM
						Src[len]=SubCat.SubLen[pid]*partmass/Mvir[grpid][VirType];
						#else
						Src[len]=SubCat.SubLen[pid]*partmass;
						#endif
						len++;
						if(len>=maxlen)
						{
							maxlen*=2;
							Src=realloc(Src,sizeof(float)*maxlen);
						}
					}
					pid=ll[pid];
				}
			}
			Src=realloc(Src,sizeof(float)*len);
	}
	else
	{
		Src=NULL;
	}
	Mlist->Len=len;
	Mlist->list=Src;
}

void load_halo_virial_size(float Mvir[][3],float Rvir[][3],float partmass,int Ngroups,int Nsnap)
{
	char buf[1024];
	FILE *fp;
	int Nvir[3],i,j;
	sprintf(buf,"%s/profile/logbin/halo_size_%03d",SUBCAT_DIR,Nsnap);
	myfopen(fp,buf,"r");
	for(i=0;i<Ngroups;i++)
	{
		fseek(fp,14*4L,SEEK_CUR);
		fread(Nvir,sizeof(int),3,fp);
		for(j=0;j<3;j++)
		Mvir[i][j]=Nvir[j]*partmass;
		fread(Rvir+i,sizeof(float),3,fp);
		fseek(fp,4*4L,SEEK_CUR);
	}
	fclose(fp);
}

void logspace(double xmin,double xmax,int N,float *x)
{
	int i;
	double dx;
	x[0]=xmin;x[N-1]=xmax;
	xmin=log(xmin);
	xmax=log(xmax);
	dx=exp((xmax-xmin)/(N-1));
	for(i=1;i<N-1;i++)
	{
		x[i]=x[i-1]*dx;
	}
}
