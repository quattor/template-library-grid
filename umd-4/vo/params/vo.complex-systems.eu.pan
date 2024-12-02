structure template vo/params/vo.complex-systems.eu;

'name' ?= 'vo.complex-systems.eu';
'account_prefix' ?= 'comsya';

'voms_servers' ?= list(
    dict('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15160,
          'adminport', 8443,
         ),
    dict('name', 'voms2.hellasgrid.gr',
          'host', 'voms2.hellasgrid.gr',
          'port', 15160,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.complex-systems.eu/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1570000;
