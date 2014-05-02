
unique template feature/globus/env;

# Default port ranges
# SITE_GLOBUS_xxx_RANGE is kept for backward compatibility.
variable GLOBUS_TCP_PORT_RANGE_MIN ?= undef;
variable GLOBUS_TCP_PORT_RANGE_MAX ?= undef;
variable GLOBUS_UDP_PORT_RANGE_MIN ?= undef;
variable GLOBUS_UDP_PORT_RANGE_MAX ?= undef;
variable GLOBUS_TCP_PORT_RANGE ?= if ( is_defined(SITE_GLOBUS_TCP_RANGE) ) {
                                    SITE_GLOBUS_TCP_RANGE;
                                  } else if ( is_defined(GLOBUS_TCP_PORT_RANGE_MIN) &&
                                             is_defined(GLOBUS_TCP_PORT_RANGE_MAX)) {
                                    if ( GLOBUS_TCP_PORT_RANGE_MIN > GLOBUS_TCP_PORT_RANGE_MAX ) {
                                      error('GLOBUS_TCP_PORT_RANGE_MIN ('+GLOBUS_TCP_PORT_RANGE_MIN+') greater than GLOBUS_TCP_PORT_RANGE_MAX ('+GLOBUS_TCP_PORT_RANGE_MAX+')');
                                    };
                                    GLOBUS_TCP_PORT_RANGE_MIN+','+GLOBUS_TCP_PORT_RANGE_MAX;
                                  } else {
                                    undef;
                                  };
variable GLOBUS_UDP_PORT_RANGE ?= if ( is_defined(SITE_GLOBUS_UDP_RANGE) ) {
                                    SITE_GLOBUS_UDP_RANGE;
                                  } else if ( is_defined(GLOBUS_UDP_PORT_RANGE_MIN) &&
                                             is_defined(GLOBUS_UDP_PORT_RANGE_MAX)) {
                                    if ( GLOBUS_UDP_PORT_RANGE_MIN > GLOBUS_UDP_PORT_RANGE_MAX ) {
                                      error('GLOBUS_UDP_PORT_RANGE_MIN ('+GLOBUS_UDP_PORT_RANGE_MIN+') greater than GLOBUS_UDP_PORT_RANGE_MAX ('+GLOBUS_UDP_PORT_RANGE_MAX+')');
                                    };
                                    GLOBUS_UDP_PORT_RANGE_MIN+','+GLOBUS_UDP_PORT_RANGE_MAX;
                                  } else {
                                    undef;
                                  };


# ---------------------------------------------------------------------------- 
# profile
# Coming from former edg-profile and edg-gpt-profile + /opt/globus/etc/globus-user-env.sh
# FIXME: source /opt/globus/etc/globus-user-env.sh when ncm-profile supports 
#        sourcing other scripts.
# ---------------------------------------------------------------------------- 
include { 'components/profile/config' };

'/software/components/profile/env/GLOBUS_LOCATION'          = GLOBUS_LOCATION;
'/software/components/profile/env/GLOBUS_PATH'              = GLOBUS_LOCATION;

"/software/components/profile/env/GLOBUS_TCP_PORT_RANGE" = if ( is_defined(GLOBUS_TCP_PORT_RANGE) ) {
                                                             GLOBUS_TCP_PORT_RANGE;
                                                           } else {
                                                             return(null);
                                                           };
"/software/components/profile/env/GLOBUS_UDP_PORT_RANGE" = if ( is_defined(GLOBUS_UDP_PORT_RANGE) ) {
                                                             GLOBUS_UDP_PORT_RANGE;
                                                           } else {
                                                              return(null);
                                                           };
                                                                      
"/software/components/profile/path/PATH/prepend" = push(GLOBUS_LOCATION+'/sbin',
                                                        GLOBUS_LOCATION+'/bin',
                                                       );
"/software/components/profile/path/LD_LIBRARY_PATH/prepend" = push(GLOBUS_LOCATION+'/lib');
"/software/components/profile/path/SASL_PATH/prepend" = push(GLOBUS_LOCATION+'/lib/sasl');
"/software/components/profile/path/MANPATH/prepend" = push(GLOBUS_LOCATION+'/man');

