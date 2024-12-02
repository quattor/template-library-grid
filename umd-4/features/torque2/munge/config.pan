unique template features/torque2/munge/config;

variable MUNGE_KEY_FILE ?= undef;
variable MUNGE_KEY_SOURCE ?= undef;

# Create munge user

include 'users/munge';

# Install munge rpm
'/software/packages/{munge}' = dict();

# Configure munge key
variable MUNGE_KEY_TEMPLATE = {
    if ( is_defined(MUNGE_KEY_FILE) ) {
         'features/torque2/munge/key_file';
    } else if ( is_defined(MUNGE_KEY_SOURCE) ) {
         'features/torque2/munge/key_source';
    } else {
         'features/torque2/munge/key_file_nfs';
    };
};

include MUNGE_KEY_TEMPLATE;

# Enable munge service
include 'components/chkconfig/config';
"/software/components/chkconfig/service/munge/on" = "";
"/software/components/chkconfig/service/munge/startstop" = true;

# Configure owner/perms for various munge directories and files

include 'components/dirperm/config';
'/software/components/dirperm/paths' = {
  if((!is_defined(TORQUE_SERVER_HOST))||(TORQUE_SERVER_HOST==FULL_HOSTNAME)||is_defined(MUNGE_KEY_FILE)) {
    append(dict(
      'path', '/etc/munge',
      'owner', 'munge:munge',
      'perm', '0755',
      'type', 'd'
    ));
  };

  if ((!is_defined(TORQUE_SERVER_HOST))||(TORQUE_SERVER_HOST==FULL_HOSTNAME)) {
    if ( !is_defined(MUNGE_KEY_FILE) ) {
      append(dict(
        'path', '/etc/munge/munge.key',
        'owner', 'munge:munge',
        'perm', '0400',
        'type', 'f'
      ));
    };
  };

  append(dict(
    'path', '/var/log/munge',
    'owner', 'munge:munge',
    'perm', '0700',
    'type', 'd'
  ));

  append(dict(
    'path', '/var/log/munge/munged.log',
    'owner', 'munge:munge',
    'perm', '0640',
    'type', 'f'
  ));

  append(dict(
    'path', '/var/lib/munge',
    'owner', 'munge:munge',
    'perm', '0700',
    'type', 'd'
  ));

  append(dict(
    'path', '/var/run/munge',
    'owner', 'munge:munge',
    'perm', '0755',
    'type', 'd'
  ));

  SELF;
};

