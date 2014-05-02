
unique template feature/mpi/env;

# Include some variable definitions for MPI library versions.
include { 'feature/mpi/vars' };

# Setup the MPI environment here.  The various locations are related
# to which version of the MPI rpms are installed.  Make sure to keep
# this file and the rpms file in sync.

# ---------------------------------------------------------------------------- 
# filecopy
# ---------------------------------------------------------------------------- 
include { 'components/filecopy/config' };

variable CONTENTS = <<EOF;
#!/bin/bash

# Check to make sure there are enough arguments.  Must be at least four 
# arguments (to be ignored) plus one more for the script to be run.
if ( [ $# -lt 5 ] ); then
  echo "Modified mpirun: Insufficient number of arguments ($#); exiting..."
  exit 1;
fi;

# Strip four arguments from those passed in.
strip=4
while [ $strip -gt 0 ]; do
  shift
  strip=$(($strip-1))
done

echo "Modified mpirun: Executing command: $@"
./$@

EOF

# Now actually add the file to the configuration.
"/software/components/filecopy/services" = 
  npush(escape('/opt/mpi/bin/mpirun'), 
        nlist('config',CONTENTS,
              'perms','0755'),
       );

# ---------------------------------------------------------------------------- 
# profile
# ---------------------------------------------------------------------------- 
include { 'components/profile/config' };


# Environmental variables.  MPI software versions and locations.
'/software/components/profile/env/' = {
    if(MPI_USE_LAM) {
        SELF['MPI_LAM_VERSION'] = MPI_LAM_VERSION;
        SELF['MPI_LAM_PATH'] = '/usr';
    };
    
    if(MPI_USE_OPENMPI) {
        SELF['MPI_OPENMPI_VERSION'] = MPI_OPENMPI_VERSION;
        SELF['MPI_OPENMPI_PATH'] =  MPI_OPENMPI_PATH;
    };

    if(MPI_USE_MPICH) {
        SELF['MPI_MPICH_VERSION'] = MPI_MPICH_VERSION;
        SELF['MPI_MPICH_PATH'] = '/opt/mpich-'+MPI_MPICH_VERSION+MPI_MPICH_EXTRAVERSION;
    };
    
    if (MPI_USE_MPICH2) {
        SELF['MPI_MPICH2_VERSION'] = MPI_MPICH2_VERSION;
        SELF['MPI_MPICH2_PATH'] = MPI_MPICH2_PATH;
    };
    
    SELF;
};

'/software/components/profile/env/MPI_MPICC_OPTS' = MPI_MPICC_OPTS;
'/software/components/profile/env/MPI_MPICXX_OPTS' = MPI_MPICC_OPTS;
'/software/components/profile/env/MPI_MPIF77_OPTS' = MPI_MPICC_OPTS;
'/software/components/profile/env/MPI_MPIF90_OPTS' = MPI_MPICC_OPTS;

# Location of the the mpiexec executable.  (Legacy variable.)
'/software/components/profile/env/MPI_MPIEXEC_PATH' = MPI_MPIEXEC_PATH+"/bin/mpiexec";
# Location of the the mpiexec executable.  (Only appropriate for MPICH and MPICH2.)
'/software/components/profile/env/MPI_MPICH_MPIEXEC' = MPI_MPICH_MPIEXEC;
'/software/components/profile/env/MPI_MPICH2_MPIEXEC' = MPI_MPICH2_MPIEXEC;

'/software/components/profile/env/I2G_MPI_START' = '/usr/bin/mpi-start';

# Do we actually have a shared home?
'/software/components/profile/env/MPI_SHARED_HOME' = {
  if (CE_SHARED_HOMES) {
    '$HOME';
  } else {
    null;
  };
};

# Assume (for now) that ssh host-based authentication is always setup.
'/software/components/profile/env/MPI_SSH_HOST_BASED_AUTH' = 'yes';

# Path-like variables.
'/software/components/profile/path/PATH/prepend' = push('/opt/mpi/bin');

