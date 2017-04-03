structure template vo/params/egeode;

'name' ?= 'egeode';
'account_prefix' ?= 'egex';

'voms_servers' ?= list(
    dict('name', 'cclcgvomsli01.in2p3.fr',
          'host', 'cclcgvomsli01.in2p3.fr',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/egeode/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/egeode/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 7000;
