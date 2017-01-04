structure template vo/params/drihm.eu;

'name' ?= 'drihm.eu';
'account_prefix' ?= 'drifvd';

'voms_servers' ?= list(
    dict('name', 'vomsIGI-NA.unina.it',
          'host', 'vomsIGI-NA.unina.it',
          'port', 15005,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15005,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    dict('description', 'SW manager',
#          'fqan', 'drihm.eu/ROLE=SoftwareManager',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 10283000;
