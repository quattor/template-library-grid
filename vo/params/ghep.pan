structure template vo/params/ghep;

'name' ?= 'ghep';
'account_prefix' ?= 'ghetx';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15105,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 85000;
