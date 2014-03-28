structure template vo/params/vo.sim-e-child.org;

'name' ?= 'vo.sim-e-child.org';
'account_prefix' ?= 'simthm';

'voms_servers' ?= list(
    nlist('name', 'voms.gnubila.fr',
          'host', 'voms.gnubila.fr',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.sim-e-child.org/Role=sgm',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'Users of the development infrastructure',
          'fqan', '/vo.sim-e-child.org/pdi',
          'suffix', 'nthm',
          'suffix2', 'txpvo',
         ),
    nlist('description', 'Users of the production infrastructure',
          'fqan', '/vo.sim-e-child.org/prod',
          'suffix', 'othm',
          'suffix2', 'todmas',
         ),
);

'base_uid' ?= 2492000;
