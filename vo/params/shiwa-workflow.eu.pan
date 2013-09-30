structure template vo/params/shiwa-workflow.eu;

'name' ?= 'shiwa-workflow.eu';
'account_prefix' ?= 'shitfe';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15016,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2432000;
