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
#    nlist('description', 'SW manager',
#          'fqan', '/enmr.eu/cirmmp/Role=SoftwareManager',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    nlist('description', 'SW manager',
#          'fqan', '/enmr.eu/bmrz/Role=SoftwareManager',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
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
#    nlist('description', 'SW manager',
#          'fqan', '/enmr.eu/bcbr/Role=SoftwareManager',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 467000;
