structure template vo/params/vo.iscpif.fr;

'name' ?= 'vo.iscpif.fr';
'account_prefix' ?= 'isclu';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.iscpif.fr/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 550000;
