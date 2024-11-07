unique template features/arc-ce/runtime-environments/config;

include 'components/dirperm/config';

'/software/components/dirperm/paths' = {
    append(SELF, dict(
        'path', '/etc/arc',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    append(SELF, dict(
        'path', '/etc/arc/runtime',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    SELF;
};

# Runtime environments to include
include 'features/arc-ce/runtime-environments/glite';
include 'features/arc-ce/runtime-environments/proxy';
include 'features/arc-ce/runtime-environments/atlas-site-lcg';
include 'features/arc-ce/runtime-environments/t2k';
include 'features/arc-ce/runtime-environments/enmr';
include 'features/arc-ce/runtime-environments/biomed';
