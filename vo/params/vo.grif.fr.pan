structure template vo/params/vo.grif.fr;

'name' ?= 'vo.grif.fr';
'account_prefix' ?= 'gritq';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.grif.fr/Role=SW-Manager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'WMS administrators',
          'fqan', '/vo.grif.fr/Role=WMSAdmin',
          'suffix', 'ptq',
          'suffix2', 'xrrlqos',
         ),
    nlist('description', 'Test group',
          'fqan', '/vo.grif.fr/Test',
          'suffix', 'gtq',
          'suffix2', 'tmhiuz',
         ),
);

'base_uid' ?= 78000;
