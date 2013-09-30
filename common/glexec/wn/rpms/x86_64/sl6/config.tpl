unique template common/glexec/wn/rpms/x86_64/sl6/config;

include { 'components/spma/config' };

'/software/packages'=pkg_repl('emi-glexec_wn','1.1.1-2.sl6','x86_64');

'/software/packages'={
  pkg_repl("lcmaps-plugins-voms","1.5.3-1.el6","x86_64");
  pkg_repl("lcmaps-plugins-verify-proxy","1.5.2-1.el6","x86_64");
  pkg_repl("lcmaps","1.5.5-1.el6","x86_64");
  pkg_repl("glexec-wrapper-scripts","0.0.6-1.el6","noarch");
  pkg_repl('nagios-plugins-emi.glexec','0.3.0-1.sl6','noarch');
#  pkg_repl("saml2-xacml2-c-lib","1.0.1-1.sl6","x86_64");
  pkg_repl("lcas-plugins-voms","1.3.10-1.el6","x86_64");
  pkg_repl("lcas-plugins-basic","1.3.6-1.el6","x86_64");
  pkg_repl("mkgltempdir","0.0.3-2.el6","noarch");
  pkg_repl("yaim-glexec-wn","2.3.2-1.sl6","noarch");
  pkg_repl("edg-mkgridmap",'4.0.0-1','noarch');
  pkg_repl("argus-pep-api-c","2.1.0-3.sl6","x86_64");
  pkg_repl("lcas-plugins-check-executable","1.2.4-1.el6","x86_64");
  pkg_repl("lcas","1.3.18-2.el6","x86_64");
  pkg_repl("lcmaps-plugins-c-pep","1.2.2-1.el6","x86_64");
#  pkg_repl("lcmaps-plugins-scas-client","0.2.22-1.sl6","x86_64");
  pkg_repl("glexec","0.9.6-1.el6","x86_64");
  pkg_repl("lcmaps-plugins-tracking-groupid","0.1.0-1.el6","x86_64");
  pkg_repl("lcmaps-plugins-basic","1.5.0-3.el6","x86_64");
};
