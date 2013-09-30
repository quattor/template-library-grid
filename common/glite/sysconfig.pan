
unique template common/glite/sysconfig;


include { 'common/glite/base' };

# ---------------------------------------------------------------------------- 
# sysconfig
# ---------------------------------------------------------------------------- 
include { 'components/sysconfig/config' };

'/software/components/sysconfig/files/glite/GLITE_LOCATION'             = GLITE_LOCATION;
'/software/components/sysconfig/files/glite/GLITE_LOCATION_LOG'         = GLITE_LOCATION_LOG;
'/software/components/sysconfig/files/glite/GLITE_LOCATION_TMP'         = GLITE_LOCATION_TMP;
'/software/components/sysconfig/files/glite/GLITE_LOCATION_VAR'         = GLITE_LOCATION_VAR;
'/software/components/sysconfig/files/glite/GRIDMAP'                  = SITE_DEF_GRIDMAP;
'/software/components/sysconfig/files/glite/GRIDMAPDIR'               = SITE_DEF_GRIDMAPDIR;

