structure template vo/params/eli-np.eu;

'name' ?= 'eli-np.eu';
'account_prefix' ?= 'elifwz';

'voms_servers' ?= list(
    nlist('name', 'tbit02.nipne.ro',
          'host', 'tbit02.nipne.ro',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10305000;
