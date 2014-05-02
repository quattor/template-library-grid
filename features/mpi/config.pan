
unique template features/mpi/config;

# Include the rpms only if necessary.  Unfortunately, because of dependencies
# on the machine-type rpms, dummy rpms must be installed if MPI isn't 
# wanted.
include {
  if (ENABLE_MPI) {
    "features/mpi/rpms/config";
  } else {
    null;
  };
};

# Define some global variables related to MPI versions installed
include { 'features/mpi/vars' };


# Create the MPI environment (if necessary).
include {
  if (ENABLE_MPI) {
    "features/mpi/env";
  } else {
    null;
  };
};

