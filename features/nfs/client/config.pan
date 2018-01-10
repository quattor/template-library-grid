unique template features/nfs/client/config;

# Install nfs-utils
'/software/packages/{nfs-utils}' = nlist();

# For backward compatibility, this variable is generally defined to false in gLite default parameters
# but autofs is really the recommended method...
variable NFS_AUTOFS ?= true;

# Configure NFS client and mount poins.
# Both autofs and hard mounting in fastab are supported.
variable NFS_CLIENT_TEMPLATE = if ( NFS_AUTOFS ) {
                                 return("features/nfs/client/autofs");
                               } else {
                                 return("features/nfs/client/fstab");
                               };
include { NFS_CLIENT_TEMPLATE };


# Check if other components subscribed to the NFS client configuration as a pre or post dependency for themselves.
# This has to be really implemented here as this part of the NFS configuration may be done after all other
# services.
'/software/components' = {
  if ( NFS_AUTOFS ) {
    nfs_component = 'autofs';
  } else {
    nfs_component = 'nfs';
  };

  foreach (i;component;NFS_CLIENT_PREDEP_SUBSCRIBERS) {
      SELF[component]['dependencies']['pre'][length(SELF[component]['dependencies']['pre'])] = nfs_component;
  };

  foreach (i;component;NFS_CLIENT_POSTDEP_SUBSCRIBERS) {
      SELF[component]['dependencies']['post'][length(SELF[component]['dependencies']['post'])] = nfs_component;
  };

  SELF;
};
