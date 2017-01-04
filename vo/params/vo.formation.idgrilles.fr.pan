structure template vo/params/vo.formation.idgrilles.fr;

'name' ?= 'vo.formation.idgrilles.fr';
'account_prefix' ?= 'forrzk';

'voms_servers' ?= list(
    dict('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 930000;
