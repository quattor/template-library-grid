structure template vo/params/phys.vo.ibergrid.eu;

'name' ?= 'phys.vo.ibergrid.eu';
'account_prefix' ?= 'phytuk';

'voms_servers' ?= list(
    dict('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40007,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', '',
#          'fqan', '/phys.vo.ibergrid.eu/Spain/gphase',
#          'suffix', 'rxtuk',
#          'suffix2', 'boxgxkl',
#         ),
#    dict('description', '',
#          'fqan', '/phys.vo.ibergrid.eu/Spain/slgrid',
#          'suffix', 'vttuk',
#          'suffix2', 'dqnxmfe',
#         ),
#    dict('description', '',
#          'fqan', '/phys.vo.ibergrid.eu/Portugal',
#          'suffix', 'rttuk',
#          'suffix2', 'vgiumov',
#         ),
#    dict('description', '',
#          'fqan', '/phys.vo.ibergrid.eu/Spain',
#          'suffix', 'rqtuk',
#          'suffix2', 'ufpjjma',
#         ),
);

'base_uid' ?= 2152000;
