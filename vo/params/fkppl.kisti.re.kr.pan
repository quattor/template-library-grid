structure template vo/params/fkppl.kisti.re.kr;

'name' ?= 'fkppl.kisti.re.kr';
'account_prefix' ?= 'fkprxc';

'voms_servers' ?= list(
    nlist('name', 'palpatine.kisti.re.kr',
          'host', 'palpatine.kisti.re.kr',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 870000;
