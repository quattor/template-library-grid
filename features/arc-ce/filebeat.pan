template features/arc-ce/filebeat;

include 'components/chkconfig/config';
include 'components/filecopy/config';

# Logstash
'/software/repositories' = add_repositories(list('elasticsearch/legacy'));
'/software/packages' = pkg_repl('filebeat', '1.3.1-1', 'x86_64');

'/software/components/filecopy/services/{/etc/filebeat/filebeat.yml}' = dict(
    'config', file_contents('features/arc-ce/filebeat.yml'),
    'backup', false,
    'owner', 'root:root',
    'restart', '/sbin/service filebeat restart',
    'perms', '0644',
);

'/software/components/chkconfig/service/filebeat' = dict(
    'on', '',
    'startstop', true,
);
