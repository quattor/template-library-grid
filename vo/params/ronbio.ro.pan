structure template vo/params/ronbio.ro;

'name' ?= 'ronbio.ro';
'account_prefix' ?= 'ronfwj';

'voms_servers' ?= list(
    nlist('name', 'tbit02.nipne.ro',
          'host', 'tbit02.nipne.ro',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10315000;
