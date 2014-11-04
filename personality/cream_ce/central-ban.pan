unique template personality/cream_ce/central-ban;

# xml_grep is needed by script
'/software/packages/{perl-XML-Twig}' ?= nlist();

# script to retrieve information
variable CONTENTS = <<EOF;
#!/bin/sh
# Demonstrator script to convert a PAP policy into a banmapfile (on stdout) for
# use with LCAS and LCMAPS plugins.
# Adapted by Mischa Salle (msalle@nikhef.nl) from a curl one-liner from Vincent
# Brillault.
#
# Example:
#  policy_to_banmapfile.sh argus.testmachine central ngi
# where central and ngi are aliases for remote PAPs defined for the Argus-PAP
# running on argus.testmachine

# cert and keys
capath=/etc/grid-security/certificates
cert=/etc/grid-security/hostcert.pem
key=/etc/grid-security/hostkey.pem

# PAP port and SOAP endpoint
port=8150
endp='/pap/services/XACMLPolicyManagementService?wsdl'

# Check command line
if [ $# -lt 1 ];then
    echo "Usage: $0 <PAP hostname> [PAP alias [PAP alias] [...]]" >&2
    exit 1
fi
host=$1 ; shift
if [ -n "$1" ];then
    aliases=$@
else
    aliases=default
fi

# Temporary files will be based on program name
prog=$(basename $0 .sh)
template=${prog}_XXXXXX

# Error function
error()	{
    echo "$prog: $*" >&2
    exit 1
}

# Called when we receive an empty but non-error result
endstat()	{
    echo "$prog: $*" >&2
    exit 0
}

# Helper function to convert RFC2253 DNs into old-style OpenSSL syntax
# It splits on comma's, reverses the order and prefixes each part with a slash
convert_dn()	{
    # Only convert when it contains CN=
    if echo "$1"|grep -q "^/";then
	# Looks like an FQAN 
	echo "\"$1\""
    elif echo "$1"|grep -q "CN=";then
	# Looks like a DN
	echo -n "\""
	echo "$1"|tr , '\n'|tac|while read a;do echo -n "/$a"; done
	echo "\""
    else
	error "Illegal line in output results: \"$1\""
    fi
}

# echoes the postdata for given alias
get_postdata()	{
    alias=$1

    echo -n '<?xml version="1.0" encoding="UTF-8"?>'
    echo -n '<SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns0="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns2="http://services.pap.authz.glite.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
    echo -n '<SOAP-ENV:Header/>'
    echo -n "<ns1:Body><ns2:listPolicies><papAlias>$alias</papAlias></ns2:listPolicies></ns1:Body>"
    echo '</SOAP-ENV:Envelope>'
}

# Runs actual curl command to obtain XACML policy
run_curl()  {
    alias=$1

    if [ -z "$alias" ] ; then
	error "Internal error, $0 did not receive obligatory argument"
    fi

    # Run curl, insert HTTP return code as comment (such that xml_grep won't
    # mind) at the end.
    curl \
	-S -s \
	-w "\n<!-- http_code=%{http_code} -->" \
	--capath $capath \
	--cert $cert \
	--key $key \
	-H 'SOAPAction: ""' \
	-H "Content-Type: text/xml; charset=utf-8" \
	-X POST \
	-d "$(get_postdata $alias)" \
	"https://${host}:${port}${endp}"

    return $?
}

# Start of actual program

tmp1=$(mktemp $template) # output of curl
tmp2=$(mktemp $template) # output of xml_grep for deny rules
tmp3=$(mktemp $template) # output of overall loop, use file in case of failure

# Loop over aliases, unfortunately we cannot get the policies from all remote
# PAPs simultaneously so we need to query them separately. Since the different
# XACML outputs have different xml roots, we also do the xml parsing for each
# individually.
for alias in $aliases ; do
    # Dump XML
    run_curl $alias > $tmp1
    # Check curl did not fail and that we got a HTTP 200 code 
    if [ $? != 0 -o -z "$(grep 'http_code=200' $tmp1)" ] ;then
	rm $tmp1 $tmp2 $tmp3
	error "Cannot download XACML for $alias from $host"
    fi

    # Get the Deny rules
    xml_grep \
	--root 'xacml:Rule[@Effect="Deny"]' $tmp1 > $tmp2

    # Parse return value
    if [ $? -ne 0 ];then
	rm $tmp1 $tmp2 $tmp3
	error "xml_grep for Deny rules failed"
    fi

    # Add commentary line about the source
    echo "# PAP host: $host, alias: $alias"

    # Check we got Deny rules
    if [ -s "$tmp2" ];then
	# Look for subject-id and fqans
	xml_grep \
	    --root 'xacml:SubjectMatch' \
	    --cond '[@AttributeId="http://glite.org/xacml/attribute/fqan"]' \
	    --cond '[@AttributeId="urn:oasis:names:tc:xacml:1.0:subject:subject-id"]' \
	    --pretty_print indented \
	    --text_only \
	    $tmp2 |\
	    while read line;do
		# convert RFC2253 format into OpenSSL format
		convert_dn "$line"
	    done
    fi
done > $tmp3

# Dump the output
cat $tmp3

# Tidy up
rm $tmp1 $tmp2 $tmp3
EOF

include { 'components/filecopy/config' };

prefix '/software/components/filecopy/services/{/usr/sbin/central-ban.sh}';
'config'=CONTENTS;
'owner'='root';
'perms'='0755';

# crontab to generate file every 4 hours
include { 'components/cron/config' };

variable ARGUS_CENTRAL_BANNING ?= error('ARGUS_CENTRAL_BANNING should refere to argus server');

prefix '/software/components/cron';

'entries' = {
  SELF[length(SELF)] = nlist(
      'command', format("/usr/sbin/central-ban.sh %s default ngi > /etc/lcas/ban_users.db",ARGUS_CENTRAL_BANNING),
      'frequency', '0 */4 * * *',
      'name', 'central-ban',
      'user', 'root',
    );
  SELF;
};
