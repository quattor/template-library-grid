
unique template users/dpmmgr;

variable DPM_USER ?= 'dpmmgr';
variable DPM_GROUP ?= 'dpmmgr';

# -----------------------------------------------------------------------------
# accounts
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/" =  {
  SELF['groups'][DPM_GROUP] = nlist("gid", 970);

  SELF['users'][DPM_USER] = nlist(
                                    "uid", 90,
                                    "groups", list(DPM_GROUP),
                                    "comment","DPM Manager",
                                    "shell", "/bin/bash",
                                    "createHome", true,
                                    "homeDir", "/home/"+DPM_USER,
                                   );
  SELF;
};

