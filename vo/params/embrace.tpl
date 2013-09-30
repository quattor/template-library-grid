structure template vo/params/embrace;

'name' ?= 'embrace';
'account_prefix' ?= 'embsh';

'voms_servers' ?= list(
    nlist('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 69000;
