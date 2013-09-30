structure template vo/params/vo.msfg.fr;

'name' ?= 'vo.msfg.fr';
'account_prefix' ?= 'msfstq';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20023,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.msfg.fr/Role=Software-Manager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1430000;
