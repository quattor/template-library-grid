# Template to configure NFS sharing of CREAM CE sandbox directory through NFS.
# This template must be called after common/nfs/init and before common/nfs/[client|server] config.
# It is typically called from LRMS configuration.

unique template common/nfs/cream-sandbox;

# Configure NFS mount points for CREAM CE sandbox directory if requested.
# NFS sharing of CREAM CE sandbox directory is enabled with variable CREAM_SANDBOX_MPOINTS which
# contains one entry per CE host sharing its sandbox directory with WNs.
# Sharing is disabled if variable CREAM_SANDBOX_SHARED_FS is defined with a value different than 'nfs[34]'.
# Code for defining mount points largely borrowed from common/nfs/init.tpl.

# First build a list of NFS mount points related to CREAM sandboxes.
variable SANDBOX_MOUNT_POINTS = {
  if ( is_defined(CREAM_SANDBOX_MPOINTS) ) {
    foreach (ce;mpoint;CREAM_SANDBOX_MPOINTS) {
      if ( !is_defined(CREAM_SANDBOX_SHARED_FS) ||
           (is_defined(CREAM_SANDBOX_SHARED_FS[ce]) && match(CREAM_SANDBOX_SHARED_FS[ce],'^nfs')) ||
           (!is_defined(CREAM_SANDBOX_SHARED_FS[ce]) && is_defined(CREAM_SANDBOX_SHARED_FS['DEFAULT']) && 
                                                                               match(CREAM_SANDBOX_SHARED_FS[ce],'^nfs')) ) {
        if ( is_defined(CREAM_SANDBOX_DIRS[ce]) ) {
          sandbox_path = CREAM_SANDBOX_DIRS[ce];
        } else if ( is_defined(CREAM_SANDBOX_DIRS['DEFAULT']) ) {
          sandbox_path = CREAM_SANDBOX_DIRS['DEFAULT'];
        };
        if ( !exists(sandbox_path) ) {
          error('CREAM CE '+ce+' sandbox directory undefined (check variable CREAM_SANDBOX_MPOINTS)');
        };
        
        # If current node is the CE the sandbox directory belongs to, configure NFS exports
        nfs_version = NFS_DEFAULT_VERSION;
        e_mnt_point = escape(mpoint);
        if ( FULL_HOSTNAME == ce ) {
          if ( is_defined(SELF['servedFS'][e_mnt_point]) ) {
            debug('CE '+ce+' sandbox already configured for NFS sharing');
          } else {
            SELF['servedFS'][e_mnt_point] = nlist('localPath',sandbox_path,
                                                  'nfsVersion', nfs_version);
          };
        # Else configure NFS mount
        } else {
          if ( is_defined(SELF['mountedFS'][e_mnt_point]) ) {
            debug('NFS mount of CE '+ce+' sandbox already configured');
          } else {
            SELF['mountedFS'][e_mnt_point] =  nlist('nfsPath',ce+':'+sandbox_path,
                                                    'nfsVersion', nfs_version);
            if ( exists(NFS_MOUNT_OPTS[e_mnt_point]) && is_defined(NFS_MOUNT_OPTS[e_mnt_point]) ) {
              SELF['mountedFS'][e_mnt_point]['options'] = NFS_MOUNT_OPTS[e_mnt_point];
            } else {
              SELF['mountedFS'][e_mnt_point]['options'] = NFS_DEFAULT_MOUNT_OPTIONS;
            };
          };
        };
      };
    };
  };

  debug('CREAM sandbox configured for NFS sharing = '+to_string(SELF));
  SELF;  
};


# Merge sandbox mount points with other NFS mount points.
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
  if ( is_defined(SANDBOX_MOUNT_POINTS['servedFS']) ) {
    if ( is_defined(SELF['servedFS']) ) {
      SELF['servedFS'] = merge(SELF['servedFS'],SANDBOX_MOUNT_POINTS['servedFS']);
    } else {
      SELF['servedFS'] = SANDBOX_MOUNT_POINTS['servedFS'];
    }
  };
  
  if ( is_defined(SANDBOX_MOUNT_POINTS['mountedFS']) ) {
    if ( is_defined(SELF['mountedFS']) ) {
      SELF['mountedFS'] = merge(SELF['mountedFS'],SANDBOX_MOUNT_POINTS['mountedFS']);
    } else {
      SELF['mountedFS'] = SANDBOX_MOUNT_POINTS['mountedFS'];
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

