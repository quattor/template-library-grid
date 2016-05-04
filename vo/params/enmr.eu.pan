structure template vo/params/enmr.eu;

'name' ?= 'enmr.eu';
'account_prefix' ?= 'enmhp';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15014,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15014,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/enmr.eu/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
#    nlist('description', 'VO Administrator',
#          'fqan', '/enmr.eu/Role=VO-Admin',
#          'suffix', 'mhp',
#          'suffix2', 'tgvfehp',
#         ),
    nlist('description', 'users of the given application group',
          'fqan', '/enmr.eu/*',
          'suffix', 'ahp',
          'suffix2', 'svh',
         ),
#    nlist('description', 'operations/Nagios user',
#          'fqan', '/enmr.eu/ops',
#          'suffix', 'chp',
#          'suffix2', 'txozh',
#         ),
);

'base_uid' ?= 467000;
