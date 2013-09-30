structure template vo/params/social.vo.ibergrid.eu;

'name' ?= 'social.vo.ibergrid.eu';
'account_prefix' ?= 'soctvh';

'voms_servers' ?= list(
    nlist('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40012,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', '',
#          'fqan', '/social.vo.ibergrid.eu/Portugal',
#          'suffix', 'rvtvh',
#          'suffix2', 'vgiumov',
#         ),
#    nlist('description', '',
#          'fqan', '/social.vo.ibergrid.eu/Spain',
#          'suffix', 'rstvh',
#          'suffix2', 'ufpjjma',
#         ),
);

'base_uid' ?= 2175000;
