structure template vo/params/eirevo.ie;

'name' ?= 'eirevo.ie';
'account_prefix' ?= 'eirxy';

'voms_servers' ?= list(
    nlist('name', 'cagraidsvr10.cs.tcd.ie',
          'host', 'cagraidsvr10.cs.tcd.ie',
          'port', 15019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/eirevo.ie/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 190000;
