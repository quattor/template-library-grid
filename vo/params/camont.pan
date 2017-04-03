structure template vo/params/camont;

'name' ?= 'camont';
'account_prefix' ?= 'camelg';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15025,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/camont/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10026000;
