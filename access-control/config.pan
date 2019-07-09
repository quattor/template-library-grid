template features/arc-ce/access-control/config;

include 'components/filecopy/config';

# LCAS
prefix '/software/components/filecopy/services';

'{/usr/etc/lcas/ban_users.db}/config' = file_contents('features/arc-ce/access-control/ban_users.db');
'{/usr/etc/lcas/lcas.db}/config' = file_contents('features/arc-ce/lcas.db');
