unique template vo/functions;

variable VO_SW_TAGS_DIR ?= GLITE_LOCATION_VAR + '/info';

# Variable to select between legacy and new account suffixes.
# Default: legacy suffixes for backward compatibility
variable VO_USE_LEGACY_ACCOUNT_SUFFIX ?= true;

# Variable to select whether to use VO group or FQAN group as primary group
# for FQAN pool accounts. In any case, both groups are in the group list.
# Default: VO group.
# Note that using FQAN group may require additional LRMS configuration.
variable VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP ?= false;

#
# FQAN is not primary group but groupmapfile refere to FQAN
#
variable LCMAPS_ADD_GIDS_FROM_MAPPED_ACCOUNTS ?= true;

function add_vo_infos = {

    function_name = "add_vo_infos";

    vo = ARGV[0];
    vo_params = VO_PARAMS;
    result = dict();
    auth_uri = list();
    fqan_mapping = list();
    sw_mgr_found = false;

    debug("Starting configuration of VO " + vo);

    # Define default values for some properties.
    # These defaults must never been referenced directly but through vo_params[vo].
    # They are all merged in vo_params[vo] at the beginning of this function.
    defaults['create_keys'] = CREATE_KEYS;
    defaults['create_home'] = CREATE_HOME;
    defaults['is_prefix'] = false;                # Interpret the account suffix as a prefix!
    defaults['pool_digits'] = 3;                  # Number of digits to add after the account base name for pool accounts
    defaults['pool_start'] = 0;                   # pool_start is used to handle special numbering schemes, for example starting at 1 rather than 0
    defaults['pool_size'] = 200;                  # Default pool size for normal accounts
    defaults['pool_offset'] = 5;                  # First UID in the VO range to use for normal accounts
    defaults['fqan_pool_size'] = 1;               # Number of accounts per role to create (if > 1, use pool accounts
    defaults['pilot_descr'] = 'pilot';            # Must match description used for FQAN dedicated to pilot jobs in VO parameters
    defaults['production_descr'] = 'production';  # Must match description used for production jobs in VO parameters
    defaults['sw_manager_descr'] = 'SW manager';  # Must match description used for SW mgrs in VO parameters
    defaults['sw_manager_offset'] = 0;            # UID offset in the VO range (when not using pool accounts for this role)
    defaults['production_offset'] = 1;            # UID offset in the VO range (when not using pool accounts for this role)
    defaults['pilot_offset'] = 2;                 # UID offset in the VO range (when not using pool accounts for this role)
    defaults['sw_manager_suffix'] = 's';          # Normally defined in VO params but needed if a VO has no SW manager defined
    defaults['account_range'] = 999;              # Maximum number of accounts usable by the VO
    defaults['account_shell'] = VO_ACCOUNT_SHELL; # Default shell for VO accounts
    defaults['unlock_accounts'] = ';';            # Regular expression to match with FULL_HOSTNAME. Default can't match.

    # Load site defaults if any: they override hardcoded defaults.
    # For DEFAULT entry, there is no default template loaded. The entry must be
    # either a dict or a template name.
    if ( is_defined(VOS_SITE_PARAMS["DEFAULT"]) ) {
        if (is_dict(VOS_SITE_PARAMS["DEFAULT"])) {
            site_defaults = VOS_SITE_PARAMS["DEFAULT"];
        } else {
            site_defaults = create(VOS_SITE_PARAMS["DEFAULT"]);
        };
        foreach (k; v; site_defaults) {
            if ( match(k, 'account_prefix|base_uid|gid|name|voms_servers|voms_roles|voms_mappings') ) {
                error('Parameter ' + k + ' not allowed in VO parameter defaults');
            };
            defaults[k] = site_defaults[k];
        };
    };

    # Extract the VOMS mappings from VO params and ensure it is defined as a list.
    # Backward compatibility ('voms_roles' renamed 'voms_mappings')
    if ( is_defined(vo_params[vo]['voms_mappings']) ) {
        voms_mappings_tmp = vo_params[vo]['voms_mappings'];
    } else {
        if ( is_defined(vo_params[vo]['voms_roles']) ) {
            voms_mappings_tmp = vo_params[vo]['voms_roles'];
        };
        # To help further processing
        if ( !is_defined(voms_mappings_tmp) ) {
            voms_mappings_tmp = list();
        };
    };
    debug('Standard VOMS mapping definitions = ' + to_string(voms_mappings_tmp));

    # Extract the VOMS server list from VO params and ensure it is defined as a list.
    if ( is_defined(vo_params[vo]['voms_servers']) ) {
        if ( is_list(vo_params[vo]['voms_servers']) ) {
            voms_servers = vo_params[vo]['voms_servers'];
        } else {
            voms_servers = list(vo_params[vo]['voms_servers']);
        };
    } else {
        voms_servers = list();
    };
    debug('Standard VOMS server list = ' + to_string(voms_servers));

    # Load site parameters for the VO.
    # The VO entry in VOS_SITE_PARAMS. In this case can be either a template name (string)
    # in which case it REPLACES the default site template for VO params or a list in which
    # case it SUPPLEMENTS the default site template for VO params.
    # Check if there is an entry for the VO alias, if any, if tere is no entry for the VO full name.
    #
    # Site parameters override standard parameters, except voms_servers and voms_mappings
    # entries which are processed specifically.
    # For voms_servers, the list is not replaced, instead parameters for each VOMS server
    # are merged. This avoid to redefine the VOMS server list in site params. If the VOMS
    # server in site params is identified by the 'host' parameter and this host doesn't
    # exist in standard params, a new entry is added. If the entry is identified by the
    # 'name' parameter and there is no matching entry in the standard params, the site entry is ignored.
    # For voms_mappings, the same processing applies with 'host' replaced by 'fqan' and 'name'
    # replaced by 'description'.

    vo_site_params = undef;
    if ( is_defined(VOS_SITE_PARAMS[vo]) ) {
        vo_site_params = VOS_SITE_PARAMS[vo];
    } else if ( is_defined(VOS_ALIASES[vo]) && is_defined(VOS_SITE_PARAMS[VOS_ALIASES[vo]]) ) {
        vo_site_params = VOS_SITE_PARAMS[VOS_ALIASES[vo]];
    };
    if ( is_string(vo_site_params) ) {
        # If an explicit name was given, the template MUST exist
        site_vo_params = create(vo_site_params);
    } else {
        vo_site_params_template = if_exists('vo/site/' + vo);
        if ( !is_defined(vo_site_params_template) && is_defined(VOS_ALIASES[vo]) ) {
            vo_site_params_template = if_exists('vo/site/' + VOS_ALIASES[vo]);
        };
        if ( is_defined(vo_site_params_template) ) {
            site_vo_params = create(vo_site_params_template);
        };
    };

    # Merge parameters specified as a dict if any.
    # Every attribute specified in the dict replaces the same attribute from the template, if present.
    if ( is_dict(vo_site_params) ) {
        if ( !is_defined(site_vo_params) ) {
            site_vo_params = dict();
        };
        foreach (k; v; vo_site_params) {
            site_vo_params[k] = v;
        };
    };
    if ( is_defined(site_vo_params) ) {
        # Merge all parameters except voms_servers and voms_mappings
        foreach (k; v; site_vo_params) {
            if ( (k != 'voms_servers') && (k != 'voms_mappings') ) {
                # Some parameters may change from string to list/dict or vice-versa
                if ( is_defined(vo_params[vo][k]) ) {
                    vo_params[vo][k] = undef;
                };
                vo_params[vo][k] = site_vo_params[k];
            };
        };

        # Merge voms_servers if present
        if ( is_defined(site_vo_params['voms_servers']) ) {
            new_voms_servers = list();
            foreach (i; site_server; site_vo_params['voms_servers']) {
                voms_server_selector = undef;
                if ( is_defined(site_server['host']) ) {
                    voms_server_selector = 'host';
                } else if ( is_defined(site_server['name']) ) {
                    voms_server_selector = 'name';
                } else {
                    error(
                        "VO " + vo + ": site parameters contain an invalid " +
                        "VOMS server entry ('host' and 'name' both undefined)"
                    );
                };
                found = false;
                ok = first(voms_servers, i, std_server);
                while ( ok && !found ) {
                    if ( !is_defined(std_server[voms_server_selector]) ) {
                        error(
                            "VO " + vo + ": '" + voms_server_selector +
                            "' parameter missing for VOMS server entry " +
                            to_string(std_server)
                        );
                    } else if ( std_server[voms_server_selector] == site_server[voms_server_selector] ) {
                        found = true;
                    } else {
                        ok = next(voms_servers, i, std_server);
                    };
                };
                if ( found ) {
                    foreach (param; value; site_server) {
                        voms_servers[i][param] = value;
                    };
                } else if ( voms_server_selector == 'host' ) {
                    new_voms_servers[length(new_voms_servers)] = site_server;
                };
            };
            if ( length(new_voms_servers) > 0 ) {
                voms_servers = merge(voms_servers, new_voms_servers);
            };
        };

        # Merge voms_mappings if present
        if ( is_defined(site_vo_params['voms_mappings']) ) {
            new_voms_mappings = list();
            foreach (i; site_mapping; site_vo_params['voms_mappings']) {
                voms_mapping_selector = undef;
                if ( is_defined(site_mapping['fqan']) ) {
                    voms_mapping_selector = 'fqan';
                } else if ( is_defined(site_mapping['description']) ) {
                    voms_mapping_selector = 'description';
                } else {
                    error(
                        "VO " + vo + ": site parameters contain an invalid " +
                        "VOMS mapping definition ('fqan' and 'description' both undefined)"
                    );
                };
                found = false;
                ok = first(voms_mappings_tmp, i, std_mapping);
                while ( ok && !found ) {
                    if ( !is_defined(std_mapping[voms_mapping_selector]) ) {
                        error(
                            "VO " + vo + ": '" + voms_mapping_selector +
                            "' parameter missing for VOMS mapping entry " +
                            to_string(std_mapping)
                        );
                    } else if ( std_mapping[voms_mapping_selector] == site_mapping[voms_mapping_selector] ) {
                        found = true;
                    } else {
                        ok = next(voms_mappings_tmp, i, std_mapping);
                    };
                };
                if ( found ) {
                    foreach (param; value; site_mapping) {
                        voms_mappings_tmp[i][param] = value;
                    };
                } else if ( voms_mapping_selector == 'fqan' ) {
                    new_voms_mappings[length(new_voms_mappings)] = site_mapping;
                };
            };
            if ( length(new_voms_mappings) > 0 ) {
                voms_mappings_tmp = merge(voms_mappings_tmp, new_voms_mappings);
            };
        };
    };

    # Do some normalization and checks on final mapping list
    voms_mappings = list();
    mapping_num = 0;
    account_mapping_number = dict();
    foreach (i; mapping; voms_mappings_tmp) {
        add_mapping = true;
        # Ensure mapping['enabled'] is defined at this point for ease further processing. Assume enabled by default.
        if ( !is_defined(mapping['enabled']) ) {
            mapping['enabled'] = true;
        };
        if ( mapping['enabled'] ) {
            if ( !is_defined(mapping['description']) || !is_defined(mapping['suffix']) ) {
                error(
                    function_name + ': missing mapping suffix or description in mapping number ' +
                    to_string(j)
                );
            };
            if ( !is_defined(mapping['fqan']) ) {
                error(
                    function_name + ': missing VOMS FQAN for VO ' + vo_name +
                    ' role ' + mapping['description']
                );
            } else if ( !is_string(mapping['fqan']) ) {
                error(
                    function_name + ": 'fqan' attribute is not a string for VO " +
                    vo_name + " group/role " + mapping['description']
                );
            };
            if ( !VO_USE_LEGACY_ACCOUNT_SUFFIX ) {
                if ( is_defined(mapping['suffix2']) ) {
                    mapping['suffix'] = mapping['suffix2'];
                } else {
                    error(
                        "VO " + vo + ": new account suffix enabled but 'suffix2' attribute not present for FQAN " +
                        to_string(mapping['fqan'])
                    );
                };
            };
            # Convert 'fqan' attribute (which MUST be a string) to a list as the processing code below assumes it is
            #a list. This allows grouping all FQANs mapped to the same account into one mapping.
            if ( is_defined(account_mapping_number[mapping['suffix']]) ) {
                previous_mapping = account_mapping_number[mapping['suffix']];
                debug(
                    "FQAN " + mapping['fqan'] + ": merge with mapping number " +
                    to_string(previous_mapping) + " which uses the same account suffix (" +
                    mapping['suffix'] + ")"
                );
                voms_mappings[previous_mapping]['fqan'][length(voms_mappings[previous_mapping]['fqan'])] = mapping['fqan'];
                add_mapping = false;
            } else {
                mapping_fqan = list(mapping['fqan']);
                mapping['fqan'] = undef;
                mapping['fqan'] = mapping_fqan;
            };
        } else {
            debug('VOMS mapping disabled for FQAN ' + to_string(mapping['fqan']));
        };
        if ( add_mapping ) {
            # Keep disabled mappings in the list to avoid UID changes when enabling/disabling
            voms_mappings[length(voms_mappings)] = mapping;
            account_mapping_number[mapping['suffix']] = mapping_num;
            mapping_num = mapping_num + 1;
        };
    };

    debug('Final VOMS server list = ' + to_string(voms_servers));
    debug('Final VOMS mapping definitions = ' + to_string(voms_mappings));

    # Override VO parameters by those specified in 'LOCAL' entry, if any.
    # 'LOCAL' entry is the way to override some parameters with local values
    # for all VOs, whatever has been done before.

    if ( is_defined(VOS_SITE_PARAMS["LOCAL"]) ) {
        if (is_dict(VOS_SITE_PARAMS["LOCAL"])) {
            site_defaults = VOS_SITE_PARAMS["LOCAL"];
        } else {
            site_defaults = create(VOS_SITE_PARAMS["LOCAL"]);
        };
        foreach (k; v; site_defaults) {
            if ( match(k, 'account_prefix|base_uid|gid|name|voms_servers|voms_roles|voms_mappings') ) {
                error('Parameter ' + k + ' not allowed in VO parameter LOCAL entry');
            };
            # Some parameters may change from string to list/dict or vice-versa
            if ( is_defined(vo_params[vo][k]) ) {
                vo_params[vo][k] = undef;
            };
            vo_params[vo][k] = site_defaults[k];
        };
    };

    # Apply defaults to VO parameters.
    # Every default attribute not yet defined in VO parameter is added.

    foreach (param; default_value; defaults) {
        if ( !exists(vo_params[vo][param]) || !is_defined(vo_params[vo][param]) ) {
            vo_params[vo][param] = default_value;
        };
    };

    # Check existence of some required parameters and set some other defaults

    # Real name of the virtual organization.
    # 'vo' can be an alias, 'vo_name' is the real name of the VO: use the right one in each context!
    if ( is_defined(vo_params[vo]['name']) ) {
        vo_name = vo_params[vo]['name'];
        result['name'] = vo_name;
        if ( vo_name != vo ) {
            debug("Real VO name = " + vo_name);
        };
    } else {
        error('Name undefined for VO ' + vo);
    };

    # Account prefix for the VO
    if ( is_defined(VOS_ACCOUNT_PREFIX[vo_name]) ) {
        vo_params[vo]['account_prefix'] = VOS_ACCOUNT_PREFIX[vo_name];
    } else {
        if ( !exists(vo_params[vo]['account_prefix']) && !is_defined(vo_params[vo]['account_prefix']) ) {
            error('Pool account prefix undefined for VO ' + vo);
        };
    };
    result['prefix'] = vo_params[vo]['account_prefix'];

    # Group for the VO
    if ( is_defined(vo_params[vo]['group']) ) {
        vo_group = vo_params[vo]['group'];
    } else {
        vo_group = vo;
    };
    result['group'] = vo_group;

    # Base uid and GID of the virtual organization.
    if ( is_defined(VOS_BASE_UID[vo_name]) ) {
        vo_params[vo]['base_uid'] = VOS_BASE_UID[vo_name];
    } else {
        if ( !exists(vo_params[vo]['base_uid']) || !is_defined(vo_params[vo]['base_uid']) ) {
            error('Base uid undefined for VO ' + vo);
        };
    };

    base_uid_pool = vo_params[vo]['base_uid'] + vo_params[vo]['pool_offset'];

    if ( is_defined(VOS_BASE_GID[vo_name]) ) {
        vo_gid = VOS_BASE_GID[vo_name];
    } else if ( is_defined(vo_params[vo]['gid'])) {
        vo_gid = vo_params[vo]['gid'];
    } else {
        # By default, vo_gid is base_uid_pool for backward compatibility
        vo_gid = base_uid_pool;
    };

    # Define password hash (to something that cannot match) and set the
    # lock flag if necessary.
    if (match(FULL_HOSTNAME, vo_params[vo]['unlock_accounts'])) {
        # Unlocked account
        vo_account_pass = '*NP*';
    } else {
        # If gsissh must be enabled for the VO, this is considered an error.
        # This should not happen on a VOBOX as the VOBOX standard config enforces the appropriate entries.
        if ( (is_defined(VOBOX_ENABLED_VOS) && (index(vo, VOBOX_ENABLED_VOS) > 0)) ||
            (is_defined(GSISSH_SERVER_ENABLED) && GSISSH_SERVER_ENABLED && (index(vo, GSISSH_SERVER_VOS) > 0))
        ) {
            error(
                'VO ' + vo + ' unlock_account (' + vo_params[vo]['unlock_accounts'] +
                ') conflicts with gsissh requirements. Check VOS_SITE_PARAMS[' + vo +
                ']["unlock_accounts"] and VOS_SITE_PARAMS["DEFAULT"].');
            };
        # Locked account
        vo_account_pass = '!*NP*';
    };

    # Configure  VO-specific services (MyProxy, ...)
    if ( is_defined(vo_params[vo]['proxy']) ) {
        result['services']['myproxy'] = vo_params[vo]['proxy'];
    };

    # Configure data catalog type.
    if ( is_defined(vo_params[vo]['catalog']) && match(vo_params[vo]['catalog'], 'rls|RLS|Rls') ) {
        result['wlconfig']['networkServer']['RLSCatalog'] = list(vo_name);
    } else {
        result['wlconfig']['networkServer']['DLICatalog'] = list(vo_name);
    };

    # Configure VOMS group/role mapping to accounts.
    # There must for each group/role combination in the VO 1 entry per VOMS server.
    # Also add an authorization URI for each user category (used by mkgridmap configuration).
    # This takes into consideration the FQAN filter as defined by VO_VOMS_FQAN_FILTER to restrict
    # the FQAN configured for a specific VO but this is done in such a way that the associated account
    # UID will be the same with or without a FQAN filter.
    if ( length(voms_servers) > 0 ) {

        ###########################################################
        # Build the list of VOMS servers eligible for voms-admin. #
        ###########################################################
        voms_admin_servers = list();
        foreach (i; voms_server; voms_servers) {
            hostisadmin = true;
            voms_admin_port = "8443";
            # if the type parameter is set for this server, check whether
            # it is a voms-admin server. If the parameter doesn't exist,
            # then assume the server supports voms-admin (for backwards compatibility).
            # 'type' attribute can be either a string or a list of string.
            if ( is_defined(voms_server['type']) ) {
                if (index("voms-admin", voms_server['type']) == -1 ) {
                    debug("voms-admin disabled on VOMS server " + voms_server['host']);
                    hostisadmin = false;
                };
            };
            if ( exists(voms_server['adminport']) ) {
                voms_admin_port = to_string(voms_server['adminport']);
            };
            # Do not add entry for a VOMS server which is not enabled for voms-admin.
            if (hostisadmin) {
                voms_admin_servers[length(voms_admin_servers)] = voms_server['host'] + ':' + voms_admin_port;
            };
        };

        #################################################
        # Retrive and normalize specific FQANs declared #
        #################################################

        # Loop over defined mappings and normalize them to ease further processing
        # Ignore disabled mappings.

        foreach (j; mapping; voms_mappings) {
            if ( mapping['enabled'] ) {
                fqan_list_tmp = mapping['fqan'];
                # This list will have one element matching each FQAN at the same index as in the FQAN list.
                mapping['fqan_toks'] = list();
                foreach (fqan_num; fqan; fqan_list_tmp) {
                    group = '';
                    capability = 'NULL';
                    role = 'NULL';

                    # VO params as generated by ant update.vo.config (VOConfigTask) contain a property 'fqan'
                    # whose value is a standard FQAN: /voname[/group...][/Role=role][/Capacity=capacity].
                    # Several other formats for the fqan property have been used over the years but the only
                    # one still supported for backward compatibility is a string without any /. In this case,
                    # the string is assumed to be role name.
                    if ( match(fqan, '^/') ) {
                        if ( match(fqan, '/Role') ) {
                            fqan_toks = matches(fqan, '^(.+)(?:/Role=([\w\-]+))(?:/Capability=([\w\-]+))?');
                            if ( length(fqan_toks) < 3 ) {
                                error('Failed to parse ' + fqan + ': invalid FQAN');
                            };
                            group = replace('^/' + vo_name, '', fqan_toks[1]);
                            role = fqan_toks[2];
                            if ( length(fqan_toks) > 3) {
                                capability = fqan_toks[3];
                            };
                        } else {
                            group = replace('^/' + vo_name, '', fqan);
                        };
                    } else {
                        role = fqan;
                    };
                    debug('FQAN=' + fqan + ', group=' + group + ', role=' + role + ', capability=' + capability);
                    mapping['fqan_toks'][fqan_num] = dict(
                        'group', group,
                        'role', role,
                        'capability', capability,
                    );
                    # Normalized FQAN
                    normalized_fqan = '/' + vo_name + group;
                    if ( role != 'NULL' ) {
                        normalized_fqan = normalized_fqan + '/Role=' + role;
                    };
                    if ( capability != 'NULL' ) {
                        normalized_fqan = normalized_fqan + '/Capability=' + capability;
                    };
                    mapping['fqan'][fqan_num] = normalized_fqan;
                };
            };
        };

        # Retrieve VOMS FQAN filter, if any.
        # Change a filter based on a description to a filter based on a FQAN.
        # Each entry is either a FQAN relative to the VO (without the initial /voname) or a string
        # not starting with a '/' interpreted as a description (this can be used for example to add a default
        # entry for 'SW manager' that will select the SW manager whatever is its FQAN in the VO). A filter equals
        # to '/' means standard users (no group and no role). A filter value of undef means all FQANs.
        fqan_filter_tmp = undef;
        if ( is_defined(VO_VOMS_FQAN_FILTER) ) {
            debug('VO_VOMS_FQAN_FILTER=' + to_string(VO_VOMS_FQAN_FILTER));
            if ( !is_dict(VO_VOMS_FQAN_FILTER) ) {
                error('VO_VOMS_FQAN_FILTER must be a dict');
            };
            if ( exists(VO_VOMS_FQAN_FILTER[vo_name]) ) {
                fqan_filter_tmp = VO_VOMS_FQAN_FILTER[vo_name];
            } else if ( exists(VO_VOMS_FQAN_FILTER['DEFAULT']) ) {
                fqan_filter_tmp = VO_VOMS_FQAN_FILTER['DEFAULT'];
            };
            # For convenience, VO_VOMS_FQAN_FILTER values can be either
            # a string or a list: convert to a list, except if equals to '/'
            if ( is_string(fqan_filter_tmp) ) {
                if ( fqan_filter_tmp == '/' ) {
                    fqan_filter_tmp = undef;
                } else {
                    tmp = list(fqan_filter_tmp);
                    fqan_filter_tmp = undef;
                    fqan_filter_tmp = tmp;
                };
            } else if ( is_defined(fqan_filter_tmp) && !is_list(fqan_filter_tmp) ) {
                error(
                    'VO_VOMS_FQAN_FILTER entry for VO ' + vo_name +
                    ' has an invalid format: must be a string or list'
                );
            };
            debug('fqan_filter_tmp=' + to_string(fqan_filter_tmp));

            # Replace a filter string based on a description by the matching FQAN.
            # When there is no match, keep the original value: this is harmless as
            # this will never match.
            if ( is_defined(fqan_filter_tmp) ) {
                fqan_filter = list();
                foreach (i; filter_value; fqan_filter_tmp) {
                    if ( !match(filter_value, '/') && is_defined(voms_mappings) ) {
                        fqan_not_found = true;
                        ok = first(voms_mappings, j, mapping_params);
                        while (fqan_not_found && ok) {
                            if ( mapping_params['description'] == filter_value ) {
                                fqan_not_found = false;
                            } else {
                                ok = next(voms_mappings, j, mapping_params);
                            };
                        };
                        if ( !fqan_not_found ) {
                            # mapping_params['fqan']  is a list
                            foreach (j; fqan; mapping_params['fqan']) {
                                # Ensure the FQAN filter is starting with VO name. Add it if missing.
                                if ( !match(fqan, '^/' + vo_name) ) {
                                    fqan_filter[length(fqan_filter)] = '^/' + vo_name + fqan;
                                } else {
                                    fqan_filter[length(fqan_filter)] = fqan;
                                };
                                debug(
                                    'FQAN filter value "' + filter_value +
                                    '" for VO ' + vo_name + ' replaced by "' +
                                    fqan_filter[length(fqan_filter) - 1] + '"'
                                );
                            };
                        } else {
                            debug(
                                'No FQAN found in VOMS mappings for VO ' + vo_name +
                                ' matching description "' + filter_value + '"'
                            );
                        };
                    } else {
                        fqan_filter[length(fqan_filter)] = filter_value;
                    };
                };
            };
            if ( !exists(fqan_filter) ) {
                fqan_filter = undef;
            };

            # Build a list of all FQANs for later processing.
            # Ensure the same FQAN is not mapped to different users.
            # For each FQAN, if an FQAN filter has been defined, mark if it is enabled (true) or disabled (false).
            # If all the FQANs for a mapping are disabled, mark the mapping as disabled.
            fqan_enabled = dict();
            foreach (j; mapping; voms_mappings) {
                if (  mapping['enabled'] ) {
                    mapping['enabled'] = false;
                    foreach (i; fqan; mapping['fqan']) {
                        if ( is_defined(fqan_enabled[escape(fqan)]) ) {
                            error(
                                'FQAN ' + fqan + ' is already a member of a voms_mapping entry other than ' +
                                mapping['description']
                            );
                        } else if ( is_defined(fqan_filter) && index(fqan, fqan_filter) == -1 ) {
                            fqan_enabled[escape(fqan)] = false;
                            debug(
                                'FQAN ' + fqan + ' does not match filter (' + to_string(fqan_filter) +
                                '): marked as disabled'
                            );
                        } else {
                            fqan_enabled[escape(fqan)] = true;
                            mapping['enabled'] = true;
                        };
                    };
                };
            };
        } else {
            debug("VO_VOMS_FQAN_FILTER doesn't exist or undefined.");
        };


        ############################################################################################################
        # Create required accounts: accounts are created only for enabled mappings, using                          #
        # mapping order specified as relative position in the list will determine the UID                          #
        # assigned. For consistency between nodes, whatever is the exact list of mappings enabled                  #
        # (important for NFS sharing), the UID is always computed as if all mappings where enabled.                #
        # Some mappings are processed specifically, such as SW manager, production and pilot role.                 #
        # These mappings must have a particular description as there is no standard group/role associated.         #
        #                                                                                                          #
        # After creating the accounts, for each FQAN create the LCMAPS and gridmap file (mkgridmap) configuration. #
        ############################################################################################################

        # role_next_uid is the next UID to use. At the beginning this is the UID for pilot role
        # which will be used for this role if present (it must be the third one in the list, after SW manager and
        # pilot) or next role after SW manager and production if not present.
        role_next_uid = vo_params[vo]['base_uid'] + vo_params[vo]['pilot_offset'];

        # pool_first_uid is the first UID used by the pool accounts for normal users.
        pool_first_uid = base_uid_pool + vo_params[vo]['pool_start'];

        # pool_last_uid is the last UID used by pool accounts for normal users
        pool_last_uid = pool_first_uid + vo_params[vo]['pool_size'] -1;

        # role_max_uid tracks the last unused UID. Initially the last UID in the VO range.
        role_max_uid = vo_params[vo]['base_uid'] + vo_params[vo]['account_range'];

        foreach (j; mapping; voms_mappings) {
            # If mapping['is_prefix'] does not exist, we must use the mapping['suffix'] as suffix for backward compatibility
            if ( is_defined(mapping['is_prefix']) && mapping['is_prefix'] ) {
                mapped_user = mapping['suffix'] + vo_params[vo]['account_prefix'];
            } else {
                mapped_user = vo_params[vo]['account_prefix'] + mapping['suffix'];
            };

            # Home directory location: SW Manager is a special case where home directory can be relocated to
            # a specific area because this is where VO software will be installed.
            if ( mapping['description'] == vo_params[vo]['sw_manager_descr'] ) {
                is_sw_mgr = true;
                sw_mgr_found = true;
                sw_mgr_user = mapped_user;
                sw_mgr_suffix = mapping['suffix'];
            } else {
                is_sw_mgr = false;
            };

            # Determine if pool accounts must be used or not
            if ( !is_defined(mapping['pool_size']) ) {
                if ( is_sw_mgr &&
                    is_defined(vo_params[vo]['swmgr_pool_accounts_disabled']) &&
                    vo_params[vo]['swmgr_pool_accounts_disabled']
                ) {
                    mapping['pool_size'] = 1;
                } else {
                    mapping['pool_size'] = vo_params[vo]['fqan_pool_size'];
                };
            };
            if ( mapping['pool_size'] > 1 ) {
                user_for_fqan_mapping = "." + mapped_user;
                result['gridmapdir']['poolaccounts'][mapped_user] = 0;
                if ( !is_defined(mapping['pool_digits']) ) {
                    mapping['pool_digits'] = vo_params[vo]['pool_digits'];
                };
                if ( !is_defined(mapping['pool_start']) ) {
                    mapping['pool_start'] = vo_params[vo]['pool_start'];
                };
            } else {
                user_for_fqan_mapping = mapped_user;
            };

            # mapping['is_prefix'] should be considered when creating the homedir_path
            if ( exists(mapping['is_prefix']) ) {
                home_attrs = vo_get_dir_attrs(
                    vo, vo_params[vo], mapping['suffix'], is_sw_mgr, undef, mapping['is_prefix']
                );
            } else {
                home_attrs = vo_get_dir_attrs(vo, vo_params[vo], mapping['suffix'], is_sw_mgr, undef, undef);
            };
            mapped_user_home = home_attrs['directory'];
            if ( is_defined(mapped_user_home) ) {
                account_home = dict('homeDir', mapped_user_home);
            } else {
                account_home = dict();
            };
            create_home_dir = home_attrs['create'];

            # Compute base UID for the FQAN. Some FQAN are always assigned the same UID offset to
            # limit the risk or impact of changing UID. This is SW manager and production. FQAN used
            # for pilot jobs is normally the third one if present but its offset is not reserved.
            # This applies only when not using pool accounts for these FQANs
            if ( mapping['pool_size'] == 1 ) {
                if ( mapping['description'] == vo_params[vo]['sw_manager_descr'] ) {
                    role_base_uid = vo_params[vo]['base_uid'] + vo_params[vo]['sw_manager_offset'];
                } else if ( mapping['description'] == vo_params[vo]['production_descr'] ) {
                    role_base_uid = vo_params[vo]['base_uid'] + vo_params[vo]['production_offset'];
                } else if ( role_next_uid < pool_first_uid ) {
                    role_base_uid = role_next_uid;
                    role_next_uid = role_next_uid + 1;
                } else {
                    role_base_uid = role_max_uid;
                    role_max_uid = role_max_uid - 1;
                };

                # Pooled accounts are used for the mapping.
                # All accounts are created starting in "descending" order from the last UID in the VO range
                # to prevent/reduce collision with single account UID allocation.
               # Group associated with VO is created later as part of creation of pool accounts for normal users.
            } else {
                if ( is_defined(mapping['base_uid']) ) {
                    role_base_uid = mapping['base_uid'];
                    debug(
                        'Base UID explicitly defined for mapping ' + mapping['description'] +
                        ': risk of conflict with other mappings, try to remove it.'
                    );
                } else {
                    role_base_uid = role_max_uid - mapping['pool_size'] + 1;
                    role_max_uid = role_base_uid - 1;
                };
            };
            if ( (role_base_uid > pool_first_uid) && (role_base_uid < pool_last_uid) ) {
                error(
                    'Base UID for mapping ' + mapping['description'] +
                    ' conflicting with pool accounts for normal users'
                );
            };

            if ( mapping['enabled'] ) {
                mapfile_group = vo_group;
                # Do not redefine an already existing mapping (may happen with some specific roles like production)
                if ( !is_defined(result['accounts']['users'][mapped_user]) ) {
                    # If mapping['pool_size'] equals 1, create a single account (backward compatibility) and related groups.
                    fqan_str = replace('\s*[\[\]]\s*', '', to_string(mapping['fqan']));
                    if ( mapping['pool_size'] == 1 ) {
                        debug(
                            'Creating account ' + mapped_user + ' for mapping ' +
                            mapping['description'] + ': UID='  + to_string(role_base_uid)
                        );
                        result['accounts']['users'][mapped_user] = merge(
                            dict(
                                'uid', role_base_uid,
                                'groups', list(vo_group),
                                'comment', 'VO ' + vo_name + ' ' + mapping['description'] + ' (' + fqan_str + ')',
                                'createKeys', vo_params[vo]['create_keys'],
                                'createHome', create_home_dir,
                                'password', vo_account_pass,
                                'shell', vo_params[vo]['account_shell'],
                            ),
                            account_home
                        );
                    } else {
                        # Create pool accounts for the FQAN
                        debug(
                            'Creating pool accounts ' + mapped_user + ' for mapping ' + mapping['description'] +
                            ': base UID=' + to_string(role_base_uid) + ', pool_size=' + to_string(mapping['pool_size'])
                        );
                        if ( VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP || LCMAPS_ADD_GIDS_FROM_MAPPED_ACCOUNTS ) {
                            mapfile_group = mapped_user;
                        };
                        if ( VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP ) {
                            groups = list(mapped_user, vo_group);
                        } else {
                            groups = list(vo_group, mapped_user);
                        };
                        result['accounts']['users'][mapped_user] = merge(
                            dict(
                                'uid', role_base_uid,
                                'groups', groups,
                                'comment', 'VO ' + vo_name + ' ' + mapping['description'] + ' (' + fqan_str + ')',
                                'createKeys', vo_params[vo]['create_keys'],
                                'createHome', create_home_dir,
                                'password', vo_account_pass,
                                'shell', vo_params[vo]['account_shell'],
                                'poolSize', mapping['pool_size'],
                                'poolDigits', mapping['pool_digits'],
                                'poolStart', mapping['pool_start'],
                            ),
                            account_home
                        );
                        if ( is_defined(mapping['gid']) ) {
                            mapping_group_gid = mapping['gid'];
                            debug(
                                'GID for mapping '  + mapping['description']  +
                                ' group explicitly defined: risk of conflict, try to remove.'
                            );
                        } else {
                            mapping_group_gid = role_base_uid;
                        };
                        result['accounts']['groups'][mapped_user] = dict('gid', mapping_group_gid);
                    };
                } else {
                    debug('account ' + mapped_user + ' already exists: not redefined');
                };
            } else {
                debug('Mapping ' + mapping['description'] + ' disabled: account ' + mapped_user + ' not created.');
            };

            # Create the LCMAPS and gridmap file (mkgridmap) configuration for the enabled FQANs.
            # gridmap file configuration is done only if VO_GRIDMAPFILE_MAP_VOMS_ROLES is true.
            # Also keep track of the first FQAN enabled on a VOBOX. Normally there should be only one.
            # A VOBOX is identified by the variable VOBOX_ENABLED_VOS being defined and containing
            # the VO which has access to VOBOX services.
            if (mapping['enabled']) {
                foreach (fqan_num; fqan; mapping['fqan']) {
                    # If not defined at this point, it means that there is no FQAN filter defined.
                    if ( !is_defined(fqan_enabled[escape(fqan)])) {
                        fqan_enabled[escape(fqan)] = true;
                    };
                    if ( fqan_enabled[escape(fqan)] ) {
                        if ( !is_defined(result['vobox_user']) && is_defined(VOBOX_ENABLED_VOS) &&
                            is_defined(fqan_filter) && (index(vo_name, VOBOX_ENABLED_VOS) >= 0)
                        ) {
                            debug('VOBOX enabled user: ' + mapped_user);
                            result['vobox_user'] = mapped_user;
                        };

                        # LCMAPS: add the necessary entries if role and/or capability is NULL
                        # If role=NULL, add a mapping entry without any role
                        role = mapping['fqan_toks'][fqan_num]['role'];
                        capability = mapping['fqan_toks'][fqan_num]['capability'];
                        fqan_mapping[length(fqan_mapping)] = dict(
                            'fqan', fqan,
                            'user', user_for_fqan_mapping,
                            'group', mapfile_group,
                        );
                        if ( role == 'NULL' ) {
                            fqan_role = fqan + '/Role=' + role;
                            fqan_mapping[length(fqan_mapping)] = dict(
                                'fqan', fqan_role,
                                'user', user_for_fqan_mapping,
                                'group', mapfile_group,
                            );
                        } else {
                            fqan_role = fqan;
                        };
                        if ( capability == 'NULL' ) {
                            fqan_mapping[length(fqan_mapping)] = dict(
                                'fqan', fqan_role + '/Capability=' + capability,
                                'user', user_for_fqan_mapping,
                                'group', mapfile_group,
                            );
                        };

                        # gridmap file (mkgridmap configuration)
                        if ( VO_GRIDMAPFILE_MAP_VOMS_ROLES ) {
                            foreach (j; voms_admin_server; voms_admin_servers) {
                                auth_uri[length(auth_uri)] = dict(
                                    'uri', 'vomss://' + voms_admin_server + '/voms/' + vo_name + '?' + fqan,
                                    'user', user_for_fqan_mapping,
                                );
                            };
                        };
                    } else {
                        debug('FQAN ' + fqan + ' disabled: LCMAPS and grid mapfile configuration not added.');
                    };
                };
            };
        };


        ###################################################################
        # Normal users (no specific group/role, use pool accounts).       #
        # Always add these 3 entries LCMAPS entries (1 without /Role,     #
        # 1 with /Role=NULL, 1 with /Role=NULL/Capability=NULL), exept if #
        # a FQAN filter is defined and doesn't specify normal users.      #
        ###################################################################

        if (!is_defined(fqan_filter) || (is_defined(fqan_enabled[escape('/')]) && fqan_enabled[escape('/')])) {
            # LCMAPS
            fqan_mapping[length(fqan_mapping)] = dict(
                'fqan', '/' + vo_name,
                'user', '.' + vo_params[vo]['account_prefix'],
                'group', vo_group
            );
            fqan_mapping[length(fqan_mapping)] = dict(
                'fqan', '/' + vo_name + '/Role=NULL',
                'user', '.' + vo_params[vo]['account_prefix'],
                'group', vo_group
            );
            fqan_mapping[length(fqan_mapping)] = dict(
                'fqan', '/' + vo_name + '/Role=NULL/Capability=NULL',
                'user', '.' + vo_params[vo]['account_prefix'],
                'group', vo_group,
            );

            # gridmap file
            foreach (j; voms_admin_server; voms_admin_servers) {
                auth_uri[length(auth_uri)] = dict(
                    'uri', 'vomss://' + voms_admin_server + '/voms/' + vo_name + '?/' + vo_name,
                    'user', '.' + vo_params[vo]['account_prefix'],
                );
            };

            # Create pool accounts for normal users
            if ( exists(mapping['is_prefix']) ) {
                home_attrs = vo_get_dir_attrs(vo, vo_params[vo], undef, undef, undef, mapping['is_prefix']);
            } else {
                home_attrs = vo_get_dir_attrs(vo, vo_params[vo], undef, undef, undef, undef);
            };
            pool_home = home_attrs['directory'];
            if ( is_defined(pool_home) ) {
                account_home = dict('homeDir', pool_home);
            } else {
                account_home = dict();
            };
            create_home_dir = home_attrs['create'];
            result['shared_homes'] = home_attrs['shared'];
            result['accounts']['users'][vo_params[vo]['account_prefix']] = merge(
                dict(
                    'uid', base_uid_pool,
                    'groups', list(vo_group),
                    'comment', 'VO ' + vo_name + ' pool account',
                    'poolSize', vo_params[vo]['pool_size'],
                    'createKeys', vo_params[vo]['create_keys'],
                    'createHome', create_home_dir,
                    'shell', vo_params[vo]['account_shell'],
                    'poolDigits', vo_params[vo]['pool_digits'],
                    'poolStart', vo_params[vo]['pool_start'],
                    'password', vo_account_pass,
                ),
                account_home
            );
        };
    } else {
        debug("VO " + vo + ": no VOMS server defined, skipping LCMAPS/gridmap/account configuration");
    };

    result['voms'] = fqan_mapping;
    result['auth'] = auth_uri;

    # Create VO group
    result['accounts']['groups'][vo_group] = dict('gid', vo_gid);

    # Create SW manager account if not already done during VOMS role processing as we need it to set permissions of some files/areas.
    # If defaults['is_prefix'] does not exist, we must use the mapping['suffix'] as suffix for backward compatibility
    if ( !sw_mgr_found ) {
        if ( is_defined(vo_params[vo]['is_prefix']) && vo_params[vo]['is_prefix'] ) {
            sw_mgr_user = vo_params[vo]['sw_manager_suffix'] + vo_params[vo]['account_prefix'];
        } else {
            if ( !exists(vo_params[vo]['is_prefix']) ) {
                vo_params[vo]['is_prefix'] = undef;
            };
            sw_mgr_user = vo_params[vo]['account_prefix'] + vo_params[vo]['sw_manager_suffix'];
        };
    };

    if ( !is_defined(result['accounts']['users'][sw_mgr_user]) ) {
        debug(
            'SW manager account not defined for VO ' + vo_name +
            ': creating a SW manager account (' + sw_mgr_user +
            ') with default parameters'
        );
        home_attrs = vo_get_dir_attrs(
            vo, vo_params[vo], vo_params[vo]['sw_manager_suffix'], true, undef, vo_params[vo]['is_prefix']
        );
        sw_mgr_home = home_attrs['directory'];
        if ( is_defined(sw_mgr_home) ) {
            account_home = dict('homeDir', sw_mgr_home);
        } else {
            account_home = dict();
        };
        create_home_dir = home_attrs['create'];
        result['accounts']['users'][sw_mgr_user] = merge(
            dict(
                'uid', vo_params[vo]['base_uid'] + vo_params[vo]['sw_manager_offset'],
                'groups', list(vo_group),
                'comment', 'VO ' + vo_name + ' ' + vo_params[vo]['sw_manager_descr'],
                'createKeys', vo_params[vo]['create_keys'],
                'createHome', create_home_dir,
                'password', vo_account_pass,
                'shell', vo_params[vo]['account_shell'],
            ),
            account_home
        );
    };

    if ( exists(result['accounts']["users"][sw_mgr_user]["poolSize"]) ) {
        dir_perm = '0775';
        file_perm = '0664';
        sw_mgr_group = sw_mgr_user;
        sw_mgr_user = sw_mgr_user + replace(" ", "0", format(
            '%' + to_string(result['accounts']["users"][sw_mgr_user]["poolDigits"]) + 'd',
            result['accounts']["users"][sw_mgr_user]["poolStart"]
        ));
    } else {
        dir_perm = '0755';
        file_perm = '0644';
        sw_mgr_group = vo_group;
        sw_mgr_user = sw_mgr_user;
    };

    #
    # Software directory : create the appropriate VO.list file
    #
    result['voinfo']['paths'] = list(
        dict(
            'path', VO_SW_TAGS_DIR + '/' + vo_name,
            'owner', sw_mgr_user + ':' + sw_mgr_group,
            'perm', dir_perm,
            'type', 'd'
        ),
        dict(
            'path', VO_SW_TAGS_DIR + '/' + vo_name + '/' + vo_name + '.list',
            'owner', sw_mgr_user + ':' + sw_mgr_group,
            'perm', file_perm,
            'type', 'f'
        ),
    );

    #
    # VO software area :
    # If necessary, create the SW area and define permissions (write access to the SW mgr,
    # read access to others). By default SW area configuration is done only on the machine that serves it.
    # This needs to be done even if the SW area is SW mgr home dir, in order to define proper
    # permissions (700 by default).
    # If there is no explicit SW area for a VO, check if a default one is defined
    #
    if ( is_defined(VO_SW_AREAS[vo]) ) {
        result['swarea']['name'] = VO_SW_AREAS[vo];
    } else if ( is_defined(VO_SW_AREAS['DEFAULT']) ) {
        if ( VO_SW_AREAS_USE_SWMGR ) {
            vo_swarea_dir = vo_params[vo]['account_prefix'] + sw_mgr_suffix;
        } else {
            vo_swarea_dir = vo_name;
        };
        result['swarea']['name'] = VO_SW_AREAS['DEFAULT'] + '/' + vo_swarea_dir;
    };

    if ( is_defined(result['swarea']['name']) ) {
        if ( exists(mapping['is_prefix']) ) {
            swarea_attrs = vo_get_dir_attrs(
                vo, vo_params[vo], undef, undef, result['swarea']['name'], mapping['is_prefix']
            );
        } else {
            swarea_attrs = vo_get_dir_attrs(
                vo, vo_params[vo], undef, undef, result['swarea']['name'], undef
            );
        };
        if ( swarea_attrs['create'] ) {
            if ( !exists(result['swarea']['paths']) ) {
                result['swarea']['paths'] = list();
            };
            result['swarea']['paths'][length(result['swarea']['paths'])] = dict(
                'path', result['swarea']['name'],
                'owner', sw_mgr_user + ':' + sw_mgr_group,
                'perm', dir_perm,
                'type', 'd',
            );
        };
    };

    #
    # gridmapdir configuration
    #
    result['gridmapdir']['poolaccounts'][vo_params[vo]['account_prefix']] = 0;

    #
    # Add the VOMS client configuration.
    #
    if ( length(voms_servers) > 0 ) {
        result['vomsclient']['servers'] = list();
        foreach (i; voms_server; voms_servers) {
            if ( is_defined(voms_server['cert']) ) {
                cert_template = 'vo/certs/' + voms_server['cert'];
            } else {
                cert_template = 'vo/certs/' + voms_server['name'];
            };
            vo_cert_params = create(cert_template);
            if ( !exists(vo_cert_params["cert"]) || !is_defined(vo_cert_params["cert"]) ) {
                error(
                    function_name + ' : no certificate found in ' +
                    cert_template + ' for VOMS server ' + voms_server['name']
                );
            };
            if ( is_defined(vo_cert_params["oldcert"]) ) {
                oldcert = dict('oldcert', vo_cert_params["oldcert"]);
            } else {
                oldcert = dict();
            };

            result['vomsclient']['servers'][length(result['vomsclient']['servers'])] = merge(
                dict(
                    'host', voms_server['host'],
                    'port', voms_server['port'],
                    'cert', vo_cert_params["cert"],
                ),
                oldcert
            );
        };
    };

    result;
};


#
# This function should only be used with
# '/software/components/accounts' as the
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
#
function combine_vo_accounts = {

    function_name = "combine_vo_accounts";
    comp_base = "/software/components/accounts";

    # Check cardinality.
    if (ARGC != 1) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos)");
    };

    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name + " : " + comp_base + " must exist");
    };

    if ( !exists(SELF["groups"]) || !is_dict(SELF["groups"]) ) {
        SELF["groups"] = dict();
    };

    if ( !exists(SELF["users"]) || !is_dict(SELF["users"]) ) {
        SELF["users"] = dict();
    };

    foreach (k; v; ARGV[0]) {
        # There is only one VO group, even though the configuration information allows for several
        ok_group = first(VO_INFO[v]['accounts']['groups'], group, dummy);
        if ( !exists(SELF['groups'][group]) ) {
            SELF["groups"] = merge(SELF["groups"], VO_INFO[v]['accounts']['groups']);
            SELF["users"] = merge(SELF["users"], VO_INFO[v]['accounts']['users']);
        };
    };

    SELF;
};


#
# This function should only be used with
# '/software/components/accounts/users' as the
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
#
function combine_gridmapdir_poolaccounts = {

    function_name = "combine_gridmap_poolaccounts";
    comp_base = "/software/components/gridmapdir";

    # Check cardinality.
    if (ARGC != 1) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos)");
    };

    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name  + " : " + comp_base + " must exist");
    };

    if ( !exists(SELF["poolaccounts"]) || !is_dict(SELF["poolaccounts"]) ) {
        SELF["poolaccounts"] = dict();
    };

    foreach (k; v; ARGV[0]) {
        ok_prefix = first(VO_INFO[v]['gridmapdir']['poolaccounts'], vo_prefix, dummy);
        if ( !exists(SELF["poolaccounts"][vo_prefix]) ) {
            SELF["poolaccounts"] = merge(SELF["poolaccounts"], VO_INFO[v]['gridmapdir']['poolaccounts']);
        };
    };

    SELF;
};


#
# This function should only be used with
# '/software/components/dirperm' as the
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
# It can process 2 different parts of VO_INFO :
#  - voinfo : VO INFO files
#  - swarea : root directory for VO SW area
# Argument 2 is used to select which part. If not present
# defaults to voinfo for backward compatibility.
#
function combine_dirperm_paths = {

    function_name = "combine_dirperm_paths";
    comp_base = "/software/components/dirperm";

    # Check cardinality.
    if ((ARGC < 1)  || (ARGC > 2) ) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos,path_type)");
    };

    if ( ARGC == 2 ) {
        path_type = ARGV[1];
        if ( (path_type != 'voinfo') && (path_type != 'swarea') ) {
            error(function_name + ": second argument must be 'voinfo' or 'swarea'");
        };
    } else {
        path_type = 'voinfo';
    };
    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name + " : " + comp_base + " must exist");
    };

    if ( !exists(SELF["paths"]) || !is_list(SELF["paths"]) ) {
        SELF["paths"] = list();
    };

    foreach (k; v; ARGV[0]) {
        if ( exists(VO_INFO[v][path_type]['paths']) && is_defined(VO_INFO[v][path_type]['paths']) ) {
            SELF["paths"] = merge(SELF["paths"], VO_INFO[v][path_type]['paths']);
        };
    };

    if ( length(SELF["paths"]) == 0 ) {
        debug(function_name + ': dirperm path list for ' + path_type + ' empty.');
        SELF["paths"] = null;
    } else {
        # Add ncm-accounts as a pre dependency for ncm-dirperm
        if ( !exists(SELF['dependencies']['pre']) || !is_list(SELF['dependencies']['pre']) ) {
            SELF['dependencies']['pre'] = list('accounts');
        } else {
            found = false;
            ok = first(SELF['dependencies']['pre'], i, v);
            while (ok) {
                if ( v == 'accounts' ) {
                    found = true;
                };
                ok = next(SELF['dependencies']['pre'], i, v);
            };
            if ( ! found ) {
                SELF['dependencies']['pre'][length(SELF['dependencies']['pre'])] = 'accounts';
            };
        };
    };

    SELF;
};


#
# This function should only be used with
# '/software/components/wlconfig' as the
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
#
function combine_wlconfig_networkserver = {
    function_name = "combine_wlconfig_networkserver";
    comp_base = "/software/components/wlconfig";

    # Check cardinality.
    if (ARGC != 1) {
        error("usage: '" + comp_base + "' = " + function_name  + "(vos)");
    };

    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name + " : " + comp_base + " must exist");
    };

    if ( !exists(SELF["networkServer"]) || !is_dict(SELF["networkServer"]) ) {
        SELF["networkServer"] = dict();
    };

    if ( is_defined(SELF["networkServer"]['DLICatalog']) ) {
        dli = SELF["networkServer"]['DLICatalog'];
    } else {
        dli = list();
    };

    if ( is_defined(SELF["networkServer"]['RLSCatalog']) ) {
        rls = SELF["networkServer"]['RLSCatalog'];
    } else {
        rls = list();
    };

    foreach (k; v; ARGV[0]) {
        if ( is_defined(VO_INFO[v]['wlconfig']['networkServer']['DLICatalog']) ) {
            dli = merge(dli, VO_INFO[v]['wlconfig']['networkServer']['DLICatalog']);
        };
        if ( is_defined(VO_INFO[v]['wlconfig']['networkServer']['RLSCatalog']) ) {
            rls = merge(rls, VO_INFO[v]['wlconfig']['networkServer']['RLSCatalog']);
        };
    };
    SELF["networkServer"]['DLICatalog'] = dli;
    SELF["networkServer"]['RLSCatalog'] = rls;

    SELF;
};


#
# This function should only be used with
# '/software/components/vomsclient' as the
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
#
function combine_vomsclient_vos = {
    function_name = "combine_vomsclient_vos";
    comp_base = "/software/components/vomsclient";

    # Check cardinality.
    if (ARGC != 1) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos)");
    };

    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name + " : " + comp_base + " must exist");
    };

    if ( !exists(SELF['vos']) || !is_dict(SELF['vos']) ) {
        SELF['vos'] = dict();
    };

    foreach (k; v; ARGV[0]) {
        if ( is_defined(VO_INFO[v]['vomsclient']['servers']) ) {
            SELF['vos'][VO_INFO[v]['name']] = VO_INFO[v]['vomsclient']['servers'];
        };
    };
    SELF;
};


#
# This function should only be used with
# '/system/vo' as the path.  This takes a list of
# VOs and relies on the information in the global
# variable VO_INFO.
#
function combine_system_vo = {
    # Check cardinality.
    if (ARGC != 1) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos)");
    };

    foreach (k; v; ARGV[0]) {
        SELF[v]['name'] = VO_INFO[v]['name'];
        SELF[v]['auth'] = VO_INFO[v]['auth'];

        if ( exists(VO_INFO[v]['services']['myproxy']) ) {
            SELF[v]['services']['myproxy'] = VO_INFO[v]['services']['myproxy'];
        };

        if ( exists(VO_INFO[v]['services']['edg']) ) {
            edg_services = VO_INFO[v]['services']['edg'];
            foreach (service; host; edg_services) {
                SELF[v]['services'][service] = host;
            };
        };

        if ( exists(VO_INFO[v]['services']['glite']) ) {
            glite_services = VO_INFO[v]['services']['glite'];
            foreach (service; hosts; glite_services) {
                SELF[v]['services']['wms'][service] = hosts;
            };
        };

        if (exists(VO_INFO[v]['voms'])) {
            SELF[v]['voms'] = VO_INFO[v]['voms'];
        };
    };

    if ( is_defined(SELF) ) {
        SELF;
    } else {
        dict();
    };
};


#
# This function MUST be used very carefully.  It must only be called such
# that the variable SELF points to "/system/components/profile".  It takes four
# arguments: the VO name, the software directory, the default SE, and
# optionally the default SC3 SE.
#
# In the calling template you MUST include the the default templates
# for the profile component!
#
function combine_vo_env = {
    function_name = "combine_vo_env";
    comp_base = "/software/components/profile";

    # Check cardinality.
    if (ARGC < 3 ) {
        error("usage: '" + comp_base + "' = " + function_name + "(vos,vo_areas,default_SE[,default_SE_SC3])");
    };
    if ( !exists(SELF) || !is_defined(SELF)) {
        error(function_name  + " : " + comp_base + " must exist");
    };

    vo_areas = ARGV[1];
    default_se_list = ARGV[2];
    if (ARGC>3 && is_defined(ARGV[3])) {
        default_se_sc3 = ARGV[3];
    };

    if ( !exists(SELF["env"]) || !is_defined(SELF["env"]) ) {
        SELF["env"] = dict();
    };

    # For each VO, set the software directory, the default SE, and
    # optionally, the default SE for SC3.
    foreach (k; v; ARGV[0]) {
        vo_uc = to_uppercase(replace('[.\-]', '_', VO_INFO[v]['name']));
        if ( is_defined(vo_areas[v]) ) {
            SELF["env"]["VO_" + vo_uc + "_SW_DIR"] = vo_areas[v];
        };
        # default_se_list contains one entry per VO.
        # An undefined default SE is valid
        if ( is_defined(default_se_list[v]) ) {
            SELF["env"]["VO_" + vo_uc + "_DEFAULT_SE"] = default_se_list[v];
        };
        if (exists(default_se_sc3)) {
            SELF["env"]["VO_SC3_" + vo_uc + "_DEFAULT_SE"] = default_se_sc3;
        };
    };

    if ( length(SELF["env"]) == 0 ) {
        SELF["env"] = null;
    };

    SELF;
};


# Function returning directory attributes as a hash.
# This function is mainly used to get home directory for a VO and check if it must be created.
#
# Attributes returned are :
#    - directory : home directory for the VO or VO role. Returns undef if there is no
#                  explicit value. If directory is explicitly passed as an argument, returns
#                  the same value.
#    - create : need to create dir depending if it is local or remote (NFS served).
#               True if the create_home flag for the VO is undef AND the directory is local.
#    - shared : true if the directory is served through NFS
#
# Arguments :
#   - VO name (required)
#   - VO parameters (required if 'directory' parameter is empty) : VO parameters as used in add_vo_info()
#   - Account suffix (optional). If 's', account is considered to be the SW mgr
#     and SW manager home dir is returned if defined
#   - SW manager (optional) : if true, return SW manager home dir rather than normal home directory,
#     even if suffix is not 's'. If false, return normal home directory even if suffix is 's'.
#     This argument is ignored if account suffix is empty or undef.
#   - Directory (optional) : check a specific directory rather than home directories. Mainly
#                            used to know if a directory is local or NFS served (e.g. SW area)
#
function vo_get_dir_attrs = {
    function_name = 'vo_get_dir_attrs';
    result = dict();
    result['shared'] = false;
    result['directory'] = undef;
    sw_mgr_home = false;

    if ( exists(ARGV[0]) && is_defined(ARGV[0]) ) {
        vo = ARGV[0];
    } else {
        error(function_name + ' : vo name missing');
    };

    if ( exists(ARGV[5]) && is_defined(ARGV[5]) ){
        is_prefix = ARGV[5];
    } else {
        is_prefix = false;
    };

    if ( exists(ARGV[2]) && is_defined(ARGV[2]) && (length(ARGV[2]) > 0) ) {
        suffix = ARGV[2];
        if ( exists(ARGV[3]) && is_defined(ARGV[3]) ) {
            sw_mgr_home = ARGV[3];
        } else {
            if ( suffix == 's' ) {
                sw_mgr_home = true;
            };
        };
    } else {
        suffix = '';
    };

    dir_not_home = false;
    if ( exists(ARGV[4]) && is_defined(ARGV[4]) && (length(ARGV[4]) > 0) ) {
        result['directory'] = ARGV[4];
        dir_not_home = true;
    } else {
        if ( sw_mgr_home && exists(VO_SWMGR_HOMES[vo]) && is_defined(VO_SWMGR_HOMES[vo]) ) {
            result['directory'] = VO_SWMGR_HOMES[vo];
        };
        # Set DEFAULT for VO_SWMGR_HOMES
        if ( !is_defined(result['directory']) && sw_mgr_home && exists(VO_SWMGR_HOMES['DEFAULT'])
            && is_defined(VO_SWMGR_HOMES['DEFAULT'])
        ) {
            if ( is_prefix ) {
                result['directory'] = VO_SWMGR_HOMES['DEFAULT'] + '/' + suffix + ARGV[1]['account_prefix'];
            } else {
                result['directory'] = VO_SWMGR_HOMES['DEFAULT'] + '/' + ARGV[1]['account_prefix'] + suffix;
            }
        };
        if ( !is_defined(result['directory']) && exists(VO_HOMES[vo]) && is_defined(VO_HOMES[vo]) ) {
            if ( is_prefix ) {
                result['directory'] = VO_HOMES[vo] + '/' + suffix + ARGV[1]['account_prefix'];
            } else {
                result['directory'] = VO_HOMES[vo] + '/' + ARGV[1]['account_prefix'] + suffix;
            }
        };
        # Set DEFAULT for VO_HOMES, is similar to usage of NODE_VO_DEFAULT_HOMEROOT
        if ( !is_defined(result['directory'])  && exists(VO_HOMES['DEFAULT']) && is_defined(VO_HOMES['DEFAULT']) ) {
            if ( is_prefix ) {
                result['directory'] = VO_HOMES['DEFAULT'] + '/' + suffix + ARGV[1]['account_prefix'];
            } else {
                result['directory'] = VO_HOMES['DEFAULT'] + '/' + ARGV[1]['account_prefix'] + suffix;
            }
        };
        if ( !is_defined(result['directory']) && exists(NODE_VO_DEFAULT_HOMEROOT) &&
            is_defined(NODE_VO_DEFAULT_HOMEROOT)
        ) {
            if ( is_prefix ) {
                result['directory'] =  NODE_VO_DEFAULT_HOMEROOT + '/' + suffix + ARGV[1]['account_prefix'];
            } else {
                result['directory'] =  NODE_VO_DEFAULT_HOMEROOT + '/' + ARGV[1]['account_prefix'] + suffix;
            }
        };
        # Check if directory contains a variable like @VONAME@ or @VOALIAS@.
        # If yes, replace by the appropriate value: VO full name if @VONAME@, VO name used in
        # configuration if @VOALIAS@.
        if ( is_defined(result['directory']) ) {
            if ( match(result['directory'], '@VONAME@') ) {
                result['directory'] = replace('@VONAME@', ARGV[1]['name'], result['directory']);
            } else if ( match(result['directory'], '@VOALIAS@') ) {
                result['directory'] = replace('@VOALIAS@', ARGV[0], result['directory']);
            };
        };
    };
    if ( is_defined(result['directory']) && (length(result['directory']) > 0) ) {
        mnt_point = result['directory'];
    } else {
        mnt_point = '/home';
    };

    if ( exists(ARGV[1]['create_home']) && is_defined(ARGV[1]['create_home']) ) {
        result['create'] = ARGV[1]['create_home'];
    } else {
        result['create'] = undef;
    };

    # If create flag for home dirs is undefined or if an explicit directory has been specified,
    # check if the filesystem is NFS mounted and remote. In this case, set create_home to false.
    # Else set to true.
    # The test is done for the directory itself (except if it defaults to /home) and all its parents.
    if ( !is_defined(result['create']) || dir_not_home ) {
        result['create'] = true;
        ok = true;
        while (ok) {
            debug('Checking if ' + mnt_point + ' is a shared file system...');
            e_mnt_point = escape(mnt_point);
            # If the home directory belongs to a shared path, default is to create home directories
            # only if the file system is NFS served and the current machine is the NFS server.
            # For other type of shared FS or on a machine which is not the NFS server, CREATE_HOME must
            # be set in node profile.
            if ( exists(WN_SHARED_AREAS[e_mnt_point]) && is_defined(WN_SHARED_AREAS[e_mnt_point]) ) {
                ok = false;
                result['shared'] = true;
                if ( is_defined(NFS_MOUNT_POINTS['servedFS'][e_mnt_point]) ) {
                    debug(mnt_point + ' found in list of FS NFS-served by ' + FULL_HOSTNAME);
                } else {
                    debug(mnt_point + ' is not a NFS-served FS or is not served by ' + FULL_HOSTNAME);
                    result['create'] = false;
                };
            } else {
                toks = matches(mnt_point, '(.+)/([\w\.\-]+)');
                if ( length(toks) >= 2 ) {
                    mnt_point = toks[1];
                } else {
                    ok = false;
                };
            };
        };
    };
    result;
};

#
# Add VO config to Yaim
#
function add_vos_to_yaim = {
    x = dict();
    if ( ! exists( VO_CONFIG ) ) {
        error("Required variable VO_CONFIG was not defined");
    }
    else if ( ! is_dict( VO_CONFIG ) ) {
        error("VO_CONFIG is not an dict");
    }
    else if ( length( VO_CONFIG ) == 0 ) {
        error("VO_CONFIG is empty");
    };
    if ( ! exists( VOMS_SERVERS ) ) {
        error("Required variable VOMS_SERVERS was not defined");
    }
    else if ( ! is_dict( VOMS_SERVERS ) ) {
        error("VOMS_SERVERS is not an dict");
    };

    # Copy VO information and define VOMS info
    foreach (i; vo; VO_CONFIG) {
        voname = vo['name'];
        x[voname]['name'] = voname;
        x[voname]['services'] = vo['services'];

        voms_servers = "";
        vomses = "";
        voms_ca_dn = "";
        foreach (j; voms; vo['voms_servers']) {
            if ( ! exists( VOMS_SERVERS[voms['host']] ) ) {
                error("Missing definition for VOMS server " + voms['host']);
            };
            srv = VOMS_SERVERS[voms['host']];
            voms_servers = voms_server + "'vomss://" + voms['host'] + ":" + srv['port']
                + "/voms/" + voname  + "?/" + voname + "/' ";
            vomses = vomses + "'" + voname + " " + voms['host'] + " "
                + voms['port'] + " " + srv['dn'] + " " + voname + "' ";
            voms_ca_dn = voms_ca_dn + "'" + srv['CA-dn'] + "' ";
        };
        x[voname]['services']['VOMS_SERVERS'] = voms_servers;
        x[voname]['services']['VOMSES'] = vomses;
        x[voname]['services']['VOMS_CA_DN'] = voms_ca_dn;
    };

    return (x);
};

#
# Add all required VOMS server certificates - if existing
#
function add_voms_certs = {
    vomsdir = '/etc/grid-security/vomsdir';
    if ( exists( VOMS_SERVERS ) && is_dict( VOMS_SERVERS ) ) {
        # check per VOMS server if a certificate has been defined
        # and include it if that is the case
        foreach( srv; cfg; VOMS_SERVERS ) {
            file = escape(vomsdir + "/" + srv);
            if ( exists( "vo/certs/" + srv ) ) {
                SELF['filecopy']['services'][file] = create("vo/certs/" + srv);
                SELF['filecopy']['services'][file]['perms'] = '0644';
            };
        };
    }
    else {
        debug("[add_voms_certs] VOMS_SERVERS is not defined or not an dict");
    };
    SELF;
};

