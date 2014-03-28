structure template vo/params/vo.stratuslab.eu;

'name' ?= 'vo.stratuslab.eu';
'account_prefix' ?= 'strtyg';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15180,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2252000;
