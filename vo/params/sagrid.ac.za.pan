structure template vo/params/sagrid.ac.za;

'name' ?= 'sagrid.ac.za';
'account_prefix' ?= 'sagfvo';

'voms_servers' ?= list(
    dict('name', 'voms.sagrid.ac.za',
          'host', 'voms.sagrid.ac.za',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10294000;
