 
#ifndef PARAM_FILE_INCLUDED	//to avoid multiple inclusion
	
	#define PERIODIC_BDR
#ifndef DISABLE_HALO_PARA
	#define HALO_PARA
#endif
	/*=========program IO params==========*/
	#define ROOT_DIR "/home/kambrain/data/6411/"
	#define SUBCAT_DIR  ROOT_DIR "subcat"			//the output directory for subcatalogues and srccatalogues, this must be an existing directory
	#define GRPCAT_DIR  ROOT_DIR "fof"				     //the input directory for GrpCatalogues
	#define SNAPSHOT_DIR ROOT_DIR "simu"				//the input directory for simulation snapshots
	#define LOGFILE_NAME  "logfile"								//the name of program logfile, set to "stdout" to use stdout

	/*======simulation params===========*/
	#define NP_SIM	1073741824 //total Number of all kinds of particles
	#define NP_GAS 0
	#define NP_DM 1073741824
	#define BOXSIZE 1200000.0 //kpc/h
	/*=extension params=*/
	#define BOXHALF 600000.0
	#define OMEGA0 0.268
	#define OMEGAL0 0.732
	#define Redshift_INI 72.0
	//PartMass=0.187042
	
	/*=======Tree algorithm params========*/
	#define TREE_ALLOC_FACTOR 2// 3? MaxNodes = ((maxnodes>500)?maxnodes:500);
	#define ErrTolTheta 0.45
	#define SofteningHalo 24.  //ita=72 kpc/h ,epsilon=ita/3
	#define NodeResolution 2.4  //0.1*Softening
	#define NodeReso_half 1.2

	/*=======unbinding algorithm params=====*/
	#define SAT_ACCR_ON      //define this to enable hierarchical accretion of satellite subs; comment this out to disable it
	#define PrecMass 0.995 //relative converge error for unbind (ErrorTolMass=1-PrecMass)
	#define NBOUNDMIN 10  //nbound<2 means only 1 particle bound, i.e, nothing left.
	#define NSRCMIN 10  //min len of src_sub (used for splitting)
	#define NParaMin 100 //the lower bound of particle numbers for parallelization of unbind()
	#define MassRelax_Input 2/*control the dynamic range of the unbinding procedure; 
															* it is the maximum allowed ratio that a sattellite sub is allowed to reaccrete/grow, 
															* its square (MassRelax_Input*MassRelax_Input) also "roughly"(maybe either bigger or smaller) gives the maximum safe-unbinding  factor 
															* by which  a sub is stripped  ,i.e. if a sub reduces its mass by a factor of N>MRelax*MRelax between two subsequent snapshot, 
															* then the unbinding  procedure may not find the bound part safely (since CoreFrac=1.0/MRelax^2 for algorithm efficiency reason)
															* so it seems the bigger the better. 
															* However, bigger MRelax means smaller CoreFrac, then small CoreLen if the sub in hand is small,
															* thus may also undermine the unbinding process for small subs
															* But for big enough subs, bigger MRelax (thus smaller CoreFrac) usually makes unbinding more robust to disturbing particles */
	#define CoreFrac0 0.25 //1.0/MassRelax_Input/MassRelax_Input;
	#define CoreLenMin 10//CoreLenMin<=NBOUNDMIN

	/*if GADGET units used, this gives the corresponding Gravitational constant; 
	 * otherwise calculate it in your own units and some modification to the unbinding procedure may be needed*/
	#define G 43007.1
	#define HUBBLE0 0.1    //H_0 in internal units
	#define MaxSnap 4//total number of snapshot outputs
	
	#define RUN_NUM 6411   //simulation name
	#define SNAP_DIV_SCALE -1  //last snapnum with scale
	//~ #define PID_ORDERED        //this macro disables the PID part in particle_data and use fast switch between PID and PIndex (+1 or -1).
	#define VEL_INPUT_PHYSICAL  //this macro allows for the input velocity from load_particle_data() to be physical rather than in GADGET manner,i.e, do not need to multiply sqrt(a)
	#define GRPINPUT_INDEX	//define this macro if the input from load_group_catalogue() has already been PIndex rather than PID
 	#define BIGENDIAN          //define this for reading BigEndian data on a SmallEndian machine.
// 	#define PDAT_XMAJOR  //dimension varies fastest
// 	#define HBT_INT8
	#define UNBIND_FOF //only unbind FoF, do not track; need an external loop to process snapshot by snapshot.
	
#define PARAM_FILE_INCLUDED
#endif

