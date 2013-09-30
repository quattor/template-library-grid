structure template vo/params/d4science.research-infrastructures.eu;

'name' ?= 'd4science.research-infrastructures.eu';
'account_prefix' ?= 'd4smi';

'voms_servers' ?= list(
    nlist('name', 'voms.research-infrastructures.eu',
          'host', 'voms.research-infrastructures.eu',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 590000;
