structure template vo/params/vo.ipno.in2p3.fr;

'name' ?= 'vo.ipno.in2p3.fr';
'account_prefix' ?= 'ipntr';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.ipno.in2p3.fr/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 79000;
