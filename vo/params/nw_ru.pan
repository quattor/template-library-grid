structure template vo/params/nw_ru;

'name' ?= 'nw_ru';
'account_prefix' ?= 'nwrto';

'voms_servers' ?= list(
    dict('name', 'gt1.pnpi.nw.ru',
          'host', 'gt1.pnpi.nw.ru',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 102000;
