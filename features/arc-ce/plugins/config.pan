template features/arc-ce/plugins/config;

include 'components/filecopy/config';

prefix '/software/components/filecopy/services';

## authorization plugin which sets default runtime environment
prefix '{/usr/local/bin/default_rte_plugin.py}';
'config' = file_contents('features/arc-ce/plugins/default_rte_plugin.py');
'owner' = 'root:root';
'perms' = '0755';

## authorization plugin which scales CPU & wall times by WN scaling factor
prefix '{/usr/local/bin/scaling_factors_plugin.py}';
'config' = file_contents('features/arc-ce/plugins/scaling_factors_plugin.py');
'owner' = 'root:root';
'perms' = '0755';

## authorization plugin which sends LHCb stdout/err to Echo S3
prefix '{/usr/local/bin/job_logs_to_s3.py}';
'config' = file_contents('features/arc-ce/plugins/job_logs_to_s3.py');
'owner' = 'root:root';
'perms' = '0755';
