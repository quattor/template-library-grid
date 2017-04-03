structure template vo/params/aegis;

'name' ?= 'aegis';
'account_prefix' ?= 'aegta';

'voms_servers' ?= list(
    dict('name', 'voms.ipb.ac.rs',
          'host', 'voms.ipb.ac.rs',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'VO Administrators',
          'fqan', '/aegis/Role=VO-Admin',
          'suffix', 'kta',
          'suffix2', 'tgvfehp',
         ),
    dict('description', 'production',
          'fqan', '/aegis/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/aegis/Role=sgmadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 88000;
