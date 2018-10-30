unique template features/accounting/apel/storage_accounting;

# Allow user to customize cron startup hour
# start after midnight so that torque logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '1';
variable APEL_SPOOL_DIR ?= '/var/spool/apel/outgoing';
variable APEL_STORAGE_PARSER_SCRIPT ?= '/usr/local/bin/star-accounting.py';
variable APEL_STORAGE_ACCOUNTING_SCRIPT ?= '/usr/local/bin/storage_accounting.sh';

'/software/packages/{apel-ssm}' = dict();

@documentation{
    Create a APEL-readable version of the host certificate
}
variable APEL_HOST_CERT_DIR ?= SITE_DEF_GRIDSEC_ROOT + '/apel';

include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    SELF[escape(APEL_HOST_CERT_DIR + '/hostkey.pem')] = dict(
        'source', SITE_DEF_HOST_KEY,
        'owner', 'root:root',
        'perms', '0400',
    );

    SELF[escape(APEL_HOST_CERT_DIR + '/hostcert.pem')] = dict(
        'source', SITE_DEF_HOST_CERT,
        'owner', 'root:root',
        'perms', '0644',
    );

    SELF;
};

@documentation{
    Create the accouting storage parser script
}
include 'components/filecopy/config';

@documentation{
    Create the storage accounting cron script
}

"/software/components/filecopy/services" = npush(
    escape(APEL_STORAGE_PARSER_SCRIPT), dict(
        "config", file_contents('features/accounting/apel/templ/star-accounting.py'),
        "owner", "root:root",
        "perms", "0755",
    ),
);

variable APEL_STORAGE_ACCOUNTING_CONTENTS ?= {
    contents = "#!/bin/bash\n";
    contents = contents + "mkdir -p " + APEL_SPOOL_DIR + "/`date +%Y%m%d`\n";
    contents = contents + APEL_STORAGE_PARSER_SCRIPT + " --reportgroups --dpmconfig=/etc/DPMCONFIG --site='";
    contents = contents + SITE_NAME + "' > " + APEL_SPOOL_DIR + "/`date +%Y%m%d`/`date +%Y%m%d%H%M%S`\n";
    contents = contents + "/usr/bin/ssmsend";

    contents;
};

"/software/components/filecopy/services" = npush(
    escape(APEL_STORAGE_ACCOUNTING_SCRIPT), dict(
        "config", APEL_STORAGE_ACCOUNTING_CONTENTS,
        "owner", "root:root",
        "perms", "0755",
    ),
);

@documentation{
    Create the cron entry that launch the storage accounting script
}
include 'components/cron/config';
'/software/components/cron/entries' = push(
    dict(
        'name', 'apel-storage-accounting',
        'user', 'root',
        'frequency', 'AUTO ' + APEL_PARSER_TIME_HOUR + ' * * *',
        'command', APEL_STORAGE_ACCOUNTING_SCRIPT,
        'log', dict('mode', '0644')
    )
);

include 'components/altlogrotate/config';
'/software/components/altlogrotate/entries/apel-storage-accounting' = dict(
    'pattern', '/var/log/apel-storage-accounting.ncm-cron.log',
    'compress', true,
    'missingok', true,
    'frequency', 'weekly',
    'create', true,
    'createparams', dict(
        'mode', '0644',
        'owner', 'root',
        'group', 'root',
    ),
    'ifempty', true,
    'rotate', 2,
);

@documentation{
    Create the APEL SSM configuration file
}
include 'components/metaconfig/config';
'/software/components/metaconfig/services/{/etc/apel/sender.cfg}' = dict(
    'mode', 0644,
    'owner', 'root',
    'group', 'root',
    'module', 'tiny',
    'contents', dict(
        'broker', dict(
            'bdii', 'ldap://lcg-bdii.cern.ch:2170',
            'network', 'PROD',
            'use_ssl', 'true'
        ),
        'certificates', dict(
            'certificate', APEL_HOST_CERT_DIR + '/hostcert.pem',
            'key', APEL_HOST_CERT_DIR + '/hostkey.pem',
            'capath', SITE_DEF_CERTDIR
        ),
        'messaging', dict(
            'destination', '/queue/global.accounting.storage.central',
            'path', '/var/spool/apel/outgoing'
        ),
        'logging', dict(
            'logfile', '/var/log/apel/ssmsend.log',
            'level', 'INFO',
            'console', 'true'
        )
    )
);

