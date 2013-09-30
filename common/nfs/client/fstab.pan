unique template common/nfs/client/fstab;


# ---------------------------------------------------------------------------- 
# nfs
# ---------------------------------------------------------------------------- 
include { 'components/nfs/config' };


# Add file systems to mount

"/software/components/nfs/mounts" = { 
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['mountedFS']) {
    if ( is_defined(params["nfsVersion"]) && (params["nfsVersion"] == '4') ) {
      fstype = 'nfs4';
    } else {
      fstype = 'nfs';
    };
    debug('Mounting FS '+params['nfsPath']+' as '+unescape(e_mnt_point)+' (fstype='+fstype+')');
    mnt_ind = length(SELF);
    SELF[mnt_ind] =  nlist("device",params['nfsPath'],
                           "mountpoint",unescape(e_mnt_point),
                           "fstype",fstype);
    if ( exists(NFS_MOUNT_OPTS[e_mnt_point]) && is_defined(NFS_MOUNT_OPTS[e_mnt_point]) ) {
      SELF[mnt_ind]["options"] = NFS_MOUNT_OPTS[e_mnt_point];
    } else {
      SELF[mnt_ind]["options"] = NFS_DEFAULT_MOUNT_OPTIONS;
    };
  };
  SELF;
};

