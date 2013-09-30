# Configuration specific to DPM (head) node
unique template glite/se_dpm/server/service;

# Do DPM specific configuration
# Be sure to do it first as it may impact configuration of other components (e.g. GIP)
include { 'glite/se_dpm/server/config' };


# Configure and enable MySQL server
variable DPM_MYSQL_INCLUDE = if ( SEDPM_DB_TYPE == 'mysql' ) {
                               'common/mysql/server';
                             } else {
                               null;
                             };
include { DPM_MYSQL_INCLUDE };


# Configure resource BDII
include { 'glite/bdii/service' };


# Configure hostproxy for DPM dynamic GIP provider.
# Must be done before configuring the GIP provider.
include { 'glite/se_dpm/server/info_user_proxy' };


# Configure the information provider.
# Do it after configuring BDII to avoid creation of unneeded edginfo account
include { 'common/gip/se' };

