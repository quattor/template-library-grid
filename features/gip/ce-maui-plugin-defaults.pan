# This template creates a files with default values for some queue attributes.
# These defaults are used when attributes are not defined explicitly in the queue.
# This does not make sense to execute this template if lcg-info-dynamic-maui is
# not used on the current node.

unique template features/gip/ce-maui-plugin-defaults;

type maui_plugin_ce_defaults = {
  'MaxPhysicalMemory' : long
  'MaxProcessorsPerJob' : long
  'MaxVirtualMemory' : long
};
bind '/software/components/metaconfig/services/{${GIP_CE_MAUI_PLUGIN_DEFAULTS_FILE}}/contents' = maui_plugin_ce_defaults;
include 'components/metaconfig/config';
'/software/components/metaconfig' = {
  if ( !is_defined(SELF['dependencies']['post']) ) SELF['dependencies']['post'] = list();
  SELF['dependencies']['post'][length(SELF['dependencies']['post'])] = 'gip2';
  service_id = escape(GIP_CE_MAUI_PLUGIN_DEFAULTS_FILE);
  SELF['services'][service_id]['mode'] = 0600;
  SELF['services'][service_id]['owner'] = 'root';
  SELF['services'][service_id]['group'] = 'root';
  SELF['services'][service_id]['module'] = 'tiny';
  if ( is_defined(CE_DEFAULT_MAX_PHYS_MEM) ) {
    SELF['services'][service_id]['contents']['MaxPhysicalMemory'] = CE_DEFAULT_MAX_PHYS_MEM;
  };
  if ( is_defined(CE_DEFAULT_MAX_VIRT_MEM) ) {
    SELF['services'][service_id]['contents']['MaxVirtualMemory'] = CE_DEFAULT_MAX_VIRT_MEM;
  };
  if ( is_defined(CE_DEFAULT_JOB_MAX_PROCS) ) {
    SELF['services'][service_id]['contents']['MaxProcessorsPerJob'] = CE_DEFAULT_JOB_MAX_PROCS;
  };

  SELF;
};
'/software/components/gip2/dependencies/pre' = append('metaconfig');

