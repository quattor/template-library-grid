structure template vo/params/edteam;

'name' ?= 'edteam';
'account_prefix' ?= 'edttd';

'voms_servers' ?= list(
);

'voms_mappings' ?= list(
    dict('description', 'Admin',
          'fqan', '/edteam/Role=VO',
          'suffix', 'ftd',
          'suffix2', 'alnrocr',
         ),
    dict('description', '',
          'fqan', '/edteam/Role=lhcbsgm',
          'suffix', 'ktd',
          'suffix2', 'strxfww',
         ),
    dict('description', 'production',
          'fqan', '/edteam/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/edteam/Role=sgmadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 91000;
