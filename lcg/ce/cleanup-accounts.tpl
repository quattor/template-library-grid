# Configure cron job to clean up home directories

template lcg/ce/cleanup-accounts;


# Age in days for files in home directories to be cleaned up
variable CE_CLEANUP_ACCOUNTS_IDLE ?= 15;
variable CE_CLEANUP_ACCOUNTS_DAYS ?= "Sun,Wed";    # In cron format
variable CE_CLEANUP_ACCOUNTS_LOCAL_ONLY ?= false;
variable CE_CLEANUP_ACCOUNTS_USE_GRIDMAPDIR ?= true;
variable CE_CLEANUP_ACCOUNTS_SITE_OPTIONS ?= '';        # Use to specify other options

# Set options according to previous variables
variable CE_CLEANUP_ACCOUNTS_BASE_OPTIONS = {
  options = '';
  if ( ! CE_CLEANUP_ACCOUNTS_LOCAL_ONLY ) {
    options = options + ' -F';
  };
  if ( CE_CLEANUP_ACCOUNTS_USE_GRIDMAPDIR ) {
    options = options + ' -d ' + SITE_DEF_GRIDMAPDIR;
  };
  options;
};

# Install cron to do pool accounts cleanup.
# This is done using option -F to force cleanup on non local directories
# as this cron job is not installed on other machine types (WNs, NFS servers...)
# because the script requires a gridmapdir to be present.
# In addition to pool accounts present in gridmapdir (all already used pool accounts), add
# explicitly accounts used to map specific groups and roles, except those for which home directory
# matches VO software area.

include { 'components/cron/config' };
include { 'components/altlogrotate/config' };
include { 'components/filecopy/config' };

variable CE_CLEANUP_ACCOUNTS_CONFIG_FILE = '/etc/cleanup-grid-accounts.conf';
variable CE_CLEANUP_ACCOUNTS_CONFIG = {
  non_pool_accounts = '';
  foreach (vo;vo_params;VO_INFO) {
    foreach (user;params;vo_params['accounts']['users']) {
      if ( (!exists(params['poolSize']) || !is_defined(params['poolSize']) || (params['poolSize'] == 0)) &&
           (!exists(vo_params['swarea']['paths']) || (length(vo_params['swarea']['paths']) == 0) ||
                                       !match(vo_params['swarea']['paths'][0]['path'],'^'+params['homeDir'])) ) {
        non_pool_accounts = non_pool_accounts + user + ' ';
      };
    };
  };
  "EXTRA='"+to_string(non_pool_accounts)+"'\n";
};

"/software/components/filecopy/services" = {
  SELF[escape(CE_CLEANUP_ACCOUNTS_CONFIG_FILE)] = nlist('config', CE_CLEANUP_ACCOUNTS_CONFIG,
                                                        'perms', '0755',
                                                        'owner', 'root:root',
                                                       );
  SELF;
};

"/software/components/cron/entries" =
  push(nlist(
    "name","cleanup-grid-accounts",
    "user","root",
    "frequency", "0 23 * * "+CE_CLEANUP_ACCOUNTS_DAYS,
    "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; "+
               "/usr/sbin/cleanup-grid-accounts.sh -v -c "+CE_CLEANUP_ACCOUNTS_CONFIG_FILE+' '+
               CE_CLEANUP_ACCOUNTS_BASE_OPTIONS+' '+CE_CLEANUP_ACCOUNTS_SITE_OPTIONS+
               ' -i '+to_string(CE_CLEANUP_ACCOUNTS_IDLE)
      ));


# Configure altrotate for LCG CE related log files

"/software/components/altlogrotate/entries/cleanup-grid-accounts" =
  nlist("pattern", "/var/log/cleanup-grid-accounts.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 1);
