structure template vo/params/vo.plgrid.pl;

'name' ?= 'vo.plgrid.pl';
'account_prefix' ?= 'plghg';

'voms_servers' ?= list(
    nlist('name', 'voms.cyf-kr.edu.pl',
          'host', 'voms.cyf-kr.edu.pl',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 458000;
