structure template vo/params/verce.eu;

'name' ?= 'verce.eu';
'account_prefix' ?= 'verfvs';

'voms_servers' ?= list(
    dict('name', 'verce-voms.scai.fraunhofer.de',
          'host', 'verce-voms.scai.fraunhofer.de',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/verce.eu/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10272000;
