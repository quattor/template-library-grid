# Base configuration of glitestartup configuration module for LB usage.
# Does not define the list of service to restart.

unique template features/lb/glitestartup;

include { 'components/glitestartup/config' };
'/software/components/glitestartup/configFile'='/etc/gLiteservices';
'/software/components/glitestartup/dependencies/pre' = glitestartup_add_dependency(list('accounts','dirperm','mysql','profile'));
'/software/components/glitestartup/restartEnv' = push(LB_PROFILE_SCRIPT);
"/software/components/glitestartup/scriptPaths" = list("/etc/init.d");
# FIXME : remove when glitestartup support defining a list of service to restart
'/software/components/glitestartup/restartServices' = true;

