structure template vo/params/vo.renabi.fr;

'name' ?= 'vo.renabi.fr';
'account_prefix' ?= 'renow';

'voms_servers' ?= list(
    dict('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', 'SW manager',
#          'fqan', '/vo.renabi.fr/Role=softadm',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 630000;
