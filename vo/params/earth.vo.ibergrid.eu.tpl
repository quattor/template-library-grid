structure template vo/params/earth.vo.ibergrid.eu;

'name' ?= 'earth.vo.ibergrid.eu';
'account_prefix' ?= 'eartvg';

'voms_servers' ?= list(
    nlist('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40011,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', '',
#          'fqan', '/earth.vo.ibergrid.eu/Portugal',
#          'suffix', 'rutvg',
#          'suffix2', 'vgiumov',
#         ),
#    nlist('description', '',
#          'fqan', '/earth.vo.ibergrid.eu/Spain',
#          'suffix', 'rrtvg',
#          'suffix2', 'ufpjjma',
#         ),
#    nlist('description', '',
#          'fqan', '/earth.vo.ibergrid.eu/Spain/meteo',
#          'suffix', 'rxtvg',
#          'suffix2', 'vkzmjlt',
#         ),
);

'base_uid' ?= 2174000;
