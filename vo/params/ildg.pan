structure template vo/params/ildg;

'name' ?= 'ildg';
'account_prefix' ?= 'ildri';

'voms_servers' ?= list(
    dict('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15111,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 44000;
