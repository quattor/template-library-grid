unique template features/mpi/vars/i386/vars;

# Default arch for MPI packages if not set.
variable PKG_ARCH_MPI ?= "i386";
variable MPI_MPICC_OPTS ?= '-m32';

# These are the versions of MPI which are supported. The rpms template
# uses these variables to define which RPMs are installed.
variable PKG_ARCH_MPI_LAM ?= PKG_ARCH_MPI;
variable MPI_USE_LAM ?= true;
variable MPI_LAM_MULTIPLE ?= true;
variable MPI_LAM_VERSION ?= '7.1.3';
variable MPI_LAM_EXTRAVERSION ?= "";
variable MPI_LAM_RELEASE ?= '2.torque.2.3.0';
variable MPI_LAM_VERSION_FULL = MPI_LAM_VERSION+'-'+MPI_LAM_RELEASE;

variable PKG_ARCH_MPI_MPICH ?= PKG_ARCH_MPI;
variable MPI_USE_MPICH ?= true;
variable MPI_MPICH_VERSION ?= "1.2.7";
variable MPI_MPICH_EXTRAVERSION ?= "p1";
variable MPI_MPICH_RELEASE ?= "1.sl3.cl.1";
variable MPI_MPICH_VERSION_FULL = MPI_MPICH_VERSION+MPI_MPICH_EXTRAVERSION+'-'+MPI_MPICH_RELEASE;

variable PKG_ARCH_MPI_OPENMPI ?= PKG_ARCH_MPI;
variable MPI_USE_OPENMPI ?= true;
variable MPI_OPENMPI_VERSION ?= "1.1";
variable MPI_OPENMPI_EXTRAVERSION ?= "";
variable MPI_OPENMPI_RELEASE ?= "2.sl4.torque.2.3.0";
variable MPI_OPENMPI_VERSION_FULL = MPI_OPENMPI_VERSION+MPI_OPENMPI_EXTRAVERSION+'-'+MPI_OPENMPI_RELEASE;

variable PKG_ARCH_MPI_MPICH2 ?= PKG_ARCH_MPI;
variable MPI_USE_MPICH2 ?= true;
variable MPI_MPICH2_VERSION ?= "1.0.4";
variable MPI_MPICH2_EXTRAVERSION ?= "";
variable MPI_MPICH2_RELEASE ?= "1.sl3.cl.1";
variable MPI_MPICH2_VERSION_FULL = MPI_MPICH2_VERSION+MPI_MPICH2_EXTRAVERSION+'-'+MPI_MPICH2_RELEASE;

variable MPI_MPIEXEC_VERSION ?= "0.80";
variable MPI_MPIEXEC_EXTRAVERSION ?= "";
variable MPI_MPIEXEC_RELEASE ?= "1.sl3.t2.cl";
variable MPI_MPIEXEC_VERSION_FULL = MPI_MPIEXEC_VERSION+MPI_MPIEXEC_EXTRAVERSION+'-'+MPI_MPIEXEC_RELEASE;


variable MPI_MPISTART_VERSION ?= "1.3.0";
variable MPI_MPISTART_RELEASE ?= "1.el5";
variable MPI_MPISTART_VERSION_FULL = MPI_MPISTART_VERSION+'-'+MPI_MPISTART_RELEASE;

