structure template vo/params/uniandes.edu.co;

'name' ?= 'uniandes.edu.co';
'account_prefix' ?= 'unitxs';

'voms_servers' ?= list(
    nlist('name', 'caribe.uniandes.edu.co',
          'host', 'caribe.uniandes.edu.co',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2212000;
