
unique template users/glexec;

variable GLEXEC_USER ?= 'glexec';
variable GLEXEC_GROUP ?= 'glexec';
variable GLEXEC_HOME ?= '/home/glexec';

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/" =  {
  SELF['groups'][GLEXEC_GROUP] = nlist("gid", 46002);

  SELF['users'][GLEXEC_USER] = nlist(
                                    "uid", 55311,
                                    "groups", list("glexec"),
                                    "comment","glexec User",
                                    "shell", "/sbin/nologin",
                                    "createHome", true,
                                    "homeDir", GLEXEC_HOME
                                   );
  SELF;
};

# -----------------------------------------------------------------------------
# Ensure filecopy runs after the account has been created
# -----------------------------------------------------------------------------
include { 'components/filecopy/config' };
"/software/components/filecopy/dependencies/pre" = push("accounts");

# -----------------------------------------------------------------------------
# Register glexec user/group in information tree
# -----------------------------------------------------------------------------
#'/system/glite/config/GLEXEC_USER' = GLEXEC_USER;
#'/system/glite/config/GLEXEC_GROUP' = GLEXEC_GROUP;
