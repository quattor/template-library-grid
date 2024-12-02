structure template vo/params/vo.indigo-datacloud.eu;

'name' ?= 'vo.indigo-datacloud.eu';
'account_prefix' ?= 'indfzt';

'voms_servers' ?= list(
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40101,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10377000;
