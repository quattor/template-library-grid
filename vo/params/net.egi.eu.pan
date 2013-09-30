structure template vo/params/net.egi.eu;

'name' ?= 'net.egi.eu';
'account_prefix' ?= 'netfuk';

'voms_servers' ?= list(
    nlist('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10264000;
