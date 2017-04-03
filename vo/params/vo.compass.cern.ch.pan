structure template vo/params/vo.compass.cern.ch;

'name' ?= 'vo.compass.cern.ch';
'account_prefix' ?= 'comfwa';

'voms_servers' ?= list(
    dict('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10306000;
