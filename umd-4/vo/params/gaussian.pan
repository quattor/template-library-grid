structure template vo/params/gaussian;

'name' ?= 'gaussian';
'account_prefix' ?= 'gauvk';

'voms_servers' ?= list(
    dict('name', 'voms.cyf-kr.edu.pl',
          'host', 'voms.cyf-kr.edu.pl',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 150000;
