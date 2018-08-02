structure template features/htcondor/templ/security;


'text' = {

    if(!is_defined(CONDOR_CONFIG)){
        error('CONDOR_CONFIG must be defined.')
    }; 

    if(!is_defined(CONDOR_CONFIG['allow'])){
        error('CONDOR_CONFIG[allow] must be defindes ad the DNS/IP domain authorizied to joing the cluster.');
    }; 

    if(is_defined(CONDOR_CONFIG['sec_daemon_authentication'])){
        sec_daemon_authentication = CONDOR_CONFIG['sec_daemon_authentication'];  
    }else{
        sec_daemon_authentication = 'required';  
    };

    if(is_defined(CONDOR_CONFIG['sec_client_authentication_method'])){
        sec_client_authentication_method = CONDOR_CONFIG['sec_client_authentication_method'];  
    }else{
       sec_client_authentication_method = 'password,fs,gsi';  
    };

    if(is_defined(CONDOR_CONFIG['sec_daemon_authentication_method'])){
       sec_daemon_authentication_method=CONDOR_CONFIG['sec_daemon_authentication_method'];  
    }else{
       sec_daemon_authentication_method='password';  
    };

    #building the string
    txt = "\nALLOW_WRITE = " + CONDOR_CONFIG['allow'] + "\n"; 

    if(is_defined(CONDOR_CONFIG['deny'])){
        txt = txt + "DENY_WRITE = " + CONDOR_CONFIG['deny'] + "\n";
    };

    txt = txt + "# This is to enforce password authentication\n";

    txt = txt + "SEC_DAEMON_AUTHENTICATION = " + sec_daemon_authentication + "\n";
    txt = txt + "SEC_DAEMON_AUTHENTICATION_METHODS = " + sec_daemon_authentication_method + "\n";
    txt = txt + "SEC_CLIENT_AUTHENTICATION_METHODS = " + sec_client_authentication_method + "\n\n";

    txt = txt + "SEC_PASSWORD_FILE = " + CONDOR_CONFIG['pwd_file'];

    txt = txt + <<EOF;

ALLOW_DAEMON = condor_pool@*
TRUST_UID_DOMAIN = TRUE

EOF

    if(is_defined(CONDOR_CONFIG['options'])&&is_defined(CONDOR_CONFIG['options']['security'])){
        foreach(i;opt;CONDOR_CONFIG['options']['security']){
            txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n";
        };
    };
	
    txt;
};