unique template features/htcondor/client/condorce/apel;


#
# By default the standard script in htcondor-ce-apel is used
# if apel_partial is true a different script is used which
# does not call apelclient and ssmsend. It is also possible to 
# customize things further redefining apel_script
#

variable CONDOR_CONFIG = {
    if(!is_defined(SELF['apel_partial']))
        SELF['apel_partial'] = true;

    if(!is_defined(SELF['apel_script'])){
        if(SELF['apel_partial']){
            SELF['apel_script'] = '/usr/share/condor-ce/condor_ce_apel_partial.sh';
        }else{
            SELF['apel_script']	= '/usr/share/condor-ce/condor_ce_apel.sh';
        };
    };

    if(!is_defined(SELF['apel_output_dir']))
        SELF['apel_output_dir'] = '/var/lib/condor-ce/apel';

    SELF;
};

#
# Apel config
#

include 'features/accounting/apel/parser_htcondorce';

#
# file in apel with the indications for the APEL cron defined in the schedd.
#

variable CONDOR_CONFIG = {

   # Adding the condor bdii config
   SELF['cfgfiles'] = append(SELF['cfgfiles'], dict(
            'name', 'apel',
            'contents', 'features/htcondor/templ/apel',
            'base_path', SELF['ce_cfgdir'],
        ));

   SELF;
};

#
# Script for partial publication.
#

include 'components/filecopy/config';

prefix '/software/components/filecopy/services/';

'{/usr/share/condor-ce/condor_ce_apel_partial.sh}' = dict(
    'config', file_contents('features/htcondor/templ/condor_ce_apel_partial.sh'),
    'perms', '0755',
);


#
# apel dir and logfiles ownerships to condor
#

include 'components/dirperm/config';

prefix "/software/components/dirperm/";

'paths' = push(
    dict('path', '/var/log/apelparser.log',
        'owner', 'condor:condor',
	'perm', '0664',
        'type', 'f'
    )
);

'paths' = push(
    dict('path', CONDOR_CONFIG['apel_output_dir'],
        'owner', 'condor:condor',
        'perm', '0755',
        'type', 'd'
    )
);


#
# Packages
#
include 'components/spma/config';

prefix '/software/packages';

'{htcondor-ce-apel}' = dict();