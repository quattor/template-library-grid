structure template vo/params/rgstest;

'name' ?= 'rgstest';
'account_prefix' ?= 'rgsst';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'VO administrator',
          'fqan', '/rgstest/Role=VO-Admin',
          'suffix', 'mst',
          'suffix2', 'tgvfehp',
         ),
    nlist('description', 'SW manager',
          'fqan', '/rgstest/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 55000;
