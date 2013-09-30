unique template common/mpi/rpms/lam-multiple;

# MPI-1 implementation (replaces version in SL release)
'/software/packages' = pkg_repl('lam-runtime',MPI_LAM_VERSION_FULL,PKG_ARCH_MPI_LAM);
#'/software/packages' = pkg_repl('lam-devel',MPI_LAM_VERSION_FULL,PKG_ARCH_MPI_LAM);
#'/software/packages' = pkg_repl('lam-debuginfo',MPI_LAM_VERSION_FULL,PKG_ARCH_MPI_LAM);
#'/software/packages' = pkg_repl('lam-docs',MPI_LAM_VERSION_FULL,PKG_ARCH_MPI_LAM);
'/software/packages' = pkg_repl('lam-extras',MPI_LAM_VERSION_FULL,PKG_ARCH_MPI_LAM);
