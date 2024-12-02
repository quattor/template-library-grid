template features/puppet/defaults_5+;

include 'components/puppet/config';

prefix '/software/components/puppet';

'nodefiles/{quattor_default.pp}/contents' = "lookup('classes', Array[String], 'unique').include";

'modulepath' = '/etc/puppetlabs/code/environments/production/modules';

'nodefiles_path' = '/etc/puppetlabs/code/environments/production/manifests';

"hieraconf" = dict(
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

'hieradata_file' = '/etc/puppetlabs/code/environments/production/data/quattor.yaml';
