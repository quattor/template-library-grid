unique template personality/se_dpm/puppet/no_pool_accounts;

'/software/components/accounts/users' = {
        foreach(i;user;SELF){
                if(is_defined(user["poolSize"]) && (user["poolSize"]>1)){
                        user["poolSize"] = null;
                        user["poolDigits"] = null;
                        user["poolStart"] = null;
                };
        };
        SELF;
};


'/system/vo' = {
        foreach(i;vo;SELF){
                foreach(j;auth;vo['auth']){
                        simple_user=matches(auth['user'],'^\.(\S+)$');
                        if(length(simple_user) > 1 ){
                                auth['user']=simple_user[1];
                        };
                };

                foreach(j;role;vo['voms']){
                        simple_role=matches(role['user'],'^\.(\S+)$');
                        if(length(simple_role) > 1 ){
                                role['user']=simple_role[1];
                        };
                };
        };
        SELF;
};

