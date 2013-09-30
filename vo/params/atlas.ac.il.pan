structure template vo/params/atlas.ac.il;

'name' ?= 'atlas.ac.il';
'account_prefix' ?= 'atlsdq';

'voms_servers' ?= list(
    nlist('name', 'voms.hep.tau.ac.il',
          'host', 'voms.hep.tau.ac.il',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1690000;
