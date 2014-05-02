
unique template feature/mpi/config;

# Include the rpms only if necessary.  Unfortunately, because of dependencies
# on the machine-type rpms, dummy rpms must be installed if MPI isn't 
# wanted.
include {
  if (ENABLE_MPI) {
    "feature/mpi/rpms/config";
  } else {
    null;
  };
};

# Define some global variables related to MPI versions installed
include { 'feature/mpi/vars' };


# Create the MPI environment (if necessary).
include {
  if (ENABLE_MPI) {
    "feature/mpi/env";
  } else {
    null;
  };
};

