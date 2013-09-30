structure template vo/params/vo.cmip5.e-inis.ie;

'name' ?= 'vo.cmip5.e-inis.ie';
'account_prefix' ?= 'cmisxg';

'voms_servers' ?= list(
    nlist('name', 'cagraidsvr10.cs.tcd.ie',
          'host', 'cagraidsvr10.cs.tcd.ie',
          'port', 15022,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.cmip5.e-inis.ie/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1550000;
