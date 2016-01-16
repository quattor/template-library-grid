structure template vo/params/vo.complex-systems.eu;

'name' ?= 'vo.complex-systems.eu';
'account_prefix' ?= 'comsya';

'voms_servers' ?= list(
    nlist('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15160,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.hellasgrid.gr',
          'host', 'voms2.hellasgrid.gr',
          'port', 15160,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.complex-systems.eu/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1570000;
