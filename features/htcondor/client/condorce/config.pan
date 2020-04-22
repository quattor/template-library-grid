unique template features/htcondor/client/condorce/config;

include 'features/htcondor/client/condorce/params';

variable CONDOR_CONFIG = {

   # Adding the file router configuration
   SELF['cfgfiles'] = append(SELF['cfgfiles'], dict( 
            'name', 'router', 
            'contents', 'features/htcondor/templ/router',
            'base_path', SELF['ce_cfgdir'],
        ));

   # The bdii publication point(s)
   SELF['bdii_active'] = (
       (!is_defined(SELF['resource_bdii'])) ||
       (index(FULL_HOSTNAME, SELF['resource_bdii']) >= 0)
   ); 

    
   SELF;
};



include 'components/filecopy/config';
'/software/components/filecopy/services' = {

# ... the file router hook 
    SELF[escape(CONDOR_CONFIG['ce_cfgdir'] + '/hook.py')] = dict(

        'config', file_contents(CONDOR_CONFIG['router_hook']),
        'perms', '0755',
        'restart', 'service condor-ce restart',
    );

# ... and the mapping file
    content = create('features/htcondor/templ/condor_mapfile');

    SELF[escape(CONDOR_CONFIG['ce_cfgdir'] + '/condor_mapfile')] = dict(

        'config', content['text'],
        'perms', '0644',
        'restart', 'service condor-ce restart',
    );        

    SELF;
};

# TODO: add condor-ce to the restart

include 'components/spma/config';

prefix '/software/packages';
'{htcondor-ce}' = dict();
'{htcondor-ce-condor}' = dict();
'{htcondor-ce-client}' = dict();


include 'components/systemd/config';

'/software/components/systemd/unit/{condor-ce}' = dict();


include 'users/glite';

include 'features/grid/dirperms';

include if(CONDOR_CONFIG['bdii_active']) 'features/htcondor/client/condorce/bdii';

include 'features/globus/sysconfig';

include 'features/edg/sysconfig';

include 'features/htcondor/client/condorce/auth';

include 'features/htcondor/client/condorce/apel';
