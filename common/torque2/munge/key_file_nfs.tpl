unique template common/torque2/munge/key_file_nfs;

#
#Configuring mountpoint for exporting the Munge key
#

variable NFS_MOUNT_POINTS ?= nlist();

variable NFS_MOUNT_POINTS ={
	if(is_defined(TORQUE_SERVER_HOST) && (TORQUE_SERVER_HOST != FULL_HOSTNAME)){
        SELF['mountedFS'][escape('/etc/munge')] =  nlist('nfsPath',TORQUE_SERVER_HOST+':/etc/munge',
                                                    'nfsVersion', NFS_DEFAULT_VERSION);
	
	}else{
	SELF['servedFS'][escape('/etc/munge')] = nlist('localPath','/etc/munge','nfsVersion',NFS_DEFAULT_VERSION);	
	};
        SELF;
};

variable NFS_SERVER_ENABLED = if ( !is_defined(TORQUE_SERVER_HOST) || (TORQUE_SERVER_HOST == FULL_HOSTNAME) ) {
                                true
                              } else {
                                false
                              };


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


