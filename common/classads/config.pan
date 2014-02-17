# Configure classads library

unique template common/classads/config;

# Add classads RPMs
include { 'common/classads/rpms/config' + RPMS_SUFFIX };

variable LDCONF_ARCH_DIR = if (PKG_ARCH_GLITE == 'x86_64') {
                             return('lib64');
                           } else {
                             return('lib');
                           };

variable CLASSADS_INSTALL_PATH ?= GLITE_LOCATION + '/' + LDCONF_ARCH_DIR + '/classads';

# ---------------------------------------------------------------------------- 
# ldconf
# ---------------------------------------------------------------------------- 
include { 'components/ldconf/config' };

"/software/components/ldconf/paths" = push(CLASSADS_INSTALL_PATH);
