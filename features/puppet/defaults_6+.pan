template features/puppet/defaults_6+;

include 'components/puppet/config';

variable PUPPET_MODULE_PATH ?= '/etc/puppetlabs/code/environments/production/modules';
variable HIERADATA_DIR ?= '/etc/puppetlabs/code/environments/production/hieradata';
variable HIERADATA_FILENAME ?= 'quattor.yaml';

prefix '/software/components/puppet';

'nodefiles/{quattor_default.pp}/contents' = "lookup('classes', Array[String], 'unique').include";

'modulepath' = PUPPET_MODULE_PATH;

'nodefiles_path' = '/etc/puppetlabs/code/environments/production/manifests';

"hieraconf" = dict(
    "version", 5,
    "defaults", dict(
        "datadir", HIERADATA_DIR,
        "data_hash", "yaml_data",
    ),
    "hierarchy", list(
        dict(
            "name", "quattor",
            "path", HIERADATA_FILENAME,
        )
    ),
);

'hieradata_file' = HIERADATA_DIR + '/' + HIERADATA_FILENAME;
