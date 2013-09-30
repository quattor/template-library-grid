# This templates generate for each VO a queue name matching Torque restrictions and then merge this queue list
# with those explicitly defined by site.
# Generated queue name is derived from VO name.
# In Torque, queue name is restricted to 15 characters. If VO name is longer,
# truncate after removing 'vo.' prefix if any.
# Also convert '-' to '_' in queue names to work around a GIP plugin restriction.

unique template common/torque2/server/build-queue-list;

variable TEST = debug(OBJECT+': executing '+TEMPLATE);

# For backward compatibility, allow CE_QUEUES to be explicitly defined by site.
# Normally, this should be done using CE_QUEUES_SITE variable.
variable CE_QUEUES ?= {
  SELF['vos'] = nlist();
  SELF['attlist'] = nlist();
  foreach (k;vo;VOS) {
    # Substitute '-' into '_' in queue name as GIP is not handling properly '-' in queue names and
    # queue appears to be closed.
    queue = replace('-','_',vo);
    if ( length(vo) > 15 ) {
      queue = replace('^vo\.','',queue);
      if ( length(queue) > 15 ) {
        # Remove trailing '.' if any
        if ( index('.',queue,14) == 14 ) {
          queue = substr(queue,0,14);
        } else {
          queue = substr(queue,0,15);
        };
      };
    };
    SELF['vos'][queue] = list(vo);
  };

  SELF;
};


# Merge CE_QUEUES with CE_QUEUES_SITE
# If a VO in the queue access list is preceded by '-', this means the VO must be removed.
# If a queue 'attlist' is undef, queue must be removed.

variable CE_QUEUES = {
  if ( exists(CE_QUEUES_SITE['attlist']) && is_defined(CE_QUEUES_SITE['attlist']) ) {
    foreach (queue;attlist;CE_QUEUES_SITE['attlist']) {
      if ( is_defined(attlist) ) {
        foreach(att;value;attlist) {
          if ( !exists(SELF['attlist'][queue]) ) {
            SELF['attlist'][queue] = nlist();
          };
          SELF['attlist'][queue][att] = value;
        };
      } else {
        SELF['attlist'][queue] = null;
        SELF['vos'][queue] = null;
      };
    };
  };
  if ( exists(CE_QUEUES_SITE['vos']) && is_defined(CE_QUEUES_SITE['vos']) ) {
    foreach (queue;vos;CE_QUEUES_SITE['vos']) {
      if ( !exists(SELF['vos'][queue]) ) {
        SELF['vos'][queue] = list();
      };
      foreach (i;vo;vos) {
        if ( match(vo, '^-') ) {
          delvo = true;
          vo = substr(vo,1);
        } else {
          delvo = false;
        };
        vo_ind = index(vo, SELF['vos'][queue]);
        if ( delvo && (vo_ind >= 0) ) {
          SELF['vos'][queue] = splice(SELF['vos'][queue],vo_ind,1);
        } else if ( !delvo && (vo_ind < 0) ) {
          SELF['vos'][queue][length(SELF['vos'][queue])] = vo;
        };
      };
    };
  };
  SELF;
};

