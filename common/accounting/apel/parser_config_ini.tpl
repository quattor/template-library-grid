
unique template common/accounting/apel/parser_config_ini;

# ---------------------------------------------------------------------------- 
# Apel Configuration File
# ---------------------------------------------------------------------------- 

variable INSPECT_TABLES = if(APEL_DB_INSPECT) { "yes" } else { "no" } ;
variable APEL_CONFIG ?= '/etc/apel/parser.cfg';

variable APEL_CONFIG_CONTENTS ?= {
  contents = '[db]' + "\n";
  contents = contents + 'hostname = '+ MON_HOST + "\n";
  contents = contents + 'port = 3306' + "\n";
  contents = contents + 'name = ' + APEL_DB_NAME + "\n";
  contents = contents + 'username = ' + APEL_DB_USER + "\n";
  contents = contents + 'password = ' + APEL_DB_PWD + "\n";
  contents = contents + "\n";
  contents = contents + '[site_info]' + "\n";
  contents = contents + 'site_name = ' + SITE_NAME + "\n";
  contents = contents + 'lrms_server = ' + FULL_HOSTNAME + "\n";
  contents = contents + "\n";
  contents = contents + '[blah]' + "\n";
  contents = contents + 'enabled = true' + "\n";
  contents = contents + 'dir = ' + BLAH_LOG_DIR + "\n";
  contents = contents + 'filename_prefix = ' + BLAH_LOG_FILE + "\n";
  contents = contents + 'subdirs = false' + "\n";
  contents = contents + "\n";
  contents = contents + '[batch]' + "\n";
  contents = contents + 'enabled = true' + "\n";
  contents = contents + 'reparse = false' + "\n";
  contents = contents + 'type = PBS' + "\n";
  contents = contents + 'parallel = false' + "\n";
  contents = contents + 'dir = ' + TORQUE_CONFIG_DIR + '/server_priv/accounting' + "\n";
  contents = contents + 'filename_prefix =' + "\n";
  contents = contents + 'subdirs = false' + "\n";
  contents = contents + "\n";
  contents = contents + '[logging]' + "\n";
  contents = contents + 'logfile = /var/log/apelparser.log' + "\n";
  contents = contents + 'level = INFO' + "\n";
  contents = contents + 'console = true' + "\n";

  contents;
};

"/software/components/filecopy/services" =
  npush(escape(APEL_CONFIG),
        nlist("config",APEL_CONFIG_CONTENTS,
              "owner","root",
              "perms","0600",
        )
  );


