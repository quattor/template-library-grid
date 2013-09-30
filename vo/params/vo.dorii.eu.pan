structure template vo/params/vo.dorii.eu;

'name' ?= 'vo.dorii.eu';
'account_prefix' ?= 'dortqo';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2052000;
