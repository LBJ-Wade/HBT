//print history of a given subhalo
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "datatypes.h"
#include "intra_vars.h"
#include "iovars.h"
#include "proto.h"

int main(int argc,char **argv)
{
	SUBCATALOGUE SubCat;
	CATALOGUE Cat;
	HBTInt Nsnap,subid,Nsubs, *pro2dest;
	HBTReal d;
	FILE *fp;
	char buf[1024];
	
	logfile=stdout;
	HBTInt snapstart=atoi(argv[1]);
	subid=atoi(argv[2]);
	sprintf(buf,"%s/anal/traceforward_%d_%d.dat",SUBCAT_DIR, snapstart, subid);
	myfopen(fp,buf,"w");
	
	for(Nsnap=snapstart;Nsnap<MaxSnap;Nsnap++)
	{
	load_sub_table(Nsnap,&SubCat,SUBCAT_DIR);
	HBTReal *x=SubCat.Property[subid].CoM, *v=SubCat.Property[subid].VCoM;
	fprintf(fp,"%d %d %g %g %g %g %g %g\n",Nsnap, SubCat.SubLen[subid], x[0], x[1], x[2], v[0], v[1], v[2] );	
	free_sub_table(&SubCat);
	load_pro2dest(Nsnap,&pro2dest,&Nsubs,SUBCAT_DIR);	
	subid=pro2dest[subid];
	free_pro2dest(pro2dest);
	if(subid<0) break;
	}
	
	return 0;
}