structure template vo/params/cosmo;

'name' ?= 'cosmo';
'account_prefix' ?= 'cosrr';

'voms_servers' ?= list(
    nlist('name', 'cagraidsvr10.cs.tcd.ie',
          'host', 'cagraidsvr10.cs.tcd.ie',
          'port', 15013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/cosmo/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 27000;
