template features/arc-ce/runtime-environments/atlas-site-lcg;

include 'components/dirperm/config';
include 'components/filecopy/config';


'/software/components/dirperm/paths' = {
    append(SELF, dict(
        'path', '/etc/arc/runtime/APPS',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    append(SELF, dict(
        'path', '/etc/arc/runtime/APPS/HEP',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    SELF;
};

'/software/components/filecopy/dependencies/pre' = append(SELF, 'dirperm');

prefix '/software/components/filecopy/services/{/etc/arc/runtime/APPS/HEP/ATLAS-SITE-LCG}';
'config' = file_contents('features/arc-ce/runtime-environments/ATLAS-SITE-LCG');
'owner' = 'root:root';
'perms' = '0755';
