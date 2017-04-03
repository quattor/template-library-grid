structure template vo/params/physiome.lf1.cuni.cz;

'name' ?= 'physiome.lf1.cuni.cz';
'account_prefix' ?= 'phyfwr';

'voms_servers' ?= list(
    dict('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15011,
          'adminport', 8443,
         ),
    dict('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15011,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10297000;
