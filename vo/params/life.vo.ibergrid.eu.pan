structure template vo/params/life.vo.ibergrid.eu;

'name' ?= 'life.vo.ibergrid.eu';
'account_prefix' ?= 'liftvf';

'voms_servers' ?= list(
    dict('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 40010,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms01.ncg.ingrid.pt',
          'host', 'voms01.ncg.ingrid.pt',
          'port', 40010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Portugal',
#          'suffix', 'rttvf',
#          'suffix2', 'vgiumov',
#         ),
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Spain',
#          'suffix', 'rqtvf',
#          'suffix2', 'ufpjjma',
#         ),
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Spain/blast',
#          'suffix', 'rwtvf',
#          'suffix2', 'vjergvp',
#         ),
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Spain/filogen',
#          'suffix', 'rytvf',
#          'suffix2', 'upvxxhn',
#         ),
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Spain/Frodock',
#          'suffix', 'vutvf',
#          'suffix2', 'bvvwymv',
#         ),
#    dict('description', '',
#          'fqan', '/life.vo.ibergrid.eu/Spain/odthpiv',
#          'suffix', 'zqtvf',
#          'suffix2', 'sfrdkox',
#         ),
);

'base_uid' ?= 2173000;
