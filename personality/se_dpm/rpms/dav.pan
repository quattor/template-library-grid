unique template personality/se_dpm/rpms/dav;

prefix '/software/packages';

'{lcgdm-dav-server}' ?= nlist();
'{lcgdm-dav-libs}' ?= nlist();
'{lcgdm-dav}' ?= nlist();
'{gridsite-libs}' ?= nlist();
'{gridsite-apache}' ?= nlist();

'{httpd}' ?= nlist();

'{mod_dav_svn}' = null;
'{mod_nss}' = null;
'{mod_revocator}' = null;
