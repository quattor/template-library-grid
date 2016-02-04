unique template features/htcondor/client/policies;

variable CONDOR_CONFIG={

  #
  # Prepare parameters: 
  #  - they are written in "parametrs" conf file and are used for implements rules etc
  #  - they are also used for defining the BDII pubblication
  #  - they have a default value and some non-default value for some policy groups
  #

  # The limits defaults's defaults
  if(!is_defined(SELF['params_defaults'])){
    SELF['params_defaults'] = nlist(
      'MAXWALLTIME',60*72,
      'MAXMEM',2000,
      'SERVINGSTATE','Production',
    );
  };

  # Create limits  
  if(!is_defined(SELF['params'])){
    SELF['params']=nlist();
  };

  foreach(param;default;SELF['params_defaults']){
    if(!is_defined(SELF['params'][param])){
      SELF['params'][param]=nlist();
    };
    if(!is_defined(SELF['params'][param]['default'])){
      SELF['params'][param]['default']=default;
    };    
  };

  # 
  # Garbage collector rules
  #

  if(!is_defined(SELF['gc_rules'])){
    SELF['gc_rules'] = nlist()
  };

  # Default rules: execution time, hold time, mem usage, disk usage
  if(!is_defined(SELF['default_gc_rules'])){
    SELF['default_gc_rules'] = nlist(
    	'HoldRule', 'JobStatus == 5 && time() - EnteredCurrentStatus > 3600*48',
	    'WCTRule',  '(JobStatus == 2)&&(($(MAXWALLTIME)>0)&&((time() - EnteredCurrentStatus) > (60*$(MAXWALLTIME))))'
    );
  };  

  # Create the policy rules 
  foreach(j;rule;SELF['default_gc_rules']){
    if(!is_defined(SELF['gc_rules'][j])){
      SELF['gc_rules'][j]=rule;
    };	
  };
  

  SELF;
};

#
#Build up parameters to be published
#
variable GIP_CE_LDIF_PARAMS = {
  SELF['extra_glue2']=nlist();
  params=CONDOR_CONFIG['params'];

  foreach(i;param;list('MAXWALLTIME','MAXMEM','SERVINGSTATE')){
    if(is_defined(params[param])){
      foreach(share;value;params[param]){
	#error(to_string(share)+':'+to_string(value));
        if(!is_defined(SELF['extra_glue2'][share])){
          SELF['extra_glue2'][share]=nlist();
        };
        SELF['extra_glue2'][share][param]=list(to_string(value));    
      };
    }; 
  };


  SELF;
};