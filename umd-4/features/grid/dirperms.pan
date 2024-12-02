# Template setting appropriate permissions on some key directories used by gLite services

unique template features/grid/dirperms;

# Add glite user
include 'users/glite';

# Set permissions
include 'components/dirperm/config';
'/software/components/dirperm/dependencies/pre' = push('accounts');
'/software/components/dirperm/paths' = push(
    dict(
        'path', GLITE_LOCATION_LOG,
        'owner', GLITE_USER + ':' + GLITE_GROUP,
        'perm', '0775',
        'type', 'd'
    ),
    dict(
        'path', GLITE_LOCATION_VAR,
        'owner', GLITE_USER + ':' + GLITE_GROUP,
        'perm', '0775',
        'type', 'd'
    ),
);
