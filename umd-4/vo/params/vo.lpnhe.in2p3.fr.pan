structure template vo/params/vo.lpnhe.in2p3.fr;

'name' ?= 'vo.lpnhe.in2p3.fr';
'account_prefix' ?= 'lpnfl';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.lpnhe.in2p3.fr/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 411000;
