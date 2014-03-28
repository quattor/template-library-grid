unique template personality/lb/messaging;

include { 'components/filecopy/config' };

'/software/components/filecopy/services/{/etc/glite-lb/msg.conf}' =
 nlist('config', format(file_contents('personality/lb/msg.conf'),
                        EMI_LB_MESSAGING_SERVER,
                       ),
       'perms', '0644'
);
