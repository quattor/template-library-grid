structure template vo/params/vo.dirac.ac.uk;

'name' ?= 'vo.dirac.ac.uk';
'account_prefix' ?= 'dirfwm';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10318000;
