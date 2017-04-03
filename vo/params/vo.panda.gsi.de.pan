structure template vo/params/vo.panda.gsi.de;

'name' ?= 'vo.panda.gsi.de';
'account_prefix' ?= 'panshg';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20022,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.panda.gsi.de/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
#    dict('description', 'SW manager',
#          'fqan', '/vo.panda.gsi.de/Role=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 1810000;
