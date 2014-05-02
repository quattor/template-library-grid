# ---------------------------------------------------------------------------------------------
# Check if this machine is a NFS server for some filesystems or needs to mount NFS file systems
# according to definition of shared areas and define NFS_SERVER_ENABLED/NFS_CLIENT_ENABLED accordingly.
# Both of these variables can be defined explicitly in the site parameters or machine profile.
# In particular, when shared areas must be ignored on a node, define NFS_CLIENT_ENABLED=false in
# its profile.
#
# In addition this template does a few early initializations for NFS configuration, like relocating
# /home when it is NFS mounted and VO_HOMES_NFS_ROOT is defined.
# ---------------------------------------------------------------------------------------------

unique template features/nfs/init;

variable NFS_DEFAULT_MOUNT_OPTIONS ?= "rw,noatime";
variable NFS_DEFAULT_VERSION ?= '3';

# The following variables allow other components to subscribe to the actual component configuring the
# NFS client as their pre or post dependency. This is necessary to do this this way as in this case
# NFS will be configured at the very end of the configuration.
variable NFS_CLIENT_PREDEP_SUBSCRIBERS = list();
variable NFS_CLIENT_POSTDEP_SUBSCRIBERS = list();


# NFS_CLIENT_VERSION and NFS_CLIENT_DEFAULT_VERSION are nlists that allow to specify
# NFS version to use on the client.
# In NFS_CLIENT_VERSION, the key is a host name.
# In NFS_CLIENT_DEFAULT_VERSION, the key is either 'DEFAULT' or a an escaped regexp that
# will matched again the host name of the current machine.
# If no 'DEFAULT' entry is defined and no other entry matches,  NFS_DEFAULT_VERSION is used
variable NFS_CLIENT_VERSION ?= nlist();
variable NFS_CLIENT_DEFAULT_VERSION = {
  if ( !is_defined(SELF['DEFAULT']) ) {
    SELF['DEFAULT'] = NFS_DEFAULT_VERSION;
  };
  SELF;
};


# Compute from WN_SHARED_AREAS list of file systems either served by this machine
# or needed to be NFS mounted.

variable NFS_MOUNT_POINTS = {
  SELF['mountedFS'] = nlist();
  SELF['servedFS'] = nlist();
  
  if ( is_defined(WN_SHARED_AREAS) ) {
    if ( ! is_nlist(WN_SHARED_AREAS) ) {
      error("WN_SHARED_AREAS must be a nlist");
    };
    if ( length(WN_SHARED_AREAS) == 0 ) {
      return(SELF);
    };
  } else {
    return(SELF);
  };
  
  foreach (e_mnt_point;mnt_path;WN_SHARED_AREAS) {
    mnt_point = unescape(e_mnt_point);
    if ( !match(mnt_point,'^/') ) {
      error('Mount point must start with / ('+mnt_point+')');
    }; 
    # An undefined or empty mnt_path means mount must not be handled by NFS templates.
    # Value of WN_SHARED_AREAS entries are parsed and split in 3 tokens:
    #   - An optional protocol followed by ://. If empty, assume NFS if host name is defined.
    #   - A host name
    #   - An optional mount point on the host name, starting with a / (default is the same as the NFS mount point)
    if ( is_defined(mnt_path) || (length(mnt_path) > 0) ) {
      nfs_shared_area = true;
      mnt_path_toks = matches(mnt_path, '^(?:(nfs[34]?)://)([\w\-\.]+):?((?:/[\w\.\-]*)*)');
      if ( length(mnt_path_toks) == 0 ) {
        # Backward compatibility : server or server:/mnt/point
        # 'server' must be a fully qualified name to avoid ambiguity with protocol in previous format.
        # Ensure the 'protocol' token is present as empty for compatibility with previous regexp.
        mnt_path_toks = matches(mnt_path, '^()((?:[\w\-]+\.)+(?:[\w\-]+)):?((?:/[\w\.\-]*)*)');
        if ( length(mnt_path_toks) == 0 ) {
          debug('FS '+mnt_point+': not a NFS-served filesystem. Ignoring.');
          nfs_shared_area = false;
        };
      };
  
      if ( nfs_shared_area ) {
        debug('mnt_path_toks='+to_string(mnt_path_toks));
        mnt_host = mnt_path_toks[2];

        # Check this is a NFS-served shared areas and retrieve NFS version to use.
        # A NFS-served shared areas either has a protocol name 'nfs*' or has no
        # protocol but host name is present (backward compatibility, enforced by previous regexp).
        if ( is_defined(mnt_path_toks[1]) && (length(mnt_path_toks[1]) > 0) ) {
          nfs_version_toks = matches(mnt_path_toks[1],'^nfs([3|4]?)$');
          debug('nfs_version_toks = '+to_string(nfs_version_toks));
          if ( length(nfs_version_toks) > 0 ) {
            nfs_version = nfs_version_toks[1];
            if ( length(nfs_version) == 0 ) {
              # When undefined will default to both nfs3 and nfs4 on the server and nfs3 on the client
              nfs_version = undef;
            };
          } else {
            error('FS '+mnt_point+': protocol is not a supported NFS version ('+nfs_version+')');
          };
        } else {
          # Old format : use nfs v3 for backward compatibility
          debug('NFS old format : using default NFS version ('+NFS_DEFAULT_VERSION+')');
          nfs_version = NFS_DEFAULT_VERSION;
        };
  
        # FS served by this machine
        if ( mnt_host == FULL_HOSTNAME ) {
          if ( length(mnt_path_toks[3]) == 0 ) {
            mnt_path = unescape(e_mnt_point);
          } else {
            mnt_path = mnt_path_toks[3];
          };
          SELF['servedFS'][e_mnt_point] = nlist('localPath',mnt_path,
                                                'nfsVersion', nfs_version);
    
        # FS to be NFS mounted on this machine

        } else {
          # FIXME: following code is commented out because host names are specified as export regexp that are 
          # not compatible with PAN regexp (use of '*' and '?' wildcards that need to be substituted for match())
          # host list contained in NFS_CLIENT_HOSTS for each file system is a nlist where the key is a regexp matching
          # the host name
          #if ( exists(NFS_CLIENT_HOSTS[e_mnt_point]) && is_defined(NFS_CLIENT_HOSTS[e_mnt_point]) ) {
          #  host_list = NFS_CLIENT_HOSTS[e_mnt_point];
          #} else {
          #  # NFS_CLIENT_HOSTS['DEFAULT'] must exists
          #  host_list = NFS_CLIENT_HOSTS['DEFAULT'];
          #};
          #found = false;
          #ok = first(host_list,e_regexp,v);
          #while ( ok && !found ) {
          #  regexp = unescape(e_regexp);
          #  if ( match(FULL_HOSTNAME,regexp) ) {
          #    found = true;
          #  };
          #  ok = next(host_list,e_regexp,v);
          #};
      
          if ( is_defined(mnt_path_toks[3]) && (length(mnt_path_toks[3]) > 0) ) {
            mnt_path = mnt_host + ':' + mnt_path_toks[3];
          } else {
            mnt_path = mnt_host + ':' + mnt_point;
          };
          
          # Define NFS version to use if undef
          if ( !is_defined(nfs_version) ) {
            if ( is_defined(NFS_CLIENT_VERSION[FULL_HOSTNAME]) ) {
              nfs_version = NFS_CLIENT_VERSION[FULL_HOSTNAME];
              debug('Explicit NFS version found for '+FULL_HOSTNAME+' ('+nfs_version+')');
            } else {
              not_found = true;
              ok = first(NFS_CLIENT_DEFAULT_VERSION,regexp_e,version);
              while ( ok && not_found ) {
                regexp = unescape(regexp_e);
                if ( match(FULL_HOSTNAME,regexp) ) {
                  nfs_version = version;
                  debug(FULL_HOSTNAME+' matching '+regexp+': setting NFS version to '+nfs_version);
                  not_found = false;
                };
                ok = next(NFS_CLIENT_DEFAULT_VERSION,regexp_e,version);
              };
              
              if ( not_found ) {
                nfs_version = NFS_CLIENT_DEFAULT_VERSION['DEFAULT'];
                debug('Setting NFS version to default ('+nfs_version+')');
              };
            };
          };
          
          SELF['mountedFS'][e_mnt_point] =  nlist('nfsPath',mnt_path,
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

  debug('NFS_MOUNT_POINTS = '+to_string(NFS_MOUNT_POINTS));
  SELF;  
};


# Define NFS_SERVER_ENABLED based on NFS_MOUNT_POINTS['servedFS']
# It is not possible to explicitly define NFS_SERVER_ENABLED.

variable NFS_SERVER_ENABLED = {
  if ( length(NFS_MOUNT_POINTS['servedFS']) > 0 ) {
    true;
  } else {
    false;
  };
};                          


# Define NFS_CLIENT_ENABLED based on NFS_MOUNT_POINTS['mountedFS'] if not already
# explicitly defined to disable NFS mount of FS in WN_SHARED_AREAS.

variable NFS_CLIENT_ENABLED ?= {
  if ( length(NFS_MOUNT_POINTS['mountedFS']) > 0 ) {
    true;
  } else {
    false;
  };
};


# Relocate home directory parent for pool accounts if it is /home and VO_HOMES_NFS_ROOT is defined,
# when NFS is enabled (either server or client).
# Also ensure that mount point is consistent with the relocation if using the
# standard template to configure the partitionning.

variable VO_HOMES = {
  if ( !is_defined(SELF['DEFAULT']) ) {
    SELF['DEFAULT'] = '/home';
  };
  if ( (NFS_CLIENT_ENABLED || NFS_SERVER_ENABLED) &&
        is_defined(VO_HOMES_NFS_ROOT) &&
        (length(VO_HOMES_NFS_ROOT) > 0) ) {
    foreach (vo;parent;SELF) {
      SELF[vo] = replace('^/home',VO_HOMES_NFS_ROOT,parent);
    };
  };
  SELF;
};

variable DISK_GLITE_HOME_MOUNTPOINT ?= {
  home_mntpoint = undef;
  if (  (NFS_SERVER_ENABLED) &&
        is_defined(VO_HOMES_NFS_ROOT) &&
        (length(VO_HOMES_NFS_ROOT) > 0) ) {
    vo_homes = VO_HOMES;
    ok_vo = first(vo_homes,vo,parent);
    while (ok_vo) {
      if ( match(parent,'^'+VO_HOMES_NFS_ROOT) ) {
        ok_vo = false;
        nfs_mntpoints = NFS_MOUNT_POINTS['servedFS'];
        ok = first(nfs_mntpoints,e_mnt_point,params);
        while (ok) {
          if ( unescape(e_mnt_point) == VO_HOMES_NFS_ROOT ) {
            home_mntpoint = VO_HOMES_NFS_ROOT;
            ok = false;
          } else {
            ok = next(nfs_mntpoints,e_mnt_point,params);
          };
        };
      } else {
        ok_vo = next(vo_homes,vo,parent);
      };
    };
  };
  home_mntpoint;
};
