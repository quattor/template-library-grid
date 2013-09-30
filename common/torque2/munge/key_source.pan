unique template common/torque2/munge/key_source;

variable MUNGE_KEY_SOURCE ?= undef;

include { 'components/filecopy/config' };
"/software/components/filecopy/services/{/etc/munge/munge.key}" = nlist(
    'source', MUNGE_KEY_SOURCE,
    'perms', '0400',
    'owner', 'munge',
    'group', 'munge',
    'no_utf8', true,
    'backup', false,
    'restart', '/etc/init.d/munge restart',
);
