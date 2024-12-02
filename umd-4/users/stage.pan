
unique template users/stage;

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/groups/stage" =
  nlist("gid", 994);

"/software/components/accounts/users/stage" = nlist(
  "uid", 994,
  "groups", list("stage"),
  "comment","RFIO user",
  "createHome", false,
  "shell", "/bin/false",
  "homeDir", "/var/lib/stage"
);
