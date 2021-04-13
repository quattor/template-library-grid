unique template personality/ui_gsissh/config;

include 'components/chkconfig/config';
include 'components/filecopy/config';
include 'components/gsissh/config';
include 'components/symlink/config';

#base configuration

"/software/components/chkconfig/service/gsisshd/on" = "";
"/software/components/chkconfig/service/gsisshd/startstop" = true;
"/software/components/gsissh/server/port" = GSISSH_PORT;

# Change the GLOBUS SXXsshd file, that is read by ncm-gsissh, in order to
#   - use gsisshd name
#   - SOURCE the environment before starting the server

"/software/components/filecopy/services/{/opt/globus/sbin/SXXsshd}" = dict(
    "config", replace('/GSISSH_PORT/', to_string(GSISSH_PORT), file_contents('personality/ui_gsissh/SXXsshd.sh')),
    "owner", "root:root",
    "perms", "0744"
);

"/software/components/symlink/links" ?= list();
"/software/components/symlink/links" = append(SELF, dict(
    "name", "/etc/init.d/SXXsshd",
    "target", "/opt/globus/sbin/SXXsshd",
    "delete", true,
));
