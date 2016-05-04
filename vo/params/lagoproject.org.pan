structure template vo/params/lagoproject.org;

'name' ?= 'lagoproject.org';
'account_prefix' ?= 'lagfww';

'voms_servers' ?= list(
    nlist('name', 'voms.ciemat.es',
          'host', 'voms.ciemat.es',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10302000;
