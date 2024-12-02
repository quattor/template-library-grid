structure template vo/params/vo.eu-decide.eu;

'name' ?= 'vo.eu-decide.eu';
'account_prefix' ?= 'eudtao';

'voms_servers' ?= list(
    dict('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2312000;
