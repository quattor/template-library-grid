structure template vo/params/vo.magrid.ma;

'name' ?= 'vo.magrid.ma';
'account_prefix' ?= 'magfyp';

'voms_servers' ?= list(
    dict('name', 'voms.magrid.ma',
          'host', 'voms.magrid.ma',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10373000;
