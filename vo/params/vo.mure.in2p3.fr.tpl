structure template vo/params/vo.mure.in2p3.fr;

'name' ?= 'vo.mure.in2p3.fr';
'account_prefix' ?= 'murteq';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15014,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.mure.in2p3.fr/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 2392000;
