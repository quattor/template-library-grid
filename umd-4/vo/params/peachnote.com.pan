structure template vo/params/peachnote.com;

'name' ?= 'peachnote.com';
'account_prefix' ?= 'peafvf';

'voms_servers' ?= list(
    dict('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15003,
          'adminport', 8443,
         ),
    dict('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10285000;
