# Add a script for updating CREAM DB

template personality/cream_ce/upgrade_db;

include {'users/tomcat' };

variable CREAM_MYSQL_SERVER ?= error('Invalid CREAM CE configuration: CREAM_MYSQL_SERVER undefined');

variable CREAM_DB_UPDATE_FILE ?= "/root/sbin/cream_db_update.sh";
variable CREAM_DB_UPDATE_CONTENTS = {
  contents = "#!/bin/sh\n\n";
  contents = "PATH=/sbin:/bin:/usr/sbin:/usr/bin\n\n";
  contents = contents + "/sbin/service "+TOMCAT_SERVICE+" stop\n\n";
  contents = contents + 'mysql --host="' + CREAM_MYSQL_SERVER + '" --user="' + CREAM_DB_USER + '" --password="' + CREAM_DB_PASSWORD + '" < ' + CREAM_DB_INIT_SCRIPT + "\n";
  contents = contents + 'mysql --host="' + CREAM_MYSQL_SERVER + '" --user="' + CREAM_DB_USER + '" --password="' + CREAM_DB_PASSWORD + '" < ' + DLG_DB_INIT_SCRIPT + "\n\n";
  contents = contents + "/sbin/service "+TOMCAT_SERVICE+" start\n";

  contents
};

"/software/components/filecopy/services" =
  npush(escape(CREAM_DB_UPDATE_FILE),
        nlist("config",CREAM_DB_UPDATE_CONTENTS,
              "owner","root:root",
              "perms","0750",
       )
  );


