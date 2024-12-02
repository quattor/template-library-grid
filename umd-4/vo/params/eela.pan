structure template vo/params/eela;

'name' ?= 'eela';
'account_prefix' ?= 'eeltc';

'voms_servers' ?= list(
    dict('name', 'voms.eela.ufrj.br',
          'host', 'voms.eela.ufrj.br',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', '',
          'fqan', '/eela/Role=TrailersManager',
          'suffix', 'rqtc',
          'suffix2', 'tavjngh',
         ),
    dict('description', 'Admin',
          'fqan', '/eela/Role=VO',
          'suffix', 'dtc',
          'suffix2', 'alnrocr',
         ),
    dict('description', 'production',
          'fqan', '/eela/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/eela/Role=sgmadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 90000;
