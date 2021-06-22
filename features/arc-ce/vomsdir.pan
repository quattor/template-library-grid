template features/arc-ce/vomsdir;

include 'components/dirperm/config';
include 'components/filecopy/config';
include 'components/vomsclient/config';

include 'common/template-library/grid';

variable GLITE_LOCATION_VAR ?= '/usr';

# Included from Grid Template Library
include 'vo/functions';
include 'vo/init';
include 'features/security/vomsclient';

'/software/components/vomsclient' = combine_vomsclient_vos(VOS);

'/software/repositories' = append(create('repository/wlcg-x86_64-el6'));

'/software/packages' = {
    pkg_add('wlcg-voms-alice');
    pkg_add('wlcg-voms-atlas');
    pkg_add('wlcg-voms-cms');
    pkg_add('wlcg-voms-lhcb');
    pkg_add('wlcg-voms-ops');
};

include 'vo/certs/voms_dn_list';

'/software/components/dirperm/paths' = {
    foreach ( i; v; VOS ) {
        append(SELF,
            dict(
                'path', '/etc/grid-security/vomsdir/' + v,
                'owner', 'root:root',
                'perm', '0755',
                'type', 'd',
            )
        );
    };
    SELF;
};

'/software/components/filecopy/services' = merge(SELF, {
    results = dict();
    foreach ( i; v; VOS ) {
        XX = create(format('vo/params/%s', v));
        foreach ( j; voms_server; XX["voms_servers"] ) {
            # voms_server['host']
            # vvv[voms_server['host']]['subject']
            # vvv[voms_server['host']]['issuer']
            ## create the /etc/grid-security/vomsdir/ v / voms_server['host'] .lsc file
            hostname = voms_server['host'];
            LSCFILE = format("%s\n%s\n", VOMS_SERVER_DN[hostname]['subject'], VOMS_SERVER_DN[hostname]['issuer']);
            results[escape(format('/etc/grid-security/vomsdir/%s/%s.lsc', v, hostname))] = dict(
                'config', LSCFILE,
                'owner', 'root:root',
                'perms', '0644',
                'backup', false,
            );
        };
    };
    results;
});

