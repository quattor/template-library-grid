structure template vo/params/dream.hipcat.net;

'name' ?= 'dream.hipcat.net';
'account_prefix' ?= 'drefuz';

'voms_servers' ?= list(
    dict('name', 'voms.hpcc.ttu.edu',
          'host', 'voms.hpcc.ttu.edu',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/dream/dreamadm',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/dream/dreamdaq',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'DREAM general use',
          'fqan', '/dream',
          'suffix', 'wfuz',
          'suffix2', 'uhywfoo',
         ),
);

'base_uid' ?= 10253000;
