structure template vo/params/superbvo.org;

'name' ?= 'superbvo.org';
'account_prefix' ?= 'suprms';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15009,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'production',
          'fqan', '/superbvo.org/Role=ProductionManager',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/superbvo.org/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'User role related to analysis task',
          'fqan', '/superbvo.org/Role=Analysis',
          'suffix', 'rrrms',
          'suffix2', 'wptvfti',
         ),
);

'base_uid' ?= 1250000;
