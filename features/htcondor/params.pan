unique template features/htcondor/params;

variable CONDOR_CONFIG = {
	 
  if(!is_defined(SELF['pwd_hash'])){
    error("Missing 'pwd_hash' attribute of CONDOR_CONFIG.\n");
  };

  if(!is_defined(SELF['pwd_file'])){
    SELF['pwd_file'] = '/var/lib/condor/condor_credential';
  };
	 
  if(!is_defined(SELF['cfgdir'])){
    SELF['cfgdir'] = '/etc/condor';
  };

  if(!is_defined(SELF['cfgprefix'])){
    SELF['cfgprefix'] = 'quattor';
  };

  if(!is_defined(SELF['strict'])){
    SELF['strict'] = true; 
  };

  if(!is_defined(SELF['restart'])){
    if( SELF['strict']){
      enforce = SELF['cfgdir']+'/quattor_cleaning_script.sh';
    }else{
      enforce = 'exit 0';
    };
		
    SELF['restart'] = '(' + enforce + ')&&(!(service condor status) || condor_reconfig)';
  };
 
  if(!is_defined(SELF['cfgfiles'])){
    SELF['cfgfiles'] = list();
  };

  foreach(i;file;SELF['cfgfiles']){

    if(!is_defined(file['name'])){
      error('No attribute "name" defined for CONDOR_CONFIG["cfgfiles"]["'+to_string(i)+'"]');
    };

    if(!is_defined(file['path'])){
      file['path'] = SELF['cfgdir'] + '/config.d/' + SELF['cfgprefix'] + '.' + to_string(i) + '.' + file['name'] + '.conf'; 
    };

    if(!is_defined(file['contents'])){
      error('No attribute "contents" defined for CONDOR_CONFIG["cfgfiles"]["'+to_string(i)+'"]');
    };

    if(!is_defined(file['restart'])){
      file['restart'] = SELF['restart'];
    };
  };
	
  #Default config local file is empty
  if(!is_defined(SELF['config.local'])){
    SELF['config.local'] = '';
  };

  SELF; 
};

