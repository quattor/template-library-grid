unique template feature/mpi/vars;

# Default arch for MPI packages if not set.
variable PKG_ARCH_MPI ?= PKG_ARCH_GLITE;
variable PKG_ARCH_MPIEXEC ?= PKG_ARCH_MPI;

include { 'feature/mpi/vars/'+PKG_ARCH_MPI+'/vars' };


