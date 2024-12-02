unique template personality/bdii/openldap-2.3.40-bugfix/config;

# This template fix issue describe on LCG-ROLLOUT
# https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=LCG-ROLLOUT;b17ebbe2.1510

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/etc/bdii/bdii-top-slapd.conf}';

'backup' = true;
'config' = file_contents('personality/bdii/openldap-2.3.40-bugfix/bdii-top-slapd.conf');
'perms'  = '0644';
'restart' = 'systemctl restart bdii';
'forceRestart' = true;