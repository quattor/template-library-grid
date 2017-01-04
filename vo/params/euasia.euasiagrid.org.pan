structure template vo/params/euasia.euasiagrid.org;

'name' ?= 'euasia.euasiagrid.org';
'account_prefix' ?= 'euarvo';

'voms_servers' ?= list(
    dict('name', 'voms.grid.sinica.edu.tw',
          'host', 'voms.grid.sinica.edu.tw',
          'port', 15015,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/euasia.euasiagrid.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 830000;
