# Template to configure NFS sharing of gridmapdir directory through NFS.
# This template must be called after feature/nfs/init and before common/nfs/[client|server] config.
# It is typically called from feature/mkgridmap/base.

unique template feature/nfs/gridmapdir;

variable GRIDMAPDIR_SHARED_PATH ?= error('Internal error: attempt to configure a shared gridmapdir but GRIDMAPDIR_SHARED_PATH is undefined');
variable GRIDMAPDIR_SHARED_SERVER ?= error('GRIDMAPDIR_SHARED_SERVER variable must defined for configuring NFS-shared gridmapdir');

# Configure NFS mount point for gridmapdir.
# gridmapdir server is indicated by variable GRIDMAPDIR_SHARED_SERVER:
# on this machine exports are configured for gridmadir NFS serving, on
# other machine this shared gridmapdir is NFS-mounted.
# The mount point of the shared gridmapdir is given by variable
# GRIDMAPDIR_SHARED_PATH. On the gridmapdir server, the gridmapdir is
# the directory pointed by SITE_DEF_GRIDMAPDIR.

variable GRIDMAPDIR_MOUNT_POINTS = {
        nfs_version = NFS_DEFAULT_VERSION;
        e_mnt_point = escape(GRIDMAPDIR_SHARED_PATH);
        # gridmapdir server: configure exports
        if ( FULL_HOSTNAME == GRIDMAPDIR_SHARED_SERVER ) {
          if ( is_defined(SELF['servedFS'][e_mnt_point]) ) {
            debug('GRIDMAPDIR_SHARED_PATH ('+GRIDMAPDIR_SHARED_PATH+') is already configured for NFS sharing');
          } else {
            SELF['servedFS'][e_mnt_point] = nlist('localPath',SITE_DEF_GRIDMAPDIR,
                                                  'nfsVersion', nfs_version);
          };
        # Else configure NFS mount
        } else {
          if ( is_defined(SELF['mountedFS'][e_mnt_point]) ) {
            debug('NFS mount of gridmapdir is already configured');
          } else {
            SELF['mountedFS'][e_mnt_point] = nlist('nfsPath',GRIDMAPDIR_SHARED_SERVER+':'+SITE_DEF_GRIDMAPDIR,
                                                   'nfsVersion', nfs_version);
            if ( exists(NFS_MOUNT_OPTS[e_mnt_point]) && is_defined(NFS_MOUNT_OPTS[e_mnt_point]) ) {
              SELF['mountedFS'][e_mnt_point]['options'] = NFS_MOUNT_OPTS[e_mnt_point];
            } else {
              SELF['mountedFS'][e_mnt_point]['options'] = NFS_DEFAULT_MOUNT_OPTIONS;
            };
          };
        };

  debug('gridmapdir-related NFS configuration: '+to_string(SELF));
  SELF;  
};


# Merge gridmapdir mount point with other NFS mount points.
# Before merging, check if NFS mounting of file systems was explicitly disabled.
variable NFS_CLIENT_DISABLED = {
  if ( !NFS_CLIENT_ENABLED && (length(NFS_MOUNT_POINTS['mountedFS']) > 0) ) {
    true;
  } else {
    false;
  };
};
variable NFS_MOUNT_POINTS ?= nlist();
variable NFS_MOUNT_POINTS = {
  if ( is_defined(GRIDMAPDIR_MOUNT_POINTS['servedFS']) ) {
    if ( is_defined(SELF['servedFS']) ) {
      SELF['servedFS'] = merge(SELF['servedFS'],GRIDMAPDIR_MOUNT_POINTS['servedFS']);
    } else {
      SELF['servedFS'] = GRIDMAPDIR_MOUNT_POINTS['servedFS'];
    }
  };
  
  if ( is_defined(GRIDMAPDIR_MOUNT_POINTS['mountedFS']) ) {
    if ( is_defined(SELF['mountedFS']) ) {
      SELF['mountedFS'] = merge(SELF['mountedFS'],GRIDMAPDIR_MOUNT_POINTS['mountedFS']);
    } else {
      SELF['mountedFS'] = GRIDMAPDIR_MOUNT_POINTS['mountedFS'];
    }
  };

  SELF;
};

# Ensure NFS_SERVER_ENABLED and NFS_CLIENT_ENABLED are properly set.
# Define NFS_SERVER_ENABLED based on NFS_MOUNT_POINTS['servedFS']
variable NFS_SERVER_ENABLED = {
  if ( length(NFS_MOUNT_POINTS['servedFS']) > 0 ) {
    true;
  } else {
    false;
  };
};                          

# Define NFS_CLIENT_ENABLED based on NFS_MOUNT_POINTS['mountedFS'] if not already
# explicitly disabled to prevent NFS mount of FS in WN_SHARED_AREAS.
variable NFS_CLIENT_ENABLED = {
  if ( !NFS_CLIENT_DISABLED && (length(NFS_MOUNT_POINTS['mountedFS']) > 0) ) {
    true;
  } else {
    false;
  };
};
