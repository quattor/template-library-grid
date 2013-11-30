unique template common/mkgridmap/rpms;

'/software/packages'=pkg_repl('edg-mkgridmap','4.0.0-1','noarch');

# OS specific dependencies
include { 'config/emi/' + EMI_VERSION + '/mkgridmap' };
