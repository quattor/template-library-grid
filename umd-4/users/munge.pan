unique template users/munge;

variable MUNGE_USER ?= 451;
variable MUNGE_GROUP ?= MUNGE_USER;

"/software/components/accounts/groups/munge" =
  nlist(
        "gid", MUNGE_GROUP,
       );

"/software/components/accounts/users/munge" =
  nlist(
        "uid", MUNGE_USER,
        "groups", list("munge"),
        "comment","Munge account",
        "createHome", true,
        "homeDir", "/var/run/munge",
        "shell","/sbin/nologin",
       );


