unique template features/nfs/client/autofs;


# ---------------------------------------------------------------------------- 
# Build an indirect map for all the specified NFS filesystems.
# An indirect map is used instead of a direct map because direct map
# support on Linux (as of SL3/4) is broken and disabled by default.
# The workaround is to use an indirect map mounted on a special mount
# point and define symlinks corresponding to user's view of mount point.
# ---------------------------------------------------------------------------- 
include { 'components/autofs/config' };
include { 'components/symlink/config' };

# Add autofs rpm
include { 'rpms/nfs-client' };

variable NFS_MAP_MOUNT_POINT ?= "/grid_mnt";

"/software/components/autofs/maps/grid/mapname" = "/etc/auto.grid";
"/software/components/autofs/maps/grid/type" = "file";
"/software/components/autofs/maps/grid/options" = NFS_DEFAULT_MOUNT_OPTIONS+",hard";   # Mount hard 
"/software/components/autofs/maps/grid/mountpoint" = NFS_MAP_MOUNT_POINT;


# Define autofs entries based on NFS_MOUNT_POINTS['mountedFS']

variable NFS_MOUNT_POINTS = {
  foreach (e_mnt_point;params;SELF['mountedFS']) { 
    # With indirect map, mount point in the map must be a relative path and
    # cannot contain any '/'. Thus the specified mount point must be rewritten:
    # initial / is removed, other / are replaced by __
    autofs_mnt_point = replace('^/','',unescape(e_mnt_point));
    autofs_mnt_point = replace('/','__',autofs_mnt_point);
    params["mntpoint"] = autofs_mnt_point;
  };
  SELF;
};

"/software/components/autofs/maps/grid/entries" = {
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['mountedFS']) { 
    e_autofs_mnt_point = escape(params['mntpoint']);
    if ( !exists(SELF[e_autofs_mnt_point]) || !is_defined(SELF[e_autofs_mnt_point]) ) {
      debug('Mounting FS '+params['nfsPath']+' as '+NFS_MAP_MOUNT_POINT+'/'+params['mntpoint']);
      SELF[e_autofs_mnt_point]["location"] = params['nfsPath'];
      if ( exists(params['options']) && is_defined(params['options']) && (params['options'] != NFS_DEFAULT_MOUNT_OPTIONS) ) {
        SELF[e_autofs_mnt_point]["options"] = params['options'];
      } else {
        # ncm-autofs doesn't properly handle undefined options
        SELF[e_autofs_mnt_point]["options"] = '';
      };
      if ( is_defined(params["nfsVersion"]) ) {
        if ( match(params["nfsVersion"], '2|3|4') ) {
          debug('Mounting FS '+params['nfsPath']+' with NFS version '+params["nfsVersion"]);
          if ( length(SELF[e_autofs_mnt_point]["options"]) > 0 ) {
            SELF[e_autofs_mnt_point]["options"] = SELF[e_autofs_mnt_point]["options"] + ',';
          };
          SELF[e_autofs_mnt_point]["options"] = SELF[e_autofs_mnt_point]["options"] + 'nfsvers=' + params['nfsVersion'];
        } else {
          error(format('Invalid NFS version specified (%s) for %s', params['nfsVersion'], params['mntpoint']));
        };
      } else {
        debug('Mounting FS '+params['nfsPath']+' with NFS default version');
      };
    } else {
      debug('Mount point '+params['mntpoint']+' already defined');
    };
  };
          
  SELF;  
};

"/software/components/autofs/maps/grid/enabled" = 
    if ( exists("/software/components/autofs/maps/grid/entries") &&
         length(value("/software/components/autofs/maps/grid/entries")) > 0 ) {
      true;
    } else {
      false;
    };
    
"/software/components/autofs/maps/grid/preserve" = false;


# Define symlinks to actual mount point
"/software/components/symlink/links" = {
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['mountedFS']) {
    SELF[length(SELF)] = nlist("name", unescape(e_mnt_point),
                               "target", NFS_MAP_MOUNT_POINT+'/'+params['mntpoint'],
                               "exists", false,
                               "replace", nlist("all","yes"),
                              );
  };
  if ( is_defined(SELF) ) {
    SELF;
  } else {
    debug(OBJECT+': no NFS client mount point defined');
    null;
  };
};


# When using autofs to mount directories, make sure that ncm-autofs
# is defined as pre dependency for ncm-accounts to avoid problems
# when creating home directories
variable AUTOFS_NEEDED = {
	if (exists(NFS_AUTOFS) && is_defined(NFS_AUTOFS) && NFS_AUTOFS && exists('/software/components/autofs/maps/grid/enabled') && value('/software/components/autofs/maps/grid/enabled')) {
		true;
	} else {
		 false;
	};
};		
"/software/components/accounts/dependencies/pre" = {
	if( AUTOFS_NEEDED ) {
	  if ( is_defined(SELF) ) {
		  SELF[length(SELF)]="autofs";
		} else {
		  SELF[0] = "autofs";
		}
	};
	SELF;	
};
"/software/components/chkconfig/service/" = {
  if( AUTOFS_NEEDED ) {
    SELF["autofs"] = nlist("on","",
                           "startstop",true,
                          );
  };
  SELF;
};

  
