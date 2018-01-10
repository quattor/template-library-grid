unique template features/accounting/apel/base;

variable APEL_ENABLED ?= true;

variable APEL_DB_PWD_CACHE ?= '/etc/accounting.conf';

# APEL database and MySQL account
variable APEL_DB_INSPECT ?= true ;
variable APEL_DB_NAME ?= 'apelclient';
variable APEL_DB_USER ?= 'apel';
variable APEL_DB_PWD ?= if ( exists(APELDB_PWD) && is_defined(APELDB_PWD) ) {
                          APELDB_PWD;
                        } else {
                          error('APEL_DB_PWD must be explicitly defined');
                        };


# Cache password to access APEL DB in a file with restricted permissions.
# Used by other templates like apel_hostingcluster_fix and useful to
# write scripts requiring access to APEL DB.
# Useless on some nodes but the passwd is already cached in APEL XML
# config file...
"/software/components/filecopy/services" = {
  SELF[escape(APEL_DB_PWD_CACHE)] = nlist("config",APEL_DB_PWD,
                                          "owner","root",
                                          "perms","0400",
                                         );
  SELF;
};

# Set to true if the cluster has multicore resources available
variable APEL_MULTICORE_ENABLED ?= true;
