unique template common/gsissh/server/rpms/config;

include { if_exists('common/gsissh/server/rpms/' + OS_VERSION_PARAMS['major']) };
