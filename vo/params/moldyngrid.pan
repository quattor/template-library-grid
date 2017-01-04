structure template vo/params/moldyngrid;

'name' ?= 'moldyngrid';
'account_prefix' ?= 'molsee';

'voms_servers' ?= list(
    dict('name', 'voms.grid.org.ua',
          'host', 'voms.grid.org.ua',
          'port', 15110,
          'adminport', 443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/moldyngrid/Role=VO-Admin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/moldyngrid/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 1730000;
