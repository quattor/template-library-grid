structure template vo/params/vo.dariah.eu;

'name' ?= 'vo.dariah.eu';
'account_prefix' ?= 'darfxy';

'voms_servers' ?= list(
    dict('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10330000;
