unique template common/maui/client/rpms/x86_64/config;

include { 'components/spma/config' };

'/software/packages'=pkg_repl('maui',MAUI_VERSION_USED,PKG_ARCH_TORQUE_MAUI);
'/software/packages'=pkg_repl('maui-client',MAUI_VERSION_USED,PKG_ARCH_TORQUE_MAUI);
