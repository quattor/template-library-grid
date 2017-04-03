structure template vo/params/extras-fp7.eu;

'name' ?= 'extras-fp7.eu';
'account_prefix' ?= 'extfyl';

'voms_servers' ?= list(
    dict('name', 'voms.ba.infn.it',
          'host', 'voms.ba.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10369000;
