declaration template features/yaim/functions;

include { 'functions/text' };

#
# yaim_set_queue_access:    evaluate the contents of an nlist(queue,access)
#                           and add the queues and their access roles
#                           to the Yaim config:
#                               conf/QUEUES
#                               extra/<Q>_GROUP_ENABLE
# parameters:               qdef - nlist, mandatory
# return:                   value for path /software/components/yaim/
#
function yaim_set_queue_access = {
    x = SELF;
    if ( ARGC == 1 ) {
        qdef = ARGV[0];

        if ( ! is_nlist(qdef) ) {
            error("Argument #1 for yaim_set_queue_access must be an nlist");
        };
    };
    if ( length( qdef ) == 0 ) {
        # empty list
        return( x );
    };

        qlist = "";
        foreach( queue; acl; qdef ) {
            t = "";
            foreach( i; group; acl ) {
                if ( substr( group, 0, 1 ) == "/" ) {
                    # VOMS FQAN
                    if ( show_vo_view_for_fqan( group ) ) {
                        t = t + group + " ";
                    };
                }
                else {
                    # VO
                    if ( exists( VO_CONFIG[group] ) ) {
                        t = t + group + " ";
                        u = get_voview_fqans_for_vo( group );
                        if ( length( u ) > 0 ) {
                            t = t + u;
                        };
                    };
                };
            };
            if ( t != "" ) {
                qvar = to_upper(queue) + "_GROUP_ENABLE";
                x['extra'][qvar] = substr( t, 0, -1 );
                debug("ACL for " + queue + " = " + t);
                qlist = qlist + queue + " ";
            };
        };
        x['conf']['QUEUES'] = substr( qlist, 0, -1 );
    x;
};


#
# show_vo_view_for_fqan     returns true if the argument is present in VO_VIEW
#                           false if it is not present
# requires                  VO_VIEW to be defined as list()
#
function show_vo_view_for_fqan = {
    fqan = ARGV[0];
    foreach( i; myfqan; VO_VIEW ) {
        if ( fqan == myfqan ) {
            return( true );
        };
    };
    false;
};


#
# get_voview_fqans_for_vo   find all groups and roles in the VO passed as argument
#                           that are present in the list VO_VIEW
# return                    string of found FQANs, separated by whitespace
#
function get_voview_fqans_for_vo = {
    vo = ARGV[0];
    if ( ! exists( VO_CONFIG[vo] ) ) {
        debug( "VO_CONFIG does not contain definition for VO " + vo );
        return("");
    };
    t = "";
    foreach( i; grpcfg; VO_CONFIG[vo]['mapping'] ) {
        fqan = unescape( grpcfg['fqan'] );
        if ( show_vo_view_for_fqan( fqan ) ) {
            t = t + fqan + " ";
        };
    };
    t;
};



function yaim_set_queue_close_se_list = {
    x = SELF;
    if ( ARGC == 1 ) {
        qdef = ARGV[0];
        if ( ! is_nlist(qdef) ) {
            error("Argument #1 for yaim_set_queue_access must be an nlist");
        };
        ok = first(qdef,k,v);
        while ( ok ) {
            qvar = "QUEUE_" + to_upper(k) + "_SE_LIST";
            x['extra'][qvar] = v;
            ok = next(qdef,k,v);
        };
    };
    return(x);
};


#
# yaim_set_node_types:  evaluate the contents of a list and add the
#                       values to Yaim's nodetypes
# parameters:           nodetypes - list
# return:               value for path /software/components/yaim/
#
function yaim_set_node_types = {
    if ( ARGC != 1 ) {
        error("Function yaim_set_node_types requires 1 arguments");
    };

    nodetypes = ARGV[0];
    if ( ! is_list(nodetypes) ) {
        error("Argument nodetypes for function yaim_set_node_types must be a list");
    };

    x = SELF;
    ok = first(nodetypes,k,v);
    while ( ok ) {
        x['nodetype'][v] = true;
        ok = next(nodetypes,k,v);
    };
    return(x);
};




#
# yaim_user_line:       format line for users.conf
#
# arguments:            <nlist VO-cfg> <string VO-name>
#
# return:               string formatted for inclusion in users.conf
#
function yaim_user_line = {
    if ( ARGC != 2 ) {
        error("yaim_user_line requires 2 arguments");
    };
    if ( ! is_nlist( ARGV[0] ) ) {
        error("yaim_user_line: argument 1 must be nlist" );
    };
    cfg = ARGV[0];
    vo = ARGV[1];

    # format: uid:user:gid1[,gid2]:group1[,group2]:vo:flag
    line = "0:" + cfg['account'] + ":";

    n = length( cfg['group'] );
    groups = "";
    gids = "";
    # Add groups and gid info. The gid is unused since we don't create the users.
    # Still Yaim validates the lines by comparing the number of
    # commas in groups and gids, so let's make sure they match and use gid=0!
    for ( i=0; i<n; i=i+1 ) {
        groups = groups + cfg['group'][i] + ",";
        gids   = gids + "0,";
    };

    line = line + substr(gids,0,-1) + ":" + substr(groups,0,-1) + ":" + vo + ":";
    if ( exists( cfg['flag'] ) ) {
        line = line + cfg['flag'];
    };
    line = line + ":";

    line;
};


#
# yaim_group_line:  format line for Yaim groups.conf
#
# arguments:            <nlist VO-cfg>
#
# return:               string formatted for inclusion in groups.conf
#
function yaim_group_line = {
    if ( ARGC != 1 ) {
        error("yaim_group_line requires 1 argument");
    };
    if ( ! is_nlist( ARGV[0] ) ) {
        error("yaim_group_line: argument 1 must be nlist" );
    };
    cfg = ARGV[0];
    line = "\"" + unescape( cfg['fqan'] ) + "\":::";
    if ( exists( cfg['flag'] ) ) {
        line = line + cfg['flag'];
    };
    line = line + ":";
    line;
};
