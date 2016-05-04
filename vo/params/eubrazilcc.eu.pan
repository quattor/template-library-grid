structure template vo/params/eubrazilcc.eu;

'name' ?= 'eubrazilcc.eu';
'account_prefix' ?= 'eubfwd';

'voms_servers' ?= list(
    nlist('name', 'eubrazilcc-voms.i3m.upv.es',
          'host', 'eubrazilcc-voms.i3m.upv.es',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10309000;
