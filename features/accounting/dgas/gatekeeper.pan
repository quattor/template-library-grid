unique template features/accounting/dgas/gatekeeper;

#include requirements
include { 'components/dirperm/config' };
include { 'components/filecopy/config' };
include { 'components/sysconfig/config' };

# Define where DGAS accounting records will be stored
# The original patch suggests to put data file into /opt/edg/var,
#   but /var is much better.
variable GATEKEEPER_DGAS_DIR ?= "/var/glite/gatekeeper";

#
# middleware updates
#
include { if_exists('update/config') };

#First, change create some dirs and change file permissions.
# Add SETUID on dgas exe, and chown it to non-root

'/software/components/dirperm/paths'={
	dirparms=SELF;
	dirparms=push(
		nlist('path', GATEKEEPER_DGAS_DIR, 'owner', 'edguser:edguser', 'perm', '0755', 'type', 'd'),
		nlist('path', GATEKEEPER_DGAS_DIR + '/jobs', 'owner', 'edguser:edguser', 'perm', '0755', 'type', 'd'),
		nlist('path', '/usr/sbin/dgas-add-record', 'owner', 'edguser:edguser', 'perm', '4755', 'type', 'f'),
		);
	dirparms;
};

# Adding a post-dependency to dirperm : this will avoïd RPM updates from breaking the above rights,
#   which would then result in a silent failure of the accounting (which is very hard to debug !)
#test pour accounting
"/software/components/spma/dependencies/post" = list("dirperm");

#Then, we need to create a config file for DGAS
#This defines where DGAS will store accounting data :
variable CONTENTS= GATEKEEPER_DGAS_DIR + "\n" ;
'/software/components/filecopy/services' =
	npush( escape("/etc/sysconfig/dgas-add-record.conf"),
 		nlist('config',CONTENTS,'owner','root:root','perms', '0644') ,
 	);

#Add a required variable to globus configuration
#Since SYSCONFIG component is not exporting variables, and globus init is
#not doing the proper thing we have to use the epilogue

'/software/components/sysconfig/files/globus/epilogue' = {
	tmp = "export GATEKEEPER_DGAS_DIR='" + GATEKEEPER_DGAS_DIR + "'\n";
	if( is_defined(SELF) ) tmp=  tmp + SELF;
	tmp;
};

#Add the same variable to the grid environement, to see if this betters work with 3.1 lcg-ce
include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(
  GLITE_GRID_ENV_PROFILE, nlist(
    'GATEKEEPER_DGAS_DIR', GATEKEEPER_DGAS_DIR,
    )
  );

# Add a cron job to regularly cleanup things
#ncm-logrotate could be used, but it's apparently not installed
"/software/components/cron/entries" =
  push(nlist(
    "name","gatekeeper_dgas",
    "user","root",
    "frequency", "00 1 * * *",
    "command", '(echo "===" ; date ; echo "===" ; find ' + GATEKEEPER_DGAS_DIR + '/jobs/ -mtime +7 -ls -exec rm {} \; ) >> /var/log/cleanup-job-records.log 2>&1' ));

# define APEL accounting processor, and undefine the GKLogProcessor (which becomes obsolete)
include { 'features/accounting/apel/parser_pbs' };
"/software/components/apel/configFiles" = {
	conf=SELF;
	blah_cfg= nlist (
		'SubmitHost', CE_HOST,
		'BlahdLogPrefix', "grid-jobmap_",
		'BlahdLogDir', list(GATEKEEPER_DGAS_DIR),
		'searchSubDirs', "yes",
		'reprocess', "no",
		);
	#define the Blah log processor
	conf[escape(APEL_PARSER_CONFIG)]["BlahdLogProcessor"]=blah_cfg;
	#undefine the useless GKLogProcessor
	conf[escape(APEL_PARSER_CONFIG)]["GKLogProcessor"] = null;
	return(conf);
	};
