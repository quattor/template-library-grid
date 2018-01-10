
unique template users/rgma;

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

include { 'users/infosys' };

"/software/components/accounts/groups/rgma" =
  nlist("gid", 993);

"/software/components/accounts/users/rgma" = nlist(
  "uid", 993,
  "groups", list("rgma","infosys"),
  "comment","RGMA user",
  "shell", "/bin/bash",
  "createHome", false,
  "homeDir", GLITE_LOCATION+"/etc/rgma"
);

