structure template vo/params/vo.lifewatch.eu;

'name' ?= 'vo.lifewatch.eu';
'account_prefix' ?= 'liffvl';

'voms_servers' ?= list(
    nlist('name', 'ibergrid-voms.ifca.es',
          'host', 'ibergrid-voms.ifca.es',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10291000;
