structure template vo/params/biomed;

'name' ?= 'biomed';
'account_prefix' ?= 'biow';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'gene sequences analysis related applications',
          'fqan', '/biomed/bioinformatics',
          'suffix', 'mw',
          'suffix2', 'yslqueo',
         ),
    nlist('description', 'medical image processing related applications',
          'fqan', '/biomed/medical_imaging',
          'suffix', 'nw',
          'suffix2', 'brvocob',
         ),
    nlist('description', 'in silico drug discovery related applications',
          'fqan', '/biomed/drug_discovery',
          'suffix', 'uiw',
          'suffix2', 'dievtbe',
         ),
    nlist('description', 'default group',
          'fqan', '/biomed/lcg1',
          'suffix', 'cw',
          'suffix2', 'towwyo',
         ),
    nlist('description', 'administrator',
          'fqan', '/biomed/Role=VO-Admin',
          'suffix', 'lw',
          'suffix2', 'tgvfehp',
         ),
    nlist('description', 'SW manager',
          'fqan', '/biomed/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 6000;
