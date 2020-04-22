unique template features/accounting/apel/hostingcluster_fix;

include { 'features/accounting/apel/base' };

#need to know the MONBOX HOST
variable MON_HOST ?= error("Error : in order to fix the MON Box database, we need to know what is the host hosting this database...\n"
	+ "Please define the following variable : 'MON_HOST'\n");

include { 'components/filecopy/config' };

#copy a script that will query the information system, and update the accounting database
variable CONTENTS=<<EOF;
#!/bin/bash

TMP_FILE=`mktemp`
verbose=0

if [ "$1" = "--debug" ]
then
  MYQSL_DEBUG="-vvv"
  verbose=1
fi

EOF

# Add LDAP command with site-specific information
variable CONTENTS = CONTENTS + "ldapsearch -x -h " + TOP_BDII_HOST + ":2170 -LLL -b mds-vo-name=" + SITE_NAME +
                         ",mds-vo-name=local,o=grid '(objectClass=GlueCE)' GlueCEInfoHostName GlueCEHostingCluster 2>/dev/null > $TMP_FILE\n";

variable CONTENTS = CONTENTS + <<EOF;

[ $? -ne 0 ] && echo "Error: BDII query failed... exiting" && exit 0

HOSTED_CE_LIST=`egrep '(GlueCEInfoHostName|GlueCEHostingCluster):' $TMP_FILE | awk '{ if ($1 ~ /GlueCEInfoHostName/) {printf "%s ",$2} else {print $2} }' | awk '{if ($1 != $2 ) { print $1 ";" $2 }}' |sort |uniq`

for i in $HOSTED_CE_LIST; do
    CE=${i%%;*}
    hostingCE=${i/*;/}
    echo "Updating SpecRecords for CE $CE hosted on cluster $hostingCE..."
    SQL_QUERY="SET @oldCE:='$hostingCE' , @newCE:='$CE'; INSERT IGNORE INTO SpecRecords SELECT replace(S.SpecID,@oldCE ,@newCE) as SpecID,SiteName,replace(S.ClusterID,@oldCE,@newCE) as ClusterID,replace(S.SubClusterID,@oldCE,@newCE) as SubClusterID,S.SpecInt2000,S.SpecFloat2000,S.EndDate,S.EndTime,S.MeasurementDate,S.MeasurementTime FROM SpecRecords S where S.ClusterID = @oldCE ;"
    if [ $verbose -gt 0 ]
    then
      echo "   SQL QUERY is : $SQL_QUERY"
    fi
EOF

variable CONTENTS = CONTENTS + '    echo "$SQL_QUERY" | /usr/bin/mysql $MYSQL_DEBUG -u ' +
                      APEL_DB_USER + ' --password=`cat ' + APEL_DB_PWD_CACHE  + '` -h ' + MON_HOST + " " + APEL_DB_NAME + "\n" ;

variable CONTENTS = CONTENTS + <<EOF;
done

rm -f $TMP_FILE
echo "done."
exit 0
EOF


variable SCRIPT="/root/apel_hostingcluster_specrecords_fix.sh";
"/software/components/filecopy/services" =
  npush(escape(SCRIPT),
        nlist("config",CONTENTS,
              "owner","root",
              "perms","0755"));

#Create CRONTAB
include { 'components/cron/config' };
"/software/components/cron/entries" =
  push(nlist(
    "name","apel_hostingcluster_specrecords_fix",
    "user","root",
    "frequency", "5 0 * * *", #run right after midnight
    "command", SCRIPT));

include { 'components/altlogrotate/config' };
"/software/components/altlogrotate/entries/apel_hostingcluster_specrecords_fix" =
  nlist("pattern", "/var/log/apel_hostingcluster_specrecords_fix.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "size", '1M',
        "create", true,
        "ifempty", true,
        "copytruncate", true,
        "rotate", 10,
       );
