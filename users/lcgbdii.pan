
unique template users/lcgbdii;

# FIXME: Does this account really need a shell and login access?

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/groups/lcgbdii" =
  nlist("gid", 996);

"/software/components/accounts/users/lcgbdii" = nlist(
  "uid", 996,
  "groups", push("lcgbdii"),
  "comment","LCG BDII user",
  "shell", "/bin/bash",
  "homeDir", "/home/lcgbdii"
);

