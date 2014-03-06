structure template vo/params/vo.rhone-alpes.idgrilles.fr;

'name' ?= 'vo.rhone-alpes.idgrilles.fr';
'account_prefix' ?= 'rhorua';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.rhone-alpes.idgrilles.fr/Role=VO-Software-Manager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 790000;
