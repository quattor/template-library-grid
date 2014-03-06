unique template feature/yaim/config;

include { 'components/yaim/config' };


# to prevent the implicit construction of the latter if YAIM_VO_CONFIG == false
"/software/components" = {
    SELF['yaim']['vo'] = add_vos_to_yaim();
    SELF;
};

# add the certificates for the VOMS servers defined in VOMS_SERVERS
"/software/components" = add_voms_certs();


# poor man's attempt to define all variables that are used
# in the Yaim mapping function
include { 'feature/yaim/init-variables' };

# Contents of config files; needs the locations defined above
variable YAIM_CONFIG_SITE ?= null;
include { return(YAIM_CONFIG_SITE); };

variable YAIM_VERSION ?= "4.0";
variable YAIM_FUNCTIONS_DIR ?= "/opt/glite/yaim/functions";

include { 'feature/yaim/mapping_functions' };

#
# load Yaim configuration
#

variable WNLIST_CONFIG_SITE ?= undef;
variable YAIM_WNLIST_CFGFILE ?= null;
include { WNLIST_CONFIG_SITE };

# populate WN list
variable YAIM_WNLIST = {
    l = null;
    if ( is_defined( WNLIST ) ) {
        l = "";
        foreach( wn; wnt; WNLIST) {
            l = l + wn + "\n";
        };
    };
    l;
};

# default: diffent pool accounts per VO and/or group
variable USE_DYNAMIC_POOL_ACCOUNTS ?= false;
variable DYNAMIC_USER ?= nlist(
    'account',  'dyn00000',
    'group',    list('dynamic'),
);

# populate users.conf from VO_CONFIG
variable YAIM_USERSCONF_LOCAL ?= "";
variable YAIM_USERSCONF = {
    x = "" + YAIM_USERSCONF_LOCAL;

    foreach ( i; vocfg; VO_CONFIG ) {
        if ( USE_DYNAMIC_POOL_ACCOUNTS ) {
            x = x + yaim_user_line( DYNAMIC_USER, vocfg['name'] ) + "\n";
        }
        else if ( exists( vocfg['mapping'] ) ) {
            foreach ( j; rolegroup; vocfg['mapping'] ) {
                x = x + yaim_user_line( rolegroup, vocfg['name'] ) + "\n";
            };
        };
    };
    x;
};

# populate groups.conf from VO_CONFIG
variable YAIM_GROUPSCONF_LOCAL ?= null;
variable YAIM_GROUPSCONF = {
    x = "";
    
    foreach ( i; vocfg; VO_CONFIG ) {
        if ( exists( vocfg['mapping'] ) ) {
            foreach ( j; rolegroup; vocfg['mapping'] ) {
                x = x + yaim_group_line( rolegroup ) + "\n";
            };
        };
        
    };
    x;
};

# copy users, groups and worker node configurations via filecopy
variable YAIM_USERSCONF_CFGFILE ?= null;
variable YAIM_GROUPSCONF_CFGFILE ?= null;

"/software/components/filecopy/services" = {
    x = SELF;
    if ( is_defined(YAIM_USERSCONF_CFGFILE) && is_defined( YAIM_USERSCONF ) ) {
        x[escape(YAIM_USERSCONF_CFGFILE)] = nlist("config",YAIM_USERSCONF, "perms","0644");
    };
    if ( is_defined(YAIM_GROUPSCONF_CFGFILE) && is_defined( YAIM_GROUPSCONF ) ) {
        x[escape(YAIM_GROUPSCONF_CFGFILE)] = nlist("config",YAIM_GROUPSCONF, "perms","0644");
    };
    if ( is_defined(YAIM_WNLIST_CFGFILE) && is_defined( YAIM_WNLIST ) ) {
        x[escape(YAIM_WNLIST_CFGFILE)] = nlist("config",YAIM_WNLIST, "perms","0644");
    };
    x;
};

# set the node types
variable NODE_TYPE_LIST ?= null;
"/software/components/yaim" = yaim_mapping(NODE_TYPE_LIST);

# set queue ACLs and VO views - if applicable
variable TORQUE_QUEUE_ACCESS ?= nlist();
variable VO_VIEW ?= list();
"/software/components/yaim" = yaim_set_queue_access(TORQUE_QUEUE_ACCESS);

variable QUEUE_SE_LIST ?= null;
"/software/components/yaim" = yaim_set_queue_close_se_list(QUEUE_SE_LIST);

# Yaim component setup
"/software/components/yaim/configure" = true;
"/software/components/yaim/dependencies/pre" =
	list("spma", "filecopy", "ssh", "autofs", "accounts", "dirperm");
