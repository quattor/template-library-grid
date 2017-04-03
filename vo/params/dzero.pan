structure template vo/params/dzero;

'name' ?= 'dzero';
'account_prefix' ?= 'dzea';

'voms_servers' ?= list(
    dict('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'Used by D0 Farm production to access elevated resources',
          'fqan', '/dzero/users/Role=D0Production',
          'suffix', 'rua',
          'suffix2', 'xauwams',
         ),
    dict('description', 'Normal user jobs',
          'fqan', '/dzero/users/Role=analysis',
          'suffix', 'rqa',
          'suffix2', 'dvwqwtx',
         ),
);

'base_uid' ?= 10000;
