structure template vo/params/vo.up.pt;

'name' ?= 'vo.up.pt';
'account_prefix' ?= 'uppriw';

'voms_servers' ?= list(
    dict('name', 'voms.up.pt',
          'host', 'voms.up.pt',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1150000;
