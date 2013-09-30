structure template vo/params/dteam;

'name' ?= 'dteam';
'account_prefix' ?= 'dteg';

'voms_servers' ?= list(
    nlist('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/dteam/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'eligible for accessing fast batch queues at the site.',
          'fqan', '/dteam/Role=operator',
          'suffix', 'kg',
          'suffix2', 'ybkumtm',
         ),
    nlist('description', 'production',
          'fqan', '/dteam/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 16000;
