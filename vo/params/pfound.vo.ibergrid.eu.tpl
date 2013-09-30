structure template vo/params/pfound.vo.ibergrid.eu;

'name' ?= 'pfound.vo.ibergrid.eu';
'account_prefix' ?= 'pfotqu';

'voms_servers' ?= list(
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40006,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2032000;
