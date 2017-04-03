structure template vo/params/afigrid.cl;

'name' ?= 'afigrid.cl';
'account_prefix' ?= 'afifwn';

'voms_servers' ?= list(
    dict('name', 'voms.fis.puc.cl',
          'host', 'voms.fis.puc.cl',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10319000;
