
unique template users/tomcat;

variable TOMCAT_USER ?= 'tomcat';
variable TOMCAT_GROUP ?= 'tomcat';
variable TOMCAT_HOME ?= '/usr/share/tomcat5';

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/" = {
  SELF['groups'][TOMCAT_GROUP] = nlist("gid", 91);

  SELF['users'][TOMCAT_USER] = nlist(
                                    "uid", 91,
                                    "groups", list(TOMCAT_GROUP),
                                    "comment","Apache Tomcat",
                                    "shell", "/bin/sh",
                                    "createHome", false,
                                    "homeDir", TOMCAT_HOME
                                   );
  SELF;
};

# -----------------------------------------------------------------------------
# Ensure filecopy runs after the account has been created
# -----------------------------------------------------------------------------
include { 'components/filecopy/config' };
"/software/components/filecopy/dependencies/pre" = push("accounts");

# -----------------------------------------------------------------------------
# Register gLite user/group in information tree
# -----------------------------------------------------------------------------
#'/system/glite/config/TOMCAT_USER' = TOMCAT_USER;
#'/system/glite/config/TOMCAT_GROUP' = TOMCAT_GROUP;
