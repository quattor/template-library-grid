
unique template users/edginfo;

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

include { 'users/infosys' };

"/software/components/accounts/groups/edginfo" =
  nlist("gid", 999);

"/software/components/accounts/users/edginfo" = nlist(
  "uid", 999,
  "groups", list("edginfo","infosys"),
  "comment","EDG Info",
  "shell", "/bin/bash",
  "homeDir", "/home/edginfo"
);

