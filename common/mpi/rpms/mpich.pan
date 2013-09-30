unique template common/mpi/rpms/mpich;

# MPI-1 implementation
'/software/packages' = pkg_repl('mpich',MPI_MPICH_VERSION_FULL,PKG_ARCH_MPI_MPICH);

