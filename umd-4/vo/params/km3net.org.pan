structure template vo/params/km3net.org;

'name' ?= 'km3net.org';
'account_prefix' ?= 'km3fvi';

'voms_servers' ?= list(
    dict('name', 'voms02.scope.unina.it',
          'host', 'voms02.scope.unina.it',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/km3net.org/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10288000;
