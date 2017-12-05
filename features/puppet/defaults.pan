template features/puppet/defaults;

include 'quattor/functions/package';

include 'components/puppet/config';

'/software/components/puppet' = {

    if(!is_defined(PUPPET_VERSION)){
        # Default version is 3
        version = '3.0.0';
    }else{
        if(match(PUPPET_VERSION, '^[1-9]$')){
        # if just 1 figure, complete it to fill version number
            version = PUPPET_VERSION + '.0.0';
        }else{
            version = PUPPET_VERSION;
        };
    };

    # Defaults for version > 4
    if(pkg_compare_version(version, '4.0.0') != PKG_VERSION_LESS){
        SELF['hieraconf_file'] = '/etc/puppetlabs/code/environments/production/hiera.yaml';
        SELF['puppet_cmd'] = '/opt/puppetlabs/bin/puppet';
        SELF['puppetconf_file'] = '/etc/puppetlabs/puppet/puppet.conf';
    };

    # Defaults for version > 5
    if(pkg_compare_version(version, '5.0.0') != PKG_VERSION_LESS){
        SELF['nodefiles'] = dict(escape("quattor_default.pp"),
            dict("contents", "lookup('classes', Array[String], 'unique').include"));
        SELF['modulepath'] = '/etc/puppetlabs/code/environments/production/modules';
        SELF['nodefiles_path'] = '/etc/puppetlabs/code/environments/production/manifests';
        SELF["hieraconf"] = dict(
            "version", 5,
            "hierarchy", list(
                dict(
                    "name", "quattor",
                    "path", "quattor.yaml",
                )
            ),
            "defaults", dict(
                "datadir", "/etc/puppetlabs/code/environments/production/data",
                "data_hash", "yaml_data",
            ),
        );
        SELF['hieradata_file'] = '/etc/puppetlabs/code/environments/production/data/quattor.yaml';
    };

    SELF;
};


