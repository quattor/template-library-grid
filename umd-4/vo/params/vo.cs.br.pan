structure template vo/params/vo.cs.br;

'name' ?= 'vo.cs.br';
'account_prefix' ?= 'csbski';

'voms_servers' ?= list(
    dict('name', 'voms.cat.cbpf.br',
          'host', 'voms.cat.cbpf.br',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'Group test',
          'fqan', '/vo.cs.br/group/subgroup/Role=test',
          'suffix', 'ryski',
          'suffix2', 'yzslpiy',
         ),
    dict('description', 'Users',
          'fqan', '/vo.cs.br/all/user/Role=user',
          'suffix', 'rsski',
          'suffix2', 'axyfej',
         ),
);

'base_uid' ?= 1890000;
