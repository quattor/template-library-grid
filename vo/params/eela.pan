structure template vo/params/eela;

'name' ?= 'eela';
'account_prefix' ?= 'eeltc';

'voms_servers' ?= list(
    nlist('name', 'voms.eela.ufrj.br',
          'host', 'voms.eela.ufrj.br',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', '',
          'fqan', '/eela/Role=TrailersManager',
          'suffix', 'rqtc',
          'suffix2', 'tavjngh',
         ),
    nlist('description', 'Admin',
          'fqan', '/eela/Role=VO',
          'suffix', 'dtc',
          'suffix2', 'alnrocr',
         ),
    nlist('description', 'production',
          'fqan', '/eela/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/eela/Role=sgmadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 90000;
