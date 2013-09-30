structure template vo/params/supernemo.vo.eu-egee.org;

'name' ?= 'supernemo.vo.eu-egee.org';
'account_prefix' ?= 'supus';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/supernemo.vo.eu-egee.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/supernemo.vo.eu-egee.org/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 106000;
