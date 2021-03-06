structure template vo/params/imath.cesga.es;

'name' ?= 'imath.cesga.es';
'account_prefix' ?= 'imahu';

'voms_servers' ?= list(
    dict('name', 'voms.egi.cesga.es',
          'host', 'voms.egi.cesga.es',
          'port', 15100,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'all members',
          'fqan', '/imath',
          'suffix', 'whu',
          'suffix2', 'uhiqhei',
         ),
    dict('description', 'I-math software installation',
          'fqan', '/imath/Role=VO-Admin',
          'suffix', 'khu',
          'suffix2', 'rgacqvj',
         ),
);

'base_uid' ?= 446000;
