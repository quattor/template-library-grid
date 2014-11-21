# 
# getting X509_USER_PROXY from the SUDO_COMMAD variable is a temporary solution as
# condor_submit.sh (which calls this script), has a x509userproxy variable defined but not exported.
# should ask to the developers of glite-ce-blaph to export the variable inside condor_submit.sh
#
export X509_USER_PROXY=$(echo $SUDO_COMMAND|grep -P -o '\-x \S+'|grep -P -o '\/\S+')

#Getting informations about the user identity
FQAN=$(voms-proxy-info --fqan|head -1);
SUBJECT=$(voms-proxy-info --acsubject);
VO_NAME=$(voms-proxy-info --vo|tr '.' '_');

IdentityString='('$VO_NAME','$FQAN','$SUBJECT')'

#Map the user identity to an accounting group
AcctGroup=$(/usr/libexec/matching_regexps "$IdentityString" /etc/condor/groups_mapping.xml group 2>/dev/null)

echo 'accounting_group='$AcctGroup

echo 'accounting_group_user='$(whoami)


