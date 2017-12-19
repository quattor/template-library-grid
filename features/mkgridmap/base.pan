
unique template features/mkgridmap/base;

# Add RPMs
include { 'features/mkgridmap/rpms' };

# Hack to workaround an undefined conf path listen by ncm-mkgridmap
'/system/edg/config/EDG_LOCATION' = 'Not.used.anymore';

include { 'components/mkgridmap/config' };

variable MKGRIDMAP_BIN ?= GLITE_LOCATION_SBIN;
variable MKGRIDMAP_CONF_DIR ?= GLITE_LOCATION_ETC;
variable MKGRIDMAP_LCMAPS_DIR ?= GLITE_LOCATION_ETC+'/lcmaps/';
variable MKGRIDMAP_DEF_CONF ?= MKGRIDMAP_CONF_DIR+"/edg-mkgridmap.conf";

# Update gridmap file every 30mn on a UI as it relies only on gridmap file
# Run every 3 hours on services relying mainly on VOMS
variable MKGRIDMAP_REFRESH_INTERVAL = if ( exists(GSISSH_SERVER_ENABLED) &&
                                           is_defined(GSISSH_SERVER_ENABLED) &&
                                           GSISSH_SERVER_ENABLED ) {
                                        return("0-59/30 * * * *");
                                      } else {
                                        return("AUTO 0-23/3 * * *");
                                      };


#----------------------------------------------------------------------------
# gridmapdir
# If GLITE_GROUP is defined, define gridmapdir group to this group and
# give write permission to the group.
# If GRIDMAPDIR_SHARED_PATH is defined, it must be the path to the shared
# gridmapdir. If the sharing protocol is NFS, configure NFS.
#----------------------------------------------------------------------------
include { 'components/gridmapdir/config' };

"/software/components/gridmapdir/" = {
  SELF['gridmapdir'] = SITE_DEF_GRIDMAPDIR;

  # Shared gridmapdir, if enabled, is configured only on listed clients,
  # if a list is defined. If gridmapdir is NFS-shared, do not configure
  # the sharedGridmapdir property on the machine serving it.
  if ( is_defined(GRIDMAPDIR_SHARED_PATH) ) {
    if ( ((GRIDMAPDIR_SHARED_SERVER != FULL_HOSTNAME) || !match(to_lowercase(GRIDMAPDIR_SHARED_PROTOCOL), '^nfs')) &&
         (!is_defined(GRIDMAPDIR_SHARED_CLIENTS) || (index(FULL_HOSTNAME,GRIDMAPDIR_SHARED_CLIENTS) >= 0) ) ) {
      SELF['sharedGridmapdir'] = GRIDMAPDIR_SHARED_PATH;
    };
  };

  if ( is_defined(GLITE_GROUP) ) {
    SELF['group'] = GLITE_GROUP;
    SELF['perms'] = '0775';
  };

  SELF;
};

variable GRIDMAPDIR_SHARED_NFS_INCLUDE = {
  if ( is_defined(GRIDMAPDIR_SHARED_PATH) && match(to_lowercase(GRIDMAPDIR_SHARED_PROTOCOL), '^nfs') ) {
    'features/nfs/gridmapdir';
  } else {
    undef;
  };
};
include { GRIDMAPDIR_SHARED_NFS_INCLUDE };

# Subscribe to NFS client configuration as a pre dependency
variable NFS_CLIENT_PREDEP_SUBSCRIBERS = {
  if ( is_defined(GRIDMAPDIR_SHARED_NFS_INCLUDE) &&
       (GRIDMAPDIR_SHARED_SERVER != FULL_HOSTNAME) ) {
    SELF[length(SELF)] = 'gridmapdir';
  };
  SELF;
};

#----------------------------------------------------------------------------
# cron
#----------------------------------------------------------------------------
include { 'components/cron/config' };

"/software/components/cron/entries" =
  push(nlist(
    "name","lcg-expiregridmapdir",
    "user","root",
    "frequency", "0 5 * * *",
    "command", MKGRIDMAP_BIN+"/lcg-expiregridmapdir.pl -v 1"));


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/lcg-expiregridmapdir" =
  nlist("pattern", "/var/log/lcg-expiregridmapdir.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 2);


