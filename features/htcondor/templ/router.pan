structure template features/htcondor/templ/router;

'text' = {

    txt = <<EOF;
#SCHEDD_DEBUG = D_FULLDEBUG
#JOB_ROUTER_DEBUG = D_FULLDEBUG

JOB_ROUTER_HOOK_KEYWORD = MyHook
EOF


    txt = txt + "MyHook_HOOK_TRANSLATE_JOB = " + CONDOR_CONFIG['ce_cfgdir'] + '/hook.py' + "\n";

    txt;
};