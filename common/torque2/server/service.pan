# Template defining all the MW components required to use Torque/MAUI as LRMS

unique template common/torque2/server/service;

variable TORQUE_VERSION ?= if(OS_VERSION_PARAMS['major'] == 'sl5'){
                                '2.5.9-1.cri';
                           }else{
                                '2.5.9-1.cri.el6';
                           };

variable TORQUE_PBSWEBMON_ENABLED ?= false;

include { 'common/torque2/server/rpms/config' };

include { 'common/torque2/server/config' };

# This should eventually be split out to allow users to choose different
# schedulers.
include { 'common/maui/server/service' };
include { 'common/maui/client/service' };

# Configure pbswebmon (http://apps.sourceforge.net/trac/pbswebmon/wiki)
include { if ( TORQUE_PBSWEBMON_ENABLED ) 'common/torque2/server/pbswebmon/config' };
