structure template vo/params/bg-edu.grid.acad.bg;

'name' ?= 'bg-edu.grid.acad.bg';
'account_prefix' ?= 'bgesdk';

'voms_servers' ?= list(
    nlist('name', 'voms.ipp.acad.bg',
          'host', 'voms.ipp.acad.bg',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1710000;
