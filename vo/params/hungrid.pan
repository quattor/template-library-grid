structure template vo/params/hungrid;

'name' ?= 'hungrid';
'account_prefix' ?= 'hunsc';

'voms_servers' ?= list(
    nlist('name', 'grid11.kfki.hu',
          'host', 'grid11.kfki.hu',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 64000;
