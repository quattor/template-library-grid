# RPMs specific to MySQL VOMS version.
# Based on VOMS 3.1.4 official RPM list.

unique template glite/voms/rpms/i386/mysql;
 
'/software/packages' = pkg_repl('glite-VOMS_mysql', '3.1.4-0', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-mysql', '1.1.5-1.slc4', 'i386');

# MySQL
variable MYSQL_INCLUDE = if ( VOMS_DB_SERVER == FULL_HOSTNAME ) {
                           'rpms/mysql';
                         } else {
                           'rpms/mysql_client';
                         };
include { MYSQL_INCLUDE };


# OS errata and site specific updates
# Always reinclude updates
include { 'config/os/updates' };


