unique template glite/voms/rpms/x86_64/mysql;

variable SL_VARIANT ?= 'el5';

"/software/packages"= {
  pkg_repl('emi-voms-mysql',              '1.0.1-1.el5', 'x86_64');
  pkg_repl('yaim-voms',                   '1.1.1-1.el5', 'noarch');
  pkg_repl('voms-admin-server',           '3.0.0-1.el5', 'noarch');
  pkg_repl('voms-admin-client',           '2.0.18-1.el5','noarch');
  pkg_repl('glite-info-provider-service', '1.12.0-1.el5', 'noarch');
  pkg_repl('voms-server',                 '2.0.10-1.el5', 'x86_64');
  pkg_repl('voms-mysql-plugin',           '3.1.6-1.el5', 'x86_64');
  pkg_repl('bdii',                        '5.2.17-1.el5','noarch');
  pkg_repl('glue-schema',                 '2.0.10-1.el5', 'noarch');
  pkg_repl('glite-yaim-bdii',             '4.3.13-1.el5', 'noarch');
  pkg_repl('emi-trustmanager',            '3.1.3-1.sl5', 'noarch');
  pkg_repl('emi-trustmanager-tomcat',     '3.0.1-1.sl5', 'noarch');
  pkg_repl('voms',                        '2.0.10-1.el5', 'x86_64');
  pkg_repl('glite-yaim-core',             '5.1.1-1.sl5', 'noarch');
  SELF;
};

include { 'config/emi/2.0/voms' };
