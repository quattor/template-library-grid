structure template vo/params/rdteam;

'name' ?= 'rdteam';
'account_prefix' ?= 'rdtsu';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'VO administrator',
          'fqan', '/rdteam/Role=VO-Admin',
          'suffix', 'lsu',
          'suffix2', 'tgvfehp',
         ),
    nlist('description', 'SW manager',
          'fqan', '/rdteam/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 56000;
