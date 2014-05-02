unique template features/mkgridmap/standard;


include { 'features/mkgridmap/base' };



include { 'components/mkgridmap/config' };



# The command to regenerate the gridmap file. 
variable MKGRIDMAP_CMD = MKGRIDMAP_BIN+"/edg-mkgridmap --conf=" + MKGRIDMAP_DEF_CONF + " --output="+SITE_DEF_GRIDMAP+" --safe";

# Whether to overwrite an existing local grid mapfile with entries
# defined in the configuration
variable MKGRIDMAP_OVERWRITE ?= true;

# Local grid mapfile name
variable MKGRIDMAP_LOCAL_MAPFILE ?= MKGRIDMAP_CONF_DIR+'/grid-mapfile-local';

# Local grid mapfile entries.
# Nlist where the key is the escaped certificated and the value is the user to map to
variable MKGRIDMAP_LOCAL_ENTRIES ?= nlist();


#---------------------------------------------------------------------------- 
# Define a default value for LCMAPS gridmapfile and groupmapfile
#---------------------------------------------------------------------------- 

variable LCMAPS_FLAVOR ?= 'glite';
"/software/components/mkgridmap/lcmaps/flavor" ?= LCMAPS_FLAVOR;
"/software/components/mkgridmap/lcmaps/gridmapfile" ?= MKGRIDMAP_LCMAPS_DIR + "gridmapfile";
"/software/components/mkgridmap/lcmaps/groupmapfile" ?= MKGRIDMAP_LCMAPS_DIR + "groupmapfile";


#---------------------------------------------------------------------------- 
# cron 
#---------------------------------------------------------------------------- 
include { 'components/cron/config' };

# The authorized users can change, so update the gridmap file regularly. 
"/software/components/cron/entries" =
  push(nlist(
    "name","grid-mapfile-update",
    "user","root",
    "frequency", MKGRIDMAP_REFRESH_INTERVAL,
    "command", MKGRIDMAP_CMD));


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
include { 'components/altlogrotate/config' }; 

"/software/components/altlogrotate/entries/grid-mapfile-update" = 
  nlist("pattern", "/var/log/grid-mapfile-update.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 2);


#---------------------------------------------------------------------------- 
# mkgridmap
# Note: VO-related configuration is controlled through VO configuration
#---------------------------------------------------------------------------- 

"/software/components/mkgridmap/entries/edg-mapfile" = {

    # mapfile format (edg or lcgdm) 
    SELF["format"] = "edg";

    # The location of the configuration file. 
    SELF["mkgridmapconf"] = MKGRIDMAP_DEF_CONF;

    # Set the command for regenerating the gridmap file. 
    SELF["command"] = MKGRIDMAP_CMD;

    # Overwrite existiong local grid mapfile with entries defined in the configuration
    SELF["overwrite"] = MKGRIDMAP_OVERWRITE;

    # Local grid mapfile location
    SELF["gmflocal"] = MKGRIDMAP_LOCAL_MAPFILE;

    # Entries to add to local grid mapfile
    if ( !is_defined(SELF["locals"]) ) {
      SELF["locals"] = list();
    };
    foreach (e_cert;user;MKGRIDMAP_LOCAL_ENTRIES) {
      SELF["locals"][length(SELF["locals"])] = nlist('cert', unescape(e_cert),
                                                     'user', user,
                                                    );
    };

   SELF;
};


