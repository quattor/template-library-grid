unique template feature/torque2/client/service;

variable TORQUE_VERSION ?= if(OS_VERSION_PARAMS['major'] == 'sl5'){
				'2.5.9-1.cri';
			   }else{
				'2.5.9-1.cri.el6';
			   };

# Add RPMs
include { 'feature/torque2/client/rpms/config' };

# Configure Torque client
include { 'feature/torque2/client/config' };

# Force a service restart if specified.
# This is done by checking if a restart timestamp is defined. In fact this can
# be an arbirtrary number and a restart is done if it is changed. It is recommended
# to use a timestamp for better tracking, something like 20060724-12:50.
include { 'components/filecopy/config' };
variable TORQUE_CLIENT_RESTART_FILE = "/var/quattor/restart/pbs_mom";
variable TORQUE_CLIENT_RESTART_CMD = "/sbin/service pbs_mom restart";
"/software/components/filecopy/services" =
{
  services = SELF;
  restart_time = undef;
  if ( exists(LRMS_CLIENT_RESTART[FULL_HOSTNAME]) &&
       is_defined(LRMS_CLIENT_RESTART[FULL_HOSTNAME]) ) {
    restart_time = LRMS_CLIENT_RESTART[FULL_HOSTNAME];
  };
  if ( !is_defined(restart_time) &&
       exists(LRMS_CLIENT_RESTART['DEFAULT']) &&
       is_defined(LRMS_CLIENT_RESTART['DEFAULT']) ) {
    restart_time = LRMS_CLIENT_RESTART['DEFAULT'];
  };
  if ( is_defined(restart_time) ) {
    services[escape(TORQUE_CLIENT_RESTART_FILE)] = nlist("config",restart_time,
                                                         "owner","root",
                                                         "perms","0644",
                                                         "restart",TORQUE_CLIENT_RESTART_CMD);
  };
  services;
};
