structure template vo/params/chipster.csc.fi;

'name' ?= 'chipster.csc.fi';
'account_prefix' ?= 'chifwe';

'voms_servers' ?= list(
    nlist('name', 'voms.fgi.csc.fi',
          'host', 'voms.fgi.csc.fi',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10310000;
