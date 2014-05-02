# Publish software tags related to MPI

unique template features/gip/mpi;

include { 'features/mpi/vars' };

variable MPI_RUNTIMEENV = {
  # Currently required to flag the CE as supporting MPI.  This is necessary
  # until the RB supports multi-cpu jobs without the MPICH job type.  This
  # must be set even if MPICH isn't supported at the site!
  #SELF[length(SELF)] = "MPICH";
  
  # Mark the site as supporting MPI-START.
  SELF[length(SELF)] = "MPI-START";

  # MPI-1 implementations.
#  SELF[length(SELF)] = "LAM";
#  SELF[length(SELF)] = "LAM-"+MPI_LAM_VERSION;
#  SELF[length(SELF)] = "MPICH";
#  SELF[length(SELF)] = "MPICH-"+MPI_MPICH_VERSION;
  
  # MPI-2 implementations.
  SELF[length(SELF)] = "OPENMPI";
  SELF[length(SELF)] = "OPENMPI-"+MPI_OPENMPI_VERSION;
  SELF[length(SELF)] = "MPICH2";
  SELF[length(SELF)] = "MPICH2-"+MPI_MPICH2_VERSION;

  # Shared home directories support
  if ( is_defined(CE_SHARED_HOMES) ) {
    SELF[length(SELF)] = "MPI_SHARED_HOME";
  };

  SELF; 
};

variable CE_RUNTIMEENV = {
  if (ENABLE_MPI) {
    debug(OBJECT+': configuring MPI-related SW tags to be published into BDII ('+to_string(MPI_RUNTIMEENV)+').');
    add_ce_runtime_env(MPI_RUNTIMEENV);
    debug('New CE_RUNTIMEENV: '+to_string(SELF));
    SELF;
  } else {
    debug(OBJECT+': MPI disabled. MPI-related SW tags not added.');
    SELF;
  };
};

