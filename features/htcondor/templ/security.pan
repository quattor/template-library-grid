structure template features/htcondor/templ/security;


'text' = {
    if (!is_defined(CONDOR_CONFIG)) {
        error('CONDOR_CONFIG must be defined.')
    };

    if (!is_defined(CONDOR_CONFIG['allow'])) {
        error('CONDOR_CONFIG[allow] must be defindes ad the DNS/IP domain authorizied to joing the cluster.');
    };

     #building the string
    txt = <<EOF;

EOF
    txt = txt + "ALLOW_WRITE = " + CONDOR_CONFIG['allow'];

    txt = txt + <<EOF;

# This is to enforce password authentication
SEC_DAEMON_AUTHENTICATION = required
SEC_DAEMON_AUTHENTICATION_METHODS = password
SEC_CLIENT_AUTHENTICATION_METHODS = password,fs,gsi

EOF

    txt = txt + "SEC_PASSWORD_FILE = " + CONDOR_CONFIG['pwd_file'];

    txt = txt + <<EOF;

ALLOW_DAEMON = condor_pool@*
TRUST_UID_DOMAIN = TRUE

EOF

    txt;
};

