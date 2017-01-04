structure template vo/params/vo.paus.pic.es;

'name' ?= 'vo.paus.pic.es';
'account_prefix' ?= 'paurss';

'voms_servers' ?= list(
    dict('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', '',
#          'fqan', '/vo.paus.pic.es/Role=mice',
#          'suffix', 'prss',
#          'suffix2', 'vznzcwi',
#         ),
#    dict('description', 'SW manager',
#          'fqan', '/vo.paus.pic.es/Role=misgm',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    dict('description', 'SW manager',
#          'fqan', '/vo.paus.pic.es/Role=pasgm',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    dict('description', '',
#          'fqan', '/vo.paus.pic.es/Role=paus',
#          'suffix', 'ulrss',
#          'suffix2', 'vznetob',
#         ),
);

'base_uid' ?= 730000;
