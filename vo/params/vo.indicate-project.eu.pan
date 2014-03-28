structure template vo/params/vo.indicate-project.eu;

'name' ?= 'vo.indicate-project.eu';
'account_prefix' ?= 'indths';

'voms_servers' ?= list(
    nlist('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15006,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2472000;
