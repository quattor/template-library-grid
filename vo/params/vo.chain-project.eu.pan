structure template vo/params/vo.chain-project.eu;

'name' ?= 'vo.chain-project.eu';
'account_prefix' ?= 'chafwx';

'voms_servers' ?= list(
    nlist('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10303000;
