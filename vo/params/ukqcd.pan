structure template vo/params/ukqcd;

'name' ?= 'ukqcd';
'account_prefix' ?= 'ukqh';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 17000;
