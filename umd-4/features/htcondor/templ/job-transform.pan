structure template features/htcondor/templ/job-transform;

'text' = {
    fmtstr = "JOB_TRANSFORM_%s @=end\n[\n%s\n]\n@end\n";

    txt = "";

    txt = txt + 'JOB_TRANSFORM_NAMES =';

    foreach (name; rule; CONDOR_CONFIG['job-transform']) {
        txt = txt + ' ' + name;
    };

    txt = txt + "\n";

    foreach (name; body; CONDOR_CONFIG['job-transform']) {
        txt = txt + format(fmtstr, name, body)
    };

    txt = txt + "\n";

    txt;
};