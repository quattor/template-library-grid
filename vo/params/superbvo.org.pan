structure template vo/params/superbvo.org;

'name' ?= 'superbvo.org';
'account_prefix' ?= 'suprms';

'voms_servers' ?= list(
    dict('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15009,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'production',
          'fqan', '/superbvo.org/Role=ProductionManager',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/superbvo.org/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'User role related to analysis task',
          'fqan', '/superbvo.org/Role=Analysis',
          'suffix', 'rrrms',
          'suffix2', 'wptvfti',
         ),
);

'base_uid' ?= 1250000;
