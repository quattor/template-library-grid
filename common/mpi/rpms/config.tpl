unique template common/mpi/rpms/config;

include { 'common/mpi/vars' };

variable CE_TORQUE ?= true;

# mpiexec for torque/mpich which uses TM libraries
'/software/packages' = {
  if (CE_TORQUE) {
    pkg_repl('mpiexec',MPI_MPIEXEC_VERSION_FULL,PKG_ARCH_MPIEXEC);
  } else {
    SELF;
  };
};

include {
    if(MPI_USE_MPICH) {
        return("common/mpi/rpms/mpich");
    } else { 
        return(null); 
    };
};

include {
    if(MPI_USE_MPICH2) {
        return("common/mpi/rpms/mpich2");
    } else { 
        return(null); 
    };
};

include {
    if(MPI_USE_LAM) {
        if(MPI_LAM_MULTIPLE) {
            return("common/mpi/rpms/lam-multiple");
        } else {
            return("common/mpi/rpms/lam");
        };
    } else { 
        return(null); 
    };
};

include {
    if(MPI_USE_OPENMPI) {
        return("common/mpi/rpms/openmpi");
    } else { 
        return(null); 
    };
};


# mpi-start script to ease use of MPI
'/software/packages' = pkg_repl('mpi-start',MPI_MPISTART_VERSION_FULL,'noarch');
'/software/packages' = if(OS_VERSION_PARAMS['major'] == 'sl5'){
			pkg_repl('emi-mpi','1.0.2-1.el5','noarch');
			pkg_repl('glite-yaim-mpi','1.1.12-1.el5','noarch');
			}else{
			pkg_repl('emi-mpi','1.0.2-1.el6','noarch');
			pkg_repl('glite-yaim-mpi','1.1.12-1.el6','noarch');
			};
