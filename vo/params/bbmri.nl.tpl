structure template vo/params/bbmri.nl;

'name' ?= 'bbmri.nl';
'account_prefix' ?= 'bbmfuw';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10250000;
