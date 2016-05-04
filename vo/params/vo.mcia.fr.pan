structure template vo/params/vo.mcia.fr;

'name' ?= 'vo.mcia.fr';
'account_prefix' ?= 'mcisjo';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20017,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.mcia.fr/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1870000;
