structure template vo/params/solovo;

'name' ?= 'solovo';
'account_prefix' ?= 'solru';

'voms_servers' ?= list(
    nlist('name', 'cagraidsvr10.cs.tcd.ie',
          'host', 'cagraidsvr10.cs.tcd.ie',
          'port', 15012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/solovo/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 30000;
