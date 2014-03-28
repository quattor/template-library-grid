structure template vo/params/hpc.vo.ibergrid.eu;

'name' ?= 'hpc.vo.ibergrid.eu';
'account_prefix' ?= 'hpcsog';

'voms_servers' ?= list(
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1992000;
