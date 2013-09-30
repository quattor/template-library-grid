structure template vo/params/vo.agata.org;

'name' ?= 'vo.agata.org';
'account_prefix' ?= 'agahj';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 461000;
