structure template vo/params/bing.vo.ibergrid.eu;

'name' ?= 'bing.vo.ibergrid.eu';
'account_prefix' ?= 'binspa';

'voms_servers' ?= list(
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2012000;
