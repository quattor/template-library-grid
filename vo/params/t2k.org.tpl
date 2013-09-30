structure template vo/params/t2k.org;

'name' ?= 't2k.org';
'account_prefix' ?= 't2kswm';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/t2k.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/t2k.org/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 1530000;
