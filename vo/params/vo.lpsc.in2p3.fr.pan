structure template vo/params/vo.lpsc.in2p3.fr;

'name' ?= 'vo.lpsc.in2p3.fr';
'account_prefix' ?= 'lpspk';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 670000;
