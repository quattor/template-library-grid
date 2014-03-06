unique template feature/mpi/rpms/config;

include { 'feature/mpi/vars' };

variable CE_TORQUE ?= true;

# mpiexec for torque/mpich which uses TM libraries
'/software/packages' = {
    if (CE_TORQUE) {
        SELF['mpiexec'] = nlist();
    };
    SELF;
};

include {
    if(MPI_USE_MPICH) {
        "feature/mpi/rpms/mpich";
    };
};

include {
    if(MPI_USE_MPICH2) {
        "feature/mpi/rpms/mpich2";
    };
};

include {
    if(MPI_USE_LAM) {
        if(MPI_LAM_MULTIPLE) {
            "feature/mpi/rpms/lam-multiple";
        } else {
            "feature/mpi/rpms/lam";
        };
    };
};

include {
    if(MPI_USE_OPENMPI) {
        "feature/mpi/rpms/openmpi";
    };
};

# mpi-start script to ease use of MPI
'/software/packages/{mpi-start}' ?= nlist();
