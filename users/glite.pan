
unique template users/glite;

variable GLITE_USER ?= 'glite';
variable GLITE_GROUP ?= 'glite';
variable GLITE_USER_HOME ?= '/home/glite';

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/" =  {
  SELF['groups'][GLITE_GROUP] = nlist("gid", 450);

  SELF['users'][GLITE_USER] = nlist(
                                    "uid", 450,
                                    "groups", list("glite"),
                                    "comment","gLite User",
                                    "shell", "/bin/bash",
                                    "createHome", true,
                                    "homeDir",  GLITE_USER_HOME,
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
'/system/glite/config/GLITE_USER' = GLITE_USER;
'/system/glite/config/GLITE_GROUP' = GLITE_GROUP;
