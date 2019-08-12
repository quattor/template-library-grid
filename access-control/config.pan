template features/arc-ce/access-control/config;

include 'components/filecopy/config';

variable RAL_ARGUS_SERVER = "lcgargus.gridpp.rl.ac.uk";

# LCAS
prefix '/software/components/filecopy/services';

'{/usr/etc/lcas/ban_users.db}/config' = file_contents('features/arc-ce/access-control/ban_users.db');
'{/usr/etc/lcas/lcas.db}/config' = file_contents('features/arc-ce/access-control/lcas.db');
'{/usr/etc/lcmaps/lcmaps.db}/config' = format(file_contents('features/arc-ce/access-control/lcmaps.db'), RAL_ARGUS_SERVER);
'{/usr/etc/lcmaps/vo-mapfile}/config' = file_contents('features/arc-ce/access-control/vo-mapfile');

# empty local-grid-mapfile-ral file
'{/etc/grid-security/local-grid-mapfile-ral}/config' = '';

# empty grid-mapfile file - is it needed??
'{/etc/grid-security/grid-mapfile}/config' = '';
