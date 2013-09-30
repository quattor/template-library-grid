structure template vo/params/eng.vo.ibergrid.eu;

'name' ?= 'eng.vo.ibergrid.eu';
'account_prefix' ?= 'engtvi';

'voms_servers' ?= list(
    nlist('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40013,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain',
#          'suffix', 'ptvi',
#          'suffix2', 'ufpjjma',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/grid4build',
#          'suffix', 'ratvi',
#          'suffix2', 'tfdcuov',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/Mosfet',
#          'suffix', 'rwtvi',
#          'suffix2', 'zdfbliz',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/Timones',
#          'suffix', 'rxtvi',
#          'suffix2', 'ymhkago',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/turbulencia',
#          'suffix', 'rbtvi',
#          'suffix2', 'uigwrrx',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Portugal',
#          'suffix', 'rstvi',
#          'suffix2', 'vgiumov',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/nanodev',
#          'suffix', 'vttvi',
#          'suffix2', 'dyubzbi',
#         ),
#    nlist('description', '',
#          'fqan', '/eng.vo.ibergrid.eu/Spain/photonics',
#          'suffix', 'rztvi',
#          'suffix2', 'xwlshgu',
#         ),
);

'base_uid' ?= 2176000;
