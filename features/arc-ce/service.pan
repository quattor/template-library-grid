template features/arc-ce/service;

include 'components/filecopy/config';

variable ARC_DEFAULT_TTL ?= 172800;
variable ARC_DEFAULT_TTR ?= 172800;

# Using filecopy because the arc config is weird and has duplicate keys - metaconfig doesn't support duplicate keys
'/software/components/filecopy/services/{/etc/arc.conf}' = dict(
    'config', format(
        file_contents('features/arc-ce/arc.conf'),
        FULL_HOSTNAME,
        ARC_DEFAULT_TTL,
        ARC_DEFAULT_TTR,
        HOSTNAME + ' (RAL-LCG2)',
        # maybe it will be part of arc-giis feature ?
        # UK GIIS
        if ( IS_UK_GIIS ) {
            format(file_contents('features/arc-ce/giis.conf'), GIIS_INDEX, GIIS_INDEX, GIIS_INDEX, GIIS_INDEX);
        } else {
            '';
        },
        file_contents('features/arc-ce/queues.conf'),
    ),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
);
