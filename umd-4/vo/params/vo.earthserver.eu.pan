structure template vo/params/vo.earthserver.eu;

'name' ?= 'vo.earthserver.eu';
'account_prefix' ?= 'earfue';

'voms_servers' ?= list(
    dict('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10258000;
