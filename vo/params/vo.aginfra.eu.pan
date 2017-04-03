structure template vo/params/vo.aginfra.eu;

'name' ?= 'vo.aginfra.eu';
'account_prefix' ?= 'agifud';

'voms_servers' ?= list(
    dict('name', 'voms.ipb.ac.rs',
          'host', 'voms.ipb.ac.rs',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10257000;
