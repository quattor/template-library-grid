structure template vo/params/vo.lapp.in2p3.fr;

'name' ?= 'vo.lapp.in2p3.fr';
'account_prefix' ?= 'lapik';

'voms_servers' ?= list(
    dict('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.lapp.in2p3.fr/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 488000;
