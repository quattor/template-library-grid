structure template vo/params/ipv6.hepix.org;

'name' ?= 'ipv6.hepix.org';
'account_prefix' ?= 'ipvfum';

'voms_servers' ?= list(
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10266000;
