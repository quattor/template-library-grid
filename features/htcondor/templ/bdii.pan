structure template features/htcondor/templ/bdii;

'text' = {

    vos = replace('\[ ', '', replace(' \]', '', to_string(VOS)));

    txt = "HTCONDORCE_VONames = " + vos + "\n";
    
    txt = txt + "HTCONDORCE_SiteName = " + CONDOR_CONFIG['site_name'] + "\n";

    txt = txt + "HTCONDORCE_SPEC = [ specfp2000 = " + CE_SF00 + "; hep_spec06 = " + CE_HEPSPEC06 + "; specint2000 = " + CE_SI00 + " ]\n";

    txt = txt + "HTCONDORCE_CORES = 16\n";

    txt = txt + "GLUE2DomainID = " + CONDOR_CONFIG['site_name'] + "\n";

    txt;
};