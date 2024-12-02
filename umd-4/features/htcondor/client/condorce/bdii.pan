unique template features/htcondor/client/condorce/bdii;

include 'components/spma/config';

'/software/packages/{htcondor-ce-bdii}' = dict();

variable CONDOR_CONFIG = {

    # Adding the condor bdii config
    SELF['cfgfiles'] = append(SELF['cfgfiles'], dict(
        'name', 'bdii',
        'contents', 'features/htcondor/templ/bdii',
    ));

    SELF;
};


#Changing the default as the current provider has no caching
variable BDII_BREATHE_TIME ?= 600;

include 'personality/bdii/service';

# Also build queue names (required by CE GIP configuration) if not done as part of the client configuration
include if ( LRMS_SERVER_HOST != FULL_HOSTNAME )
    if_exists("features/" + CE_BATCH_NAME + "/server/build-queue-list");


include 'components/gip2/config';

prefix '/software/components/gip2';

'external' = push(escape('/var/lib/bdii/gip/provider/htcondor-ce-provider'));

'provider/htcondor-ce-provider-glue1' = file_contents('features/htcondor/templ/htcondor-ce-provider-glue1');

