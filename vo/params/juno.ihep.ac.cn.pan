structure template vo/params/juno.ihep.ac.cn;

'name' ?= 'juno.ihep.ac.cn';
'account_prefix' ?= 'junfwi';

'voms_servers' ?= list(
    nlist('name', 'voms.ihep.ac.cn',
          'host', 'voms.ihep.ac.cn',
          'port', 15008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10314000;
