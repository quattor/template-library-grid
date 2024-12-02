# Minimal EDG sysconfig for lcg-tags (gridftp server side)  and edg-mkgridmap to run successfully

unique template features/edg/sysconfig;

variable DEBUG = debug(FULL_HOSTNAME + ": defining EDG sysconfig");

# ----------------------------------------------------------------------------
# sysconfig
# ----------------------------------------------------------------------------
include 'components/sysconfig/config';

'/software/components/sysconfig/files/edg/EDG_LOCATION_VAR' = '/var/glite/';
