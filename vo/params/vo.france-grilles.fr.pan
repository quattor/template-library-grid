structure template vo/params/vo.france-grilles.fr;

'name' ?= 'vo.france-grilles.fr';
'account_prefix' ?= 'frafux';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15017,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10251000;
