structure template vo/params/km3net.org;

'name' ?= 'km3net.org';
'account_prefix' ?= 'km3fvi';

'voms_servers' ?= list(
    nlist('name', 'voms02.scope.unina.it',
          'host', 'voms02.scope.unina.it',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10288000;
