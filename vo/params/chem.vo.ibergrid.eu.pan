structure template vo/params/chem.vo.ibergrid.eu;

'name' ?= 'chem.vo.ibergrid.eu';
'account_prefix' ?= 'chetve';

'voms_servers' ?= list(
    nlist('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40009,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', '',
#          'fqan', '/chem.vo.ibergrid.eu/Portugal',
#          'suffix', 'rttve',
#          'suffix2', 'vgiumov',
#         ),
#    nlist('description', '',
#          'fqan', '/chem.vo.ibergrid.eu/Spain',
#          'suffix', 'rqtve',
#          'suffix2', 'ufpjjma',
#         ),
#    nlist('description', '',
#          'fqan', '/chem.vo.ibergrid.eu/Spain/qcomp',
#          'suffix', 'rwtve',
#          'suffix2', 'vkhlxeb',
#         ),
);

'base_uid' ?= 2172000;
