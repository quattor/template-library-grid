unique template common/torque2/munge/key_file;

include { 'components/filecopy/config' };

#just copy the key
"/software/components/filecopy/services" = {
        SELF[escape("/etc/munge/munge.key")]=
        nlist("config",file_contents(MUNGE_KEY_FILE),
              "perms", "0400",
             "owner", "munge",
              "group","munge",
              "restart","/etc/init.d/munge restart"
        );
	SELF;
       };






