template features/arc-ce/access-control/config;

include 'components/filecopy/config';

# LCAS
prefix '/software/components/filecopy/services';

'{/usr/etc/lcas/lcas.db}/config' = file_contents('features/arc-ce/lcas.db');
