structure template vo/params/ulice.vo.eu-egee.org;

'name' ?= 'ulice.vo.eu-egee.org';
'account_prefix' ?= 'ulisfy';

'voms_servers' ?= list(
    nlist('name', 'voms.ngs.ac.uk',
          'host', 'voms.ngs.ac.uk',
          'port', 15030,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1750000;
