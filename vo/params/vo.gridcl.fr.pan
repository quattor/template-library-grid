structure template vo/params/vo.gridcl.fr;

'name' ?= 'vo.gridcl.fr';
'account_prefix' ?= 'grifui';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15020,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10262000;
