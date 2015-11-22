unique template personality/se_dpm/puppet/puppetconf;

include {'components/puppet/config'};

'/software/components/puppet/puppetconf/main/parser' = 'future';

include {'quattor/functions/strings'};

#Including the needed modules
variable DPM_PUPPET_MODULE_VERSION ?= "1.8.9";
"/software/components/puppet/modules/{sartiran-dpm}" = nlist("version",DPM_PUPPET_MODULE_VERSION);

variable DPMMGR_UID?=970;

"/software/components/puppet/hieradata" = {
	self=nlist();
	if(FULL_HOSTNAME==DPM_HOSTS['dpm'][0]){
		self["classes"] = 'dpm::headnode';
	}else{
		self["classes"] = 'dpm::disknode';
	};	
	self[escape("dpm::params::localdomain")] = SITE_DOMAIN;
	self[escape("dpm::params::headnode_fqdn")] = DPM_HOSTS['dpm'][0];

	self[escape("dpm::params::volist")] = VOS;

	if(comparever(DPM_PUPPET_MODULE_VERSION,'1.8.10')>0){
	  disk_list='';
	  foreach(i;disk;DPM_HOSTS['disk']){
	    if(disk_list==''){
	      disk_list=disk;
	    }else{
	      disk_list=disk_list+' '+disk;
	    };
	  };
        }else{
          disk_list=DPM_HOSTS['disk'];
	};

	self[escape("dpm::params::disk_nodes")] = disk_list;

	self[escape("dpm::params::dpmmgr_uid")] = DPMMGR_UID;
	self[escape("dpm::params::dpmmgr_gid")] = 970;

	self[escape("dpm::params::token_password")] = 'mytokenpassword';
	self[escape("dpm::params::xrootd_sharedkey")] = DPM_XROOTD_SHARED_KEY;
	self[escape("dpm::params::db_pass")] = DPM_DB_PARAMS['password'];

	self[escape("dpm::params::mysql_root_pass")] = DPM_DB_PARAMS['adminpwd'];
	self[escape("dpm::params::dpm_xrootd_fedredirs")] = XROOTD_FEDERATION_PARAMS;

	if(is_defined(XROOTD_REPORTING_OPTIONS)&&is_defined(XROOTD_MONITORING_OPTIONS)){
		self[escape("dpm::params::xrd_report")] = XROOTD_REPORTING_OPTIONS;
		self[escape("dpm::params::xrootd_monitor")] = XROOTD_MONITORING_OPTIONS;
	};

	if(is_defined(XROOTD_SITE_NAME)){ 
		self[escape("dpm::params::site_name")] = XROOTD_SITE_NAME;
	};

	if(is_defined(HTTPS_ENABLED) && HTTPS_ENABLED){ 
		self[escape("dpm::params::webdav_enabled")] = true;
		if(is_defined(DPM_MEMCACHED_ENABLED) && DPM_MEMCACHED_ENABLED){
				self[escape("dpm::params::memcached_enabled")] = true;
		};
	};

	if(is_defined(GRIDFTP_REDIR_ENABLED) && GRIDFTP_REDIR_ENABLED){
		self[escape("dpm::params::gridftp_redirect")] = true;
	};

	if(is_defined(SPACE_REPORTING_ENABLED) && SPACE_REPORTING_ENABLED){
		self[escape("dpm::params::enable_space_reporting")] = true;
	};

	self;
};




