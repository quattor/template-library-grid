unique template common/mpi/rpms/openmpi;

# MPI-2 implementation (descendent of LAM)
'/software/packages' = pkg_repl('openmpi',MPI_OPENMPI_VERSION_FULL,PKG_ARCH_MPI_OPENMPI);

