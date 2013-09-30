
# This template configures the current node as a NFS server if it is listed
# as a NFS server for any filesystem in NFS_MOUNT_POINTS['servedFS']. If it is not, this
# template does nothing to the current configuration.

unique template common/nfs/server/config;

variable NFS_VIRTUAL_ROOT ?= '/export';
variable NFS_V4_EXPORT_COMMON_OPTS ?= 'insecure,no_subtree_check';
variable NFS_V4_EXPORT_OPTS ?='nohide,'+NFS_V4_EXPORT_COMMON_OPTS;
variable NFS_VIRTUAL_ROOT_EXPORT_HOST ?= '*';
variable NFS_VIRTUAL_ROOT_EXPORT_OPTS ?= 'fsid=0,'+NFS_V4_EXPORT_COMMON_OPTS;

# NFS_DEFAULT_RIGHTS must contain a DEFAULT entry and may contain one entry per
# file system (escaped) specifying the default to apply to this particular file system.
# By default, enable root squashing on all file systems, except home directory parents
# (required for account configuration). Entries explicitly set by a site are not overwritten.
# These defaults don't apply to hosts with specific rights defined, like CE. 

variable NFS_DEFAULT_RIGHTS = {
  if ( exists(SELF['DEFAULT']) && is_defined(SELF['DEFAULT']) ) {
    SELF['DEFAULT'] = replace('[\(\)]','',SELF['DEFAULT']);
  } else {
    SELF['DEFAULT'] = 'rw';
  };
  homedirs = nlist();
  foreach (i;vo;VOS) {
    if ( is_defined(VO_INFO[vo]['accounts']['users']) ) {
      foreach (user;params;VO_INFO[vo]['accounts']['users']) {
        if ( exists(params['homeDir']) && is_defined(params['homeDir']) ) {
          if ( !is_defined(homedirs[escape(params['homeDir'])]) ) {
            toks = matches(params['homeDir'],'(?:/([\w\-\.]+))');
            if ( is_defined(params['poolSize']) && (params['poolSize'] == 0) ) {
              tok_max = length(toks);
            } else {
              # Take only the parent into consideration
              tok_max = length(toks) - 1;
            };
            path = '';
            foreach (i;tok;toks) {
              if ( (i > 0) && (i <= tok_max) ) {
                path = '/' + tok;
                homedirs[escape(path)] = '';
              };
            };
          } else {
            homedirs[escape('/home')] = '';
          };
        };
      };
    };
  };
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['servedFS']) {
    if ( exists(homedirs[e_mnt_point]) && !exists(SELF[e_mnt_point]) ) {
      SELF[e_mnt_point] = '(rw,no_root_squash)';
    };
  };
  SELF;
};


# Build SITE_NFS_ACL as a nlist with one entry per file system (escaped).
# Value is a nlist with one entry per (escaped) host regexp whose value is the export options.
variable SITE_NFS_ACL  ?= {
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['servedFS']) {
    SELF[e_mnt_point] = nlist();
    if ( exists(NFS_CLIENT_HOSTS[e_mnt_point]) && is_defined(NFS_CLIENT_HOSTS[e_mnt_point]) ) {
      entry = e_mnt_point;
    } else if ( exists(NFS_CLIENT_HOSTS['DEFAULT']) && is_defined(NFS_CLIENT_HOSTS['DEFAULT']) ) {
      entry = 'DEFAULT';
    } else {
      error('DEFAULT entry missing or invalid in NFS_CLIENT_HOSTS'); 
    }; 
    foreach (host;nfs_rigths;NFS_CLIENT_HOSTS[entry]) {
      if ( is_defined(nfs_rigths) ) {
        export_options = nfs_rigths;
      } else if ( exists(NFS_DEFAULT_RIGHTS[e_mnt_point]) && is_defined(NFS_DEFAULT_RIGHTS[e_mnt_point]) ) {
        export_options = NFS_DEFAULT_RIGHTS[e_mnt_point];
      } else if ( exists(NFS_DEFAULT_RIGHTS['DEFAULT']) && is_defined(NFS_DEFAULT_RIGHTS['DEFAULT']) ) {
        export_options = NFS_DEFAULT_RIGHTS['DEFAULT'];
      } else {
        error('DEFAULT entry missing in NFS_DEFAULT_RIGHTS');
      };
      export_options = replace('[\(\)]','',export_options);
      SELF[e_mnt_point][host] = export_options;
    };
  };
  SELF;
};


# ----------------------------------------------------------------------------
# Enable and configure NFS server
# ----------------------------------------------------------------------------
include { 'components/chkconfig/config' };
include { 'components/filecopy/config' };

"/software/components/chkconfig/service" = {
  SELF["nfs"] = nlist("on","",
                      "startstop", true);
  SELF["nfslock"] = nlist("on","",
                          "startstop", true);
  SELF;
};

"/software/components/filecopy" = {
  if ( !is_defined(SELF['services']) ) {
    SELF['services'] = nlist();
  };
  if ( is_defined(NFS_THREADS[FULL_HOSTNAME]) ) {
    nfs_sysconfig = "/etc/sysconfig/nfs";
    SELF['services'][escape(nfs_sysconfig)] = nlist("config","RPCNFSDCOUNT="+to_string(NFS_THREADS[FULL_HOSTNAME]),
                                                    "owner","root",
                                                    "perms","0644",
                                                    "restart","/etc/init.d/nfs restart");
  };
  SELF;
};


# ----------------------------------------------------------------------------
# NFS exports
# ----------------------------------------------------------------------------

include { 'components/nfs/config' };

"/software/components/nfs" = { 
  if ( !exists(SELF['exports']) || !is_defined(SELF['exports']) ) {
    SELF['exports'] = list();
  };
  if ( !exists(SELF['mounts']) || !is_defined(SELF['mounts']) ) {
    SELF['mounts'] = list();
  };
  nfsv4_virtual_root_added = false;
  foreach (e_mnt_point;params;NFS_MOUNT_POINTS['servedFS']) {
    # For backward compatibility : SITE_NFS_ACL used to be a string, applied to all mount points.
    if ( is_nlist(SITE_NFS_ACL) ) {
      if ( exists(SITE_NFS_ACL[e_mnt_point]) && is_defined(SITE_NFS_ACL[e_mnt_point]) ) {
        acl_entry = SITE_NFS_ACL[e_mnt_point];
      } else if ( exists(SITE_NFS_ACL['DEFAULT']) && is_defined(SITE_NFS_ACL['DEFAULT']) ) {
        acl_entry = SITE_NFS_ACL['DEFAULT'];
      } else {
        error('Unable to locate NFS ACL applyable to '+mnt_point+' and no default entry defined');
      };
    } else if ( is_list(SITE_NFS_ACL) ) {
      error('SITE_NFS_ACL format is obsolete. Must be a nlist of nlist');
    } else {
      error('SITE_NFS_ACL has an invalid type: must be a list or nlist');
    };
    
    # NFS v3
    if ( !is_defined(params['nfsVersion']) || (params['nfsVersion'] == '3') ) { 
      debug('Exporting FS '+params['localPath']+' for NFS v3');
      SELF['exports'][length(SELF['exports'])] = nlist("path",params['localPath'],
                                                       "hosts",acl_entry);
    };
    
    # NFS v4
    if ( !is_defined(params['nfsVersion']) || (params['nfsVersion'] == '4') ) {
      if ( !nfsv4_virtual_root_added ) {
        debug('Exporting NFS v4 virtual root ('+NFS_VIRTUAL_ROOT+')');
        SELF['exports'][length(SELF['exports'])] = nlist("path", NFS_VIRTUAL_ROOT,
                                                         "hosts", nlist(escape(NFS_VIRTUAL_ROOT_EXPORT_HOST),
                                                                        NFS_DEFAULT_RIGHTS['DEFAULT']+','+
                                                                            NFS_VIRTUAL_ROOT_EXPORT_OPTS),
                                                        );
        nfsv4_virtual_root_added = true;
      };
      acl_entry_v4 = nlist();
      foreach (host;options;acl_entry) {
        acl_entry_v4[host] = options+','+NFS_V4_EXPORT_OPTS;
      };
      export_path = NFS_VIRTUAL_ROOT + params['localPath'];
      debug('Exporting FS '+params['localPath']+' for NFS v4 ('+export_path+')');
      SELF['exports'][length(SELF['exports'])] = nlist("path", export_path,
                                                       "hosts", acl_entry_v4);

      # Bind file system to export mount point
      SELF['mounts'][length(SELF['mounts'])] = nlist("device",params['localPath'],
                                                     "mountpoint", export_path,
                                                     "fstype","none",
                                                     "options","bind");
      
    };
  }; 

  SELF;
};

