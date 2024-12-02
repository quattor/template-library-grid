structure template vo/params/vo.pic.es;

'name' ?= 'vo.pic.es';
'account_prefix' ?= 'picrry';

'voms_servers' ?= list(
    dict('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'test group 1',
          'fqan', '/vo.pic.es/vo.pic.es/group01',
          'suffix', 'rsrry',
          'suffix2', 'zpgbddb',
         ),
    dict('description', 'test group 2',
          'fqan', '/vo.pic.es/vo.pic.es/group02',
          'suffix', 'uorry',
          'suffix2', 'zpgbddc',
         ),
);

'base_uid' ?= 710000;
