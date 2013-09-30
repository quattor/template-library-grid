unique template common/gsissh/client/rpms/config;

include { if_exists('common/gsissh/client/rpms/' + OS_VERSION_PARAMS['major']) };
