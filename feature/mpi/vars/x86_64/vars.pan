unique template feature/mpi/vars/x86_64/vars;
# We're using x86_64 MPI : we need to change compilation options
variable MPI_MPICC_OPTS ?= '-m64' ;

# These are the versions of MPI which are supported. The rpms template
# uses these variables to define which RPMs are installed.
variable PKG_ARCH_MPI_LAM ?= PKG_ARCH_MPI;
variable MPI_USE_LAM ?= false;
variable MPI_LAM_MULTIPLE ?= true;
variable MPI_LAM_VERSION ?= "7.1.3";
variable MPI_LAM_EXTRAVERSION ?= "";
variable MPI_LAM_RELEASE  ?= "2.gp";
variable MPI_LAM_VERSION_FULL = MPI_LAM_VERSION+'-'+MPI_LAM_RELEASE;

variable PKG_ARCH_MPI_MPICH ?= PKG_ARCH_MPI;
variable MPI_USE_MPICH ?= false;
variable MPI_MPICH_VERSION ?= "1.2.7";
variable MPI_MPICH_EXTRAVERSION ?= "p1";
variable MPI_MPICH_RELEASE ?= "1.sl3.cl.1";
variable MPI_MPICH_VERSION_FULL = MPI_MPICH_VERSION+MPI_MPICH_EXTRAVERSION+'-'+MPI_MPICH_RELEASE;
variable MPI_MPICH_MPIEXEC ?= "/usr/bin/mpiexec";

variable PKG_ARCH_MPI_OPENMPI ?= PKG_ARCH_MPI;
variable MPI_USE_OPENMPI ?= true;
variable MPI_OPENMPI_VERSION ?= "1.6.3";
variable MPI_OPENMPI_EXTRAVERSION ?= "";
variable MPI_OPENMPI_RELEASE ?= "torque.2.5.9";
variable MPI_OPENMPI_VERSION_FULL = MPI_OPENMPI_VERSION+MPI_OPENMPI_EXTRAVERSION+'-'+MPI_OPENMPI_RELEASE;
variable MPI_OPENMPI_MPIEXEC ?= "/usr/bin/mpiexec";

variable PKG_ARCH_MPI_MPICH2 ?= PKG_ARCH_MPI;
variable MPI_USE_MPICH2 ?= true;
variable MPI_MPICH2_VERSION ?= "1.0.4";
variable MPI_MPICH2_EXTRAVERSION ?= "";
variable MPI_MPICH2_RELEASE ?= "2.sharedlibs.1";
variable MPI_MPICH2_VERSION_FULL = MPI_MPICH2_VERSION+MPI_MPICH2_EXTRAVERSION+'-'+MPI_MPICH2_RELEASE;
variable MPI_MPICH2_PATH ?= '/opt/mpich2-'+MPI_MPICH2_VERSION+MPI_MPICH2_EXTRAVERSION;
variable MPI_MPICH2_MPIEXEC ?= "/usr/bin/mpiexec";

variable PKG_ARCH_MPI_MPIEXEC ?= PKG_ARCH_MPI;
variable MPI_MPIEXEC_VERSION ?= "0.83";
variable MPI_MPIEXEC_EXTRAVERSION ?= "";
variable MPI_MPIEXEC_RELEASE ?= "2.el5";
variable MPI_MPIEXEC_VERSION_FULL = MPI_MPIEXEC_VERSION+MPI_MPIEXEC_EXTRAVERSION+'-'+MPI_MPIEXEC_RELEASE;
variable MPI_MPIEXEC_PATH= "/usr";


variable MPI_MPISTART_VERSION ?= "1.3.0";
variable MPI_MPISTART_RELEASE ?= if(OS_VERSION_PARAMS['major'] == 'sl5'){"1.el5"}else{"1.el6"};
variable MPI_MPISTART_VERSION_FULL = MPI_MPISTART_VERSION+'-'+MPI_MPISTART_RELEASE;

