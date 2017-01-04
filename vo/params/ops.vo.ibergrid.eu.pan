structure template vo/params/ops.vo.ibergrid.eu;

'name' ?= 'ops.vo.ibergrid.eu';
'account_prefix' ?= 'opssle';

'voms_servers' ?= list(
    dict('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40001,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1912000;
