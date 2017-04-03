structure template vo/params/t2k.org;

'name' ?= 't2k.org';
'account_prefix' ?= 't2kswm';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15003,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/t2k.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/t2k.org/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 1530000;
