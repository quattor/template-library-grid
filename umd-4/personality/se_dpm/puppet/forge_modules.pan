unique template personality/se_dpm/puppet/forge_modules;

include 'components/puppet/config';

variable DPM_PUPPET_MODULE_VERSION ?= '0.5.8';
variable DPM_PUPPET_MODULE ?= 'lcgdm-dpm';

'/software/components/puppet/modules' ?= dict();

'/software/components/puppet/modules' = {
    if(!DPM_PUPPET_RELEASE_MODULES && (DPM_PUPPET_MODULE != 'NONE')){
        SELF[escape(DPM_PUPPET_MODULE)] = dict('version', DPM_PUPPET_MODULE_VERSION);
    };
    SELF;
};
