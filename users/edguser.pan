
unique template users/edguser;

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

include { 'users/infosys' };

"/software/components/accounts/groups/edguser" = 
  nlist("gid", 995);

"/software/components/accounts/users/edguser" = nlist(
  "uid", 995,
  "groups", list("edguser","infosys"),
  "comment","EDG User",
  "shell", "/bin/bash",
  "homeDir", "/home/edguser"
);

