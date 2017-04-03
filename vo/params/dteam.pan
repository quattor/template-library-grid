structure template vo/params/dteam;

'name' ?= 'dteam';
'account_prefix' ?= 'dteg';

'voms_servers' ?= list(
    dict('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15004,
          'adminport', 8443,
         ),
    dict('name', 'voms2.hellasgrid.gr',
          'host', 'voms2.hellasgrid.gr',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/dteam/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'eligible for accessing fast batch queues at the site.',
          'fqan', '/dteam/Role=operator',
          'suffix', 'kg',
          'suffix2', 'ybkumtm',
         ),
    dict('description', 'production',
          'fqan', '/dteam/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 16000;
