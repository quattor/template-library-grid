unique template features/htcondor/globus-fix;

include 'components/spma/config';

'/software/packages/' = {
  pkg_repl('globus-callout.x86_64');
  pkg_repl('globus-common.x86_64');
  pkg_repl('globus-ftp-control.x86_64');
  pkg_repl('globus-ftp-client.x86_64');
  pkg_repl('globus-gsi-callback.x86_64');
  pkg_repl('globus-gsi-cert-utils.x86_64');
  pkg_repl('globus-gsi-credential.x86_64');
  pkg_repl('globus-gsi-proxy-core.x86_64');
  pkg_repl('globus-gsi-sysconfig.x86_64');
  pkg_repl('globus-gss-assist.x86_64');
  pkg_repl('globus-gssapi-error.x86_64');
  pkg_repl('globus-gssapi-gsi.x86_64');
  pkg_repl('globus-io.x86_64');
  pkg_repl('globus-gsi-callback.x86_64');
  pkg_repl('globus-openssl-module.x86_64');
  pkg_repl('globus-gsi-openssl-error.x86_64');
  pkg_repl('globus-gsi-proxy-ssl.x86_64');
  pkg_repl('globus-xio.x86_64');
  pkg_repl('globus-gass-transfer.x86_64');
  pkg_repl('voms.x86_64');
  pkg_repl('voms.i686');

  SELF;
};
