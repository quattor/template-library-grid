
unique template common/globus/sysconfig;

# Also define environment variables
include { 'common/globus/env' };


# ----------------------------------------------------------------------------
# sysconfig
# Manage /etc/sysconfig/globus with ncm-sysconfig to allow more flexible additions
# ----------------------------------------------------------------------------
include { 'components/sysconfig/config' };

"/software/components/sysconfig/files/globus/GLOBUS_LOCATION"       = GLOBUS_LOCATION;
"/software/components/sysconfig/files/globus/GLOBUS_CONFIG"         = "/etc/globus.conf";
"/software/components/sysconfig/files/globus/GLOBUS_TCP_PORT_RANGE" = if ( is_defined(GLOBUS_TCP_PORT_RANGE) ) {
                                                                        GLOBUS_TCP_PORT_RANGE;
                                                                      } else {
                                                                        return(null);
                                                                      };
"/software/components/sysconfig/files/globus/GLOBUS_UDP_PORT_RANGE" = if ( is_defined(GLOBUS_UDP_PORT_RANGE) ) {
                                                                        GLOBUS_UDP_PORT_RANGE;
                                                                      } else {
                                                                        return(null);
                                                                      };
"/software/components/sysconfig/files/globus/epilogue" = "export LANG=C";
