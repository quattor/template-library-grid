structure template vo/params/moldyngrid;

'name' ?= 'moldyngrid';
'account_prefix' ?= 'molsee';

'voms_servers' ?= list(
    nlist('name', 'grid.org.ua',
          'host', 'grid.org.ua',
          'port', 15010,
          'adminport', 443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/moldyngrid/Role=VO-Admin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/moldyngrid/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 1730000;
