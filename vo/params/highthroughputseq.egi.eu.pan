structure template vo/params/highthroughputseq.egi.eu;

'name' ?= 'highthroughputseq.egi.eu';
'account_prefix' ?= 'higfws';

'voms_servers' ?= list(
    nlist('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15012,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15012,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10298000;
