template features/arc-ce/changes;

include 'components/filecopy/config';

prefix '/software/components/filecopy/services';

# Fixes
# - localSE VOViews
# - per VO running & idle jobs
# - max walltime

# We need to publish the total CPUS only on a single CE & the others
# should have zero. This is horrible, but it must be done.
# see: https://ggus.eu/index.php?mode=ticket_info&ticket_id=125480 we
prefix '{/usr/share/arc/glue-generator.pl}';
'config' = {
    total_cpu_scaling_factor = if (FULL_HOSTNAME == 'arc-ce01.gridpp.rl.ac.uk') 1 else 0;
    format(file_contents('features/arc-ce/glue-generator.pl'), total_cpu_scaling_factor, total_cpu_scaling_factor);
};
'owner' = 'root:root';
'perms' = '0755';

# Fixes
# - don't include memory limit in PeriodicRemove
# - put double quotes around value of NordugridQueue
prefix '{/usr/share/arc/submit-condor-job}';
'config' = file_contents('features/arc-ce/submit-condor-job-memory');
'owner' = 'root:root';
'perms' = '0755';
