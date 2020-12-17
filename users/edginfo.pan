unique template users/edginfo;

include 'components/accounts/config';

include 'users/infosys';

"/software/components/accounts/groups/edginfo" = dict("gid", 1999);

"/software/components/accounts/users/edginfo" = dict(
    "uid", 999,
    "groups", list("edginfo", "infosys"),
    "comment", "EDG Info",
    "shell", "/bin/bash",
    "homeDir", "/home/edginfo",
);

