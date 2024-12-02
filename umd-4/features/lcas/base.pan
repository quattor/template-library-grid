unique template features/lcas/base;

# Variables to tweak module configurations.
# Content of the following variables is added to the relevant module configuration.
# User DNs can be specified unquoted.
# Define a dummy entry as an example: will never match.
variable LCAS_BANNED_USERS ?= list('/O=GetRID/O=abusers/CN=Endless Job');
variable LCAS_TIMESLOT_ENTRIES ?= list('* * * * * *');
# Module lcas_userallow is disabled by default as it doesn't bring any real
# value: it just checks a user is in the grid-mapfile. Adding this constraint
# may lead to failure when a user is added in VOMS but the grid-mapfile has not been
# updated yet. On the other hand, a user without a VOMS proxy whose DN is not in the
# grid-mapfile will be rejected by LCMAPS.
variable LCAS_USER_ALLOW_ENABLE ?= false;

variable LCAS_CONFIG_DIR ?= GLITE_LOCATION_ETC + '/lcas';
variable LCAS_LIB_DIR ?= if ( PKG_ARCH_GLITE == 'x86_64' ) {
                           GLITE_LOCATION + '/lib64';
                         } else {
                           GLITE_LOCATION + '/lib';
                         };

# Define default logging level to be minimal
variable LCAS_DEBUG_LEVEL ?= 0;
variable LCAS_LOG_LEVEL ?= 1;

# Script sourced by gLite services to define environment
variable GLITE_GRID_ENV_PROFILE ?= '/etc/profile.d/grid-env.sh';

# Include LCAS RPMs
include { 'features/lcas/rpms' };


# ----------------------------------------------------------------------------
# First, build LCAS configuration in variables
# ----------------------------------------------------------------------------

# LCAS paths
variable LCAS_DB_FILE ?= LCAS_CONFIG_DIR+"/lcas.db";
variable LCAS_MODULE_PATH ?= LCAS_LIB_DIR+"/lcas";

# Module definitions.
# Module order has no impact on LCAS decisions: use a nlist for easy tweaking of module parameters in
# other templates.
variable LCAS_MODULES ?= {
  # Banned users.  Ensure DNs are double-quoted.
  SELF['userban'] = nlist();
  SELF['userban']['path'] = LCAS_MODULE_PATH+"/lcas_userban.mod";
  SELF['userban']['args'] = "ban_users.db";
  banned_users = list();
  foreach(i;user;LCAS_BANNED_USERS) {
    if ( match(user,'^\s*".*"\s*') ) {
      banned_users[length(banned_users)] = user;
    } else {
      banned_users[length(banned_users)] = '"' + user + '"';
    };
  };
  SELF['userban']['conf'] = nlist("path", LCAS_CONFIG_DIR+"/ban_users.db",
                                  "content", banned_users,
                                 );

  # Defined time slots.
  SELF['timeslots'] = nlist();
  SELF['timeslots']['path'] = LCAS_MODULE_PATH+"/lcas_timeslots.mod";
  SELF['timeslots']['args'] = "timeslots.db";
  SELF['timeslots']['conf'] = nlist("path", LCAS_CONFIG_DIR+"/timeslots.db",
                                    "content", LCAS_TIMESLOT_ENTRIES,
                                 );

  # VOMS users
  SELF['voms'] = nlist();
  SELF['voms']['path'] = LCAS_MODULE_PATH+"/lcas_voms.mod";
  SELF['voms']['args'] = '"-vomsdir /etc/grid-security/vomsdir -certdir ' + SITE_DEF_CERTDIR +
                               ' -authfile ' + SITE_DEF_GRIDMAP + ' -authformat simple -use_user_dn"';

  # Allowed users.
  # lcas_userallow ignores its argument and always uses grid-mapfile as its input file: argument defined
  # for sake of clarity.
  if ( LCAS_USER_ALLOW_ENABLE ) {
    SELF['userallow'] = nlist();
    SELF['userallow']['path'] = LCAS_MODULE_PATH+"/lcas_userallow.mod";
    SELF['userallow']['args'] = SITE_DEF_GRIDMAP;
  };

  SELF;
};


# ----------------------------------------------------------------------------
# Add LCAS configuration to ncm-lcas configuration, taking care that
# several LCAS configuration can coexist on one node.
# ----------------------------------------------------------------------------
include { 'components/lcas/config' };
'/software/components/lcas/db' = {
  if ( is_list(SELF) ) {
    config_len = length(SELF);
  } else {
    config_len = 0;
  };
  SELF[config_len] = nlist();
  SELF[config_len]['path'] = LCAS_DB_FILE;
  SELF[config_len]['module'] = list();
  foreach (plugin;params;LCAS_MODULES) {
    SELF[config_len]['module'][length(SELF[config_len]['module'])] = params;
  };
  debug('LCAS databases: '+to_string(SELF));
  SELF;
};

# ----------------------------------------------------------------------------
# Define LCAS debug and logging level (default is very verbose)
# ----------------------------------------------------------------------------
include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE,
                                                           nlist('LCAS_DEBUG_LEVEL', to_string(LCAS_DEBUG_LEVEL),
                                                                 'LCAS_LOG_LEVEL', to_string(LCAS_LOG_LEVEL),
                                                               )
                                                          );
