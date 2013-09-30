unique template common/glexec/wn/rpms/x86_64/sl5/config;

include { 'components/spma/config' };

'/software/packages'=pkg_repl('emi-glexec_wn','1.1.1-2.sl5','x86_64');

'/software/packages'={
  pkg_repl("lcmaps-plugins-voms","1.5.5-1.el5","x86_64");
  pkg_repl("lcmaps-plugins-verify-proxy","1.5.4-1.el5","x86_64");
  pkg_repl("lcmaps","1.5.7-1.el5","x86_64");
  pkg_repl("glexec-wrapper-scripts","0.0.7-1.el5","noarch");
  pkg_repl('nagios-plugins-emi.glexec','0.3.0-1.sl5','noarch');
#  pkg_repl("saml2-xacml2-c-lib","1.0.1-1.sl5","x86_64");
  pkg_repl("lcas-plugins-voms","1.3.11-1.el5","x86_64");
  pkg_repl("lcas-plugins-basic","1.3.6-2.el5","x86_64");
  pkg_repl("mkgltempdir","0.0.3-4.el5","noarch");
  pkg_repl("yaim-glexec-wn","2.3.3-2.el5","noarch");
  pkg_repl("edg-mkgridmap",'4.0.0-1','noarch');
  pkg_repl("argus-pep-api-c","2.2.0-1.el5","x86_64");
  pkg_repl("lcas-plugins-check-executable","1.2.4-2.el5","x86_64");
  pkg_repl("lcas","1.3.19-2.el5","x86_64");
  pkg_repl("lcmaps-plugins-c-pep","1.2.3-1.el5","x86_64");
#  pkg_repl("lcmaps-plugins-scas-client","0.2.22-1.sl5","x86_64");
  pkg_repl("glexec","0.9.8-1.el5","x86_64");
  pkg_repl("lcmaps-plugins-tracking-groupid","0.1.0-2.el5","x86_64");
  pkg_repl("lcmaps-plugins-basic","1.5.1-2.el5","x86_64");
};
