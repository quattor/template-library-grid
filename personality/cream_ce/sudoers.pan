# Template settting sudo for a CREAM CE

unique template personality/cream_ce/sudoers;

include { 'components/sudo/config' };

"/software/components/sudo/run_as_aliases" = {
  SELF['GLEXEC_ACCOUNTS'] = list();
  foreach(i;vo;VOS) {
    if ( is_defined(VO_INFO[vo]['group']) && is_defined(VO_INFO[vo]['accounts']['users']) ) {
      # The 'CREAM' prefix has been choosed rather than 'GLEXEC', because
      # it permits to the CREAM_* aliases to be listed first in the sudoers file
      account = "CREAM_" +  replace('[\.\-]','_',to_uppercase(VO_INFO[vo]['group']));
      SELF[account] = list();
      foreach (username;userinfo;VO_INFO[vo]['accounts']['users']) {
        if (exists(userinfo['poolSize'])) {
          poolStart = to_long(userinfo['poolStart']);
          poolSize = to_long(userinfo['poolSize']);
          poolDigits = to_long(userinfo['poolDigits']);
          if (poolSize > 0) {
            poolEnd = poolStart + poolSize - 1;
          }
          else {
            poolEnd = poolStart;
          };
          suffix_format = "%0" + to_string(poolDigits) + "d";
          k = poolStart;
          while (k <= poolEnd) {
            uname = to_string(username) + format(suffix_format,k);
            SELF[account][length(SELF[account])] = uname;
            k = k + 1;
          };
        }
        else {
          uname = to_string(username);
          SELF[account][length(SELF[account])] = uname;
        };
      };
      SELF['GLEXEC_ACCOUNTS'][length(SELF['GLEXEC_ACCOUNTS'])] = account;
    };
  };

  SELF;
};


variable GLEXEC_CMD_PREFIX=CE_BATCH_SYS;

"/software/components/sudo/cmd_aliases" = {
  SELF['GLEXEC_CMDS'] = list('/bin/echo', '/bin/mkdir', '/bin/cp', '/bin/cat',
                             '/usr/bin/groups', '/usr/bin/whoami', '/bin/dd',
                             '/bin/mv', '/usr/bin/id', '/bin/kill',
                             '/usr/libexec/'+GLEXEC_CMD_PREFIX+'_submit.sh',
                             '/usr/libexec/'+GLEXEC_CMD_PREFIX+'_status.sh',
                             '/usr/libexec/'+GLEXEC_CMD_PREFIX+'_cancel.sh',
                             '/usr/libexec/'+GLEXEC_CMD_PREFIX+'_hold.sh',
                             '/usr/libexec/'+GLEXEC_CMD_PREFIX+'_resume.sh',
                             '/usr/bin/glite-cream-copyProxyToSandboxDir.sh',
                             '/usr/bin/glite-cream-createsandboxdir',
                             '/usr/bin/glite-ce-cream-purge-sandbox',
                             '/usr/bin/glite-ce-cream-purge-proxy',
                        );
  SELF;
};


#root    ALL=(ALL) ALL
#tomcat  ALL=(GLEXEC_ACCOUNTS) NOPASSWD: GLEXEC_CMDS
"/software/components/sudo/privilege_lines" = push(
    nlist ("user", "root",
           "run_as", "ALL",
           "host", "ALL",
           "cmd", "ALL"),
    nlist ("user", TOMCAT_USER,
           "run_as", "GLEXEC_ACCOUNTS",
           "host", "ALL",
           "options", "NOPASSWD:",
           "cmd", "GLEXEC_CMDS"),
);

#Defaults:tomcat        passwd_tries=0
"/software/components/sudo/general_options" = {
  next_record = length(SELF);
  SELF[next_record]['options']['passwd_tries'] = 0;
  SELF[next_record]['user'] = TOMCAT_USER;

  SELF;
};
