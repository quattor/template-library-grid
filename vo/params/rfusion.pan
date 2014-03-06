structure template vo/params/rfusion;

'name' ?= 'rfusion';
'account_prefix' ?= 'rfuss';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/rfusion/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 54000;
