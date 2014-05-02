# Configure GIP for a resource BDII

unique template feature/gip/bdii;

include { 'components/gip2/config' };

# Define GIP base configuration
include { 'feature/gip/base' };

# List trusted (RPM provided) files
'/software/components/gip2/external' ?= list();
'/software/components/gip2/external' = {
    if (! is_list(SELF)) {
        error('/software/components/gip2/external must be an list');
    };
    append(escape(GIP_LDIF_DIR + '/default.ldif')); 
};
