unique template update/22/rpms_epel_sl5_x86_64-fix;

#
# Obsolete packages
#
'/software/packages/{dpm-xrootd-debuginfo}' = null;

#
# ATLAS FAX N2N plug-in
#
'/software/packages' = pkg_ronly('xrootd-server-atlas-n2n-plugin', '2.0-1.el5', 'x86_64');

#
# dmlite-libs dependencies 
#
'/software/packages' = if ( exists(SELF[escape('dmlite-libs')]) ) {
    pkg_repl('boost141-regex', '1.41.0-5.el5', 'x86_64');
    pkg_repl('boost141-thread', '1.41.0-5.el5', 'x86_64');
} else {
    SELF;
};

#
# gfal2-all dependencies
#
'/software/packages' = if (exists(SELF[escape('gfal2-all')])) {
    pkg_repl('gfal2-plugin-http', '2.4.8-1.el5', 'x86_64');
    pkg_repl('davix-libs', '0.2.8-2.el5', 'x86_64');
} else {
    SELF;
};

#
# Torque update
#
include { 'common/torque2/update/rpms/config' };
