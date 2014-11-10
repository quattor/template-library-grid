unique template personality/se_dpm/puppet/bdii;

variable SE_HOSTS={
        SELF[FULL_HOSTNAME]=nlist('type','SE_dpm');
        SELF;
};

variable BDII_TYPE='resource';

variable GSIFTP_ENABLED ?= true;
variable RFIO_ENABLED ?= true;
variable SRMV2_ENABLED ?= true;
variable XROOTD_ENABLED ?= true;


include {'personality/bdii/service'};
include {'personality/se_dpm/puppet/info_user_proxy'};
include {'features/gip/se'};



