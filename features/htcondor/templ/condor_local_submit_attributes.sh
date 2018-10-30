#
# getting X509_USER_PROXY from the SUDO_COMMAD variable is a temporary solution as
# condor_submit.sh (which calls this script), has a x509userproxy variable defined but not exported.
# should ask to the developers of glite-ce-blaph to export the variable inside condor_submit.sh
#
export X509_USER_PROXY=$(echo $SUDO_COMMAND|grep -P -o '\-x \S+'|grep -P -o '\/\S+')

#Getting the queue
QUEUE=$(echo $SUDO_COMMAND|grep -P -o '\-q \S+'|grep -P -o '[a-z]\S+')

#Getting informations about the user identity
FQAN=$(voms-proxy-info --fqan|head -1);
SUBJECT=$(voms-proxy-info --acsubject);
VO_NAME=$(voms-proxy-info --vo);
VO_NAME_FORMATTED=$(echo $VO_NAME|tr '.-' '_');

IdentityString='('$VO_NAME_FORMATTED','$FQAN','$SUBJECT','$QUEUE')'

#Map the user identity to an accounting group
AcctGroup=$(/usr/libexec/matching_regexps "$IdentityString" /etc/condor/groups_mapping.xml group 2>/dev/null)
PolicyGroup=$(/usr/libexec/matching_regexps "$IdentityString" /etc/condor/groups_mapping.xml policy 2>/dev/null)
WNTag=$(/usr/libexec/matching_regexps "$IdentityString" /etc/condor/groups_mapping.xml tag 2>/dev/null)
Concurrenclimits=$(/usr/libexec/matching_regexps "$IdentityString" /etc/condor/groups_mapping.xml limit 2>/dev/null)


echo 'accounting_group='$AcctGroup

echo 'accounting_group_user='$(whoami)

if [[ "xConcurrenclimits" != "xNONE" ]];
then
    echo 'concurrency_limits_expr='$Concurrenclimits
fi

echo '+CreamQueue="'$QUEUE'"'

echo '+PolicyGroup="'$PolicyGroup'"'

echo '+WNTag="'$WNTag'"'

echo '+MyVOName="'$VO_NAME'"'

echo '+MyProxySubject="'$SUBJECT'"'

echo '+MyFQAN="'$FQAN'"'

# LHCb need to have $HOME defined
echo "getenv = true"