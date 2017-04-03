structure template vo/params/vo.africa-grid.org;

'name' ?= 'vo.africa-grid.org';
'account_prefix' ?= 'afrfyh';

'voms_servers' ?= list(
    dict('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10365000;
