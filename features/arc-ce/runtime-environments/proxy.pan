template features/arc-ce/runtime-environments/proxy;

include 'components/dirperm/config';
include 'components/filecopy/config';

'/software/components/dirperm/paths' = append(SELF, dict(
    'path', '/etc/arc/runtime/ENV',
    'owner', 'root:root',
    'perm', '0755',
    'type', 'd'
));


'/software/components/filecopy/dependencies/pre' = append(SELF, 'dirperm');

prefix '/software/components/filecopy/services/{/etc/arc/runtime/ENV/PROXY}';
'config' = file_contents('features/arc-ce/runtime-environments/PROXY');
'owner' = 'root:root';
'perms' = '0755';
