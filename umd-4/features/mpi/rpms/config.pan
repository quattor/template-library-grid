unique template features/mpi/rpms/config;

include 'features/mpi/vars';

include {
    if (MPI_USE_MPICH) {
        "features/mpi/rpms/mpich";
    };
};

include {
    if (MPI_USE_MPICH2) {
        "features/mpi/rpms/mpich2";
    };
};

include {
    if (MPI_USE_LAM) {
        if(MPI_LAM_MULTIPLE) {
            "features/mpi/rpms/lam-multiple";
        } else {
            "features/mpi/rpms/lam";
        };
    };
};

include {
    if (MPI_USE_OPENMPI) {
        "features/mpi/rpms/openmpi";
    };
};

# mpi-start script to ease use of MPI
'/software/packages/{mpi-start}' ?= dict();
