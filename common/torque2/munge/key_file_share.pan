unique template common/torque2/munge/key_file_share;

#
# Sharing key is done outside and not by nfs , only checking and key generation is done here 
#

include { 'components/filecopy/config' };

variable MUNGE_KEY_GENERATOR_CONTENT = <<EOF;
        #! /bin/bash
        if [ -s /etc/munge/munge.key ]
        then
           exit 0;
        else
	   rm -f /etc/munge/munge.key
           create-munge-key;
           /etc/init.d/munge restart;
        fi
        exit 0;
EOF


#prepare the key on the server side
"/software/components/filecopy/services" = {
	if((!is_defined(TORQUE_SERVER_HOST))||(TORQUE_SERVER_HOST==FULL_HOSTNAME))
	{
        SELF[escape("/etc/munge/generate_key")]=
        nlist("config",MUNGE_KEY_GENERATOR_CONTENT,
              "perms", "0700",
             "owner", "root",
              "group","root",
              "restart","/etc/munge/generate_key"
        );
	};
	SELF;
       };


