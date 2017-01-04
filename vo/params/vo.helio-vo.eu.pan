structure template vo/params/vo.helio-vo.eu;

'name' ?= 'vo.helio-vo.eu';
'account_prefix' ?= 'helroa';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15506,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15506,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15506,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'data manager',
          'fqan', '/vo.helio-vo.eu/Role=data-admin',
          'suffix', 'rvroa',
          'suffix2', 'uwesndw',
         ),
    dict('description', 'SW manager',
          'fqan', '/vo.helio-vo.eu/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1310000;
