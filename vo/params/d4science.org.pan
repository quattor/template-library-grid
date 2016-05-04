structure template vo/params/d4science.org;

'name' ?= 'd4science.org';
'account_prefix' ?= 'd4sfyf';

'voms_servers' ?= list(
    nlist('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10363000;
