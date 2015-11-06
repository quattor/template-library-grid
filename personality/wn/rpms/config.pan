unique template personality/wn/rpms/config;

# EMI WN
"/software/packages/{emi-wn}" ?= nlist();

# Atlas Worker Node metapackage
variable ATLAS_SUPPORT ?= true;
"/software/packages" = {
  if (ATLAS_SUPPORT ) {
    # atlas-worker-node is broken due to castor-lib conflict w/ lcgdm-libs
    #SELF['{atlas-worker-node}'] = nlist();
    SELF[{'xrootd-client'}]    = nlist();
    SELF[{'ganglia-gmond'}]    = nlist();
    SELF[{'condor'}]           = nlist();
    # Not available on all sites
#    SELF[{'cvmfs-init-scripts'}] = nlist();
  };
  SELF; 
};

