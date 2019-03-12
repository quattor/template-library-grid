template features/arc-ce/runtime-environments/glite;

include 'components/dirperm/config';
include 'components/filecopy/config';


'/software/components/dirperm/paths' = {
    append(SELF, dict(
        'path', '/etc/arc/runtime',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    append(SELF, dict(
        'path', '/etc/arc/runtime/ENV',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd'
    ));
    SELF;
};


'/software/components/filecopy/dependencies/pre' = append('dirperm');

prefix '/software/components/filecopy/services/{/etc/arc/runtime/ENV/GLITE}';
'config' = file_contents('features/arc-ce/runtime-environments/GLITE');
'owner' = 'root:root';
'perms' = '0755';
