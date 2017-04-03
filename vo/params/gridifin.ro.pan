structure template vo/params/gridifin.ro;

'name' ?= 'gridifin.ro';
'account_prefix' ?= 'grifwc';

'voms_servers' ?= list(
    dict('name', 'tbit02.nipne.ro',
          'host', 'tbit02.nipne.ro',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10308000;
