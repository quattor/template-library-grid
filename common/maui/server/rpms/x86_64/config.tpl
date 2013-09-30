unique template common/maui/server/rpms/x86_64/config;

include { 'components/spma/config' };

# Include MAUI client
include { 'common/maui/client/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' }; 

# Add server
#'/software/packages'=pkg_repl('maui-server','3.2.6p21-snap.1234905291.5.el5',PKG_ARCH_TORQUE_MAUI);
'/software/packages'=pkg_repl('maui-server',MAUI_VERSION_USED,PKG_ARCH_TORQUE_MAUI);
