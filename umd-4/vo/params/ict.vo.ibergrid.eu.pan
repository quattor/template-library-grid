structure template vo/params/ict.vo.ibergrid.eu;

'name' ?= 'ict.vo.ibergrid.eu';
'account_prefix' ?= 'icttul';

'voms_servers' ?= list(
    dict('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40008,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', '',
#          'fqan', '/ict.vo.ibergrid.eu/Portugal',
#          'suffix', 'rstul',
#          'suffix2', 'vgiumov',
#         ),
#    dict('description', '',
#          'fqan', '/ict.vo.ibergrid.eu/Spain',
#          'suffix', 'ptul',
#          'suffix2', 'ufpjjma',
#         ),
#    dict('description', '',
#          'fqan', '/ict.vo.ibergrid.eu/Spain/archive',
#          'suffix', 'rxtul',
#          'suffix2', 'vyueqyd',
#         ),
#    dict('description', '',
#          'fqan', '/ict.vo.ibergrid.eu/Spain/proclang',
#          'suffix', 'rytul',
#          'suffix2', 'vbxmdx',
#         ),
);

'base_uid' ?= 2153000;
