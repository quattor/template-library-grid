unique template personality/wn/cleanup-tmpdir;

include 'components/cron/config';

variable CLEANUP_MAX_DAY ?= '+10';
variable CLEANUP_TMPDIR ?= {
    '/var/lib/condor/execute';
};

variable CLEANUP_PRINT ?= true;

variable CLEANUP_PRINT_STRING ?= if ( CLEANUP_PRINT ) {
    '-print';
} else {
    '';
};

variable CLEANUP_SCRIPT ?= format(
    'find %s -maxdepth 1 -mindepth 1 -type d -mtime %s %s -exec rm -rf {} \;',
    CLEANUP_TMPDIR,
    CLEANUP_MAX_DAY,
    CLEANUP_PRINT_STRING,
);

"/software/components/cron/entries" = push(dict(
    "name", "cleanup-tmpdir",
    "user", "root",
    "frequency", "1 0 * * *",
    "command", CLEANUP_SCRIPT,
));
