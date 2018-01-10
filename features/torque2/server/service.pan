# Template defining all the MW components required to use Torque/MAUI as LRMS

unique template features/torque2/server/service;

variable TORQUE_VERSION ?= if(OS_VERSION_PARAMS['major'] == 'sl5'){
                                '2.5.9-1.cri';
                           }else{
                                '2.5.9-1.cri.el6';
                           };

variable TORQUE_PBSWEBMON_ENABLED ?= false;

include { 'features/torque2/server/config' };

# This should eventually be split out to allow users to choose different
# schedulers.
include { 'features/maui/server/service' };
include { 'features/maui/client/service' };

# Configure pbswebmon (http://apps.sourceforge.net/trac/pbswebmon/wiki)
include { if ( TORQUE_PBSWEBMON_ENABLED ) 'features/torque2/server/pbswebmon/config' };
