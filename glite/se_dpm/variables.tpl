unique template glite/se_dpm/variables;

##################################################
# Define DPM version based on RPM default naming #
##################################################
variable DPM_MAJOR_VERSION ?=  '1.8.3.1';
variable DPM_RELEASE_VERSION ?=  if (OS_VERSION_PARAMS['major'] == 'sl5'){'2.el5'}else{'2.el6'};
variable DPM_VERSION ?= DPM_MAJOR_VERSION+'-'+DPM_RELEASE_VERSION;

variable DPM_DEVEL_VERSION        ?= DPM_VERSION;
variable DPM_LIBS_VERSION         ?= DPM_VERSION;
variable LCGDM_DEVEL_VERSION      ?= DPM_VERSION;
variable LCGDM_LIBS_VERSION       ?= DPM_VERSION;
variable DPM_PERL_VERSION         ?= DPM_VERSION;
variable DPM_PYTHON_VERSION       ?= DPM_VERSION;
variable DPM_RFIO_VERSION         ?= DPM_VERSION;
variable DPM_COPY_SERVER_VERSION  ?= DPM_VERSION;
variable DPM_NAME_SERVER_VERSION  ?= DPM_VERSION;
variable DPM_SERVER_MYSQL_VERSION ?= DPM_VERSION;
variable DPM_SRM_VERSION          ?= DPM_VERSION;
variable DPM_DSI_VERSION          ?= if (OS_VERSION_PARAMS['major'] == 'sl5'){'1.8.3-2.el5'}else{'1.8.3-2.el6'};
