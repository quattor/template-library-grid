# Template to configure mkgridmap for lcgdm format (used mainly by LFC and DPM)

unique template feature/mkgridmap/lcgdm;

include { 'feature/mkgridmap/base' };

include { 'components/mkgridmap/config' };

variable MKGRIDMAP_DPMLFC_CONF ?= MKGRIDMAP_CONF_DIR+"/lcgdm-mkgridmap.conf";


# The command to regenerate the gridmap file. 
variable MKGRIDMAP_CMD = 
  MKGRIDMAP_BIN+"/edg-mkgridmap --conf="+MKGRIDMAP_DPMLFC_CONF+" --output="+SITE_DPMLFC_GRIDMAP+" --safe";

# Whether to overwrite an existing local grid mapfile with entries
# defined in the configuration
variable MKGRIDMAP_DPMLFC_OVERWRITE ?= true;

# Local grid mapfile name
variable MKGRIDMAP_DPMLFC_LOCAL_MAPFILE ?= MKGRIDMAP_CONF_DIR+'/lcgdm-mapfile-local';

# Local grid mapfile entries.
# Nlist where the key is the escaped certificated and the value is the user to map to
variable MKGRIDMAP_DPMLFC_LOCAL_ENTRIES ?= nlist();


#---------------------------------------------------------------------------- 
# cron 
#---------------------------------------------------------------------------- 
include { 'components/cron/config' };

# The authorized users can change, so update the gridmap file regularly. 
"/software/components/cron/entries" =
  push(nlist(
    "name","lcgdm-mapfile-update",
    "user","root",
    "frequency", "AUTO 1,7,13,19 * * *",
    "command", MKGRIDMAP_CMD));


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
include { 'components/altlogrotate/config' }; 

"/software/components/altlogrotate/entries/lcgdm-mapfile-update" = 
  nlist("pattern", "/var/log/lcgdm-mapfile-update.ncm-cron.log",
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

"/software/components/mkgridmap/entries/lcgdm-mapfile" = {

    # mapfile format (edg or lcgdm) 
    SELF["format"] = "lcgdm";

    # The location of the configuration file. 
    SELF["mkgridmapconf"] = MKGRIDMAP_DPMLFC_CONF;

    # Set the command for regenerating the gridmap file. 
    SELF["command"] = MKGRIDMAP_CMD;

    # Overwrite existiong local grid mapfile with entries defined in the configuration
    SELF["overwrite"] = MKGRIDMAP_DPMLFC_OVERWRITE;

    # Local grid mapfile location
    SELF["gmflocal"] = MKGRIDMAP_DPMLFC_LOCAL_MAPFILE;

    # Entries to add to local grid mapfile
    if ( !is_defined(SELF["locals"]) ) {
      SELF["locals"] = list();
    };
    foreach (e_cert;user;MKGRIDMAP_DPMLFC_LOCAL_ENTRIES) {
      SELF["locals"][length(SELF["locals"])] = nlist('cert', unescape(e_cert),
                                                     'user', user,
                                                    );
    };

   SELF;
};

