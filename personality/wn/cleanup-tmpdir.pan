unique template personality/wn/cleanup-tmpdir;

include { 'components/cron/config' };

variable CLEANUP_MAX_DAY ?= '+10';
variable CLEANUP_TMPDIR ?= {
  if (is_defined(TORQUE_TMPDIR)) {
    TORQUE_TMPDIR;
  } else {
    '/var/lib/condor/execute';
  };
};

variable CLEANUP_PRINT ?= true;

variable CLEANUP_PRINT_STRING ?= if ( CLEANUP_PRINT ) {
    '-print';
} else {
    '';
};

variable CLEANUP_SCRIPT ?= 'find '+CLEANUP_TMPDIR+' -maxdepth 1 -mindepth 1 -type d -mtime '+CLEANUP_MAX_DAY+' '+CLEANUP_PRINT_STRING+' -exec rm -rf {} \;';

"/software/components/cron/entries" = push(nlist(
    "name","cleanup-tmpdir",
    "user","root",
    "frequency", "1 0 * * *",
    "command", CLEANUP_SCRIPT,
));
