template features/arc-ce/jobs;

include 'components/cron/config';
include 'components/filecopy/config';

# ARC CEs do not provide proper information about jobs by VO in the
# VOViews. The following is a script which generates files containing
# lists of running & idle jobs by VO. This information is then read
# by custom functions added to /usr/share/arc/glue-generator.pl

prefix '/software/components/filecopy/services/{/usr/local/bin/condorjobs.sh}';
'config' = file_contents('features/arc-ce/condorjobs.sh');
'owner' = 'root:root';
'perms' = '0755';

'/software/components/cron/entries' = append(SELF, dict(
    'name', 'tier1-arc-condor-jobs-by-vo',
    'user', 'root',
    'frequency', '0,10,20,30,40,50 * * * *',
    'command', '/usr/local/bin/condorjobs.sh',
));
