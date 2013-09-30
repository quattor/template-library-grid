unique template common/blparser/rpms/x86_64/config;

'/software/packages' = pkg_repl("glite-ce-blahp","1.18.0-4.sl5","x86_64");

#globus dependencies of blaph
#"/software/packages"=pkg_repl("globus-callout","2.2-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-common","11.6-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-callback","2.8-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-cert-utils","6.7-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-credential","3.5-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-proxy-core","4.7-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-sysconfig","3.1-4.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gss-assist","5.9-4.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gssapi-error","2.5-7.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gssapi-gsi","7.6-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-openssl","5.1-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-openssl-error","0.14-8.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","2.3-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-libtool","1.2-4.el5","x86_64");
#"/software/packages"=pkg_repl("globus-openssl-module","1.3-3.el5","x86_64");

include { 'common/globus/rpms/config' };

"/software/packages"=pkg_repl("classads","1.0.8-1.el5","x86_64");

#'/software/packages' = pkg_repl('gpt','3.2autotools2004_NMI_9.0_x86_64_rhap_5-1','x86_64'); #NOT FOUND
