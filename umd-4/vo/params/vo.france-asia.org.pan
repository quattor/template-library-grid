structure template vo/params/vo.france-asia.org;

'name' ?= 'vo.france-asia.org';
'account_prefix' ?= 'frafub';

'voms_servers' ?= list(
    dict('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10255000;
