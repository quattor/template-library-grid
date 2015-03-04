structure template vo/params/envirogrids.vo.eu-egee.org;

'name' ?= 'envirogrids.vo.eu-egee.org';
'account_prefix' ?= 'envtza';

'voms_servers' ?= list(
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15012,
          'adminport', 8443,
         ),

);

'voms_mappings' ?= list(
);

'base_uid' ?= 2272000;
