structure template features/htcondor/templ/params;


'text' = {
  txt = <<EOF;

EOF

   foreach(name;values;CONDOR_CONFIG['params']){
     txt = txt +  name + ' = ';
     count=0;
     foreach(group;value;values){
       if(group!="default"){
         txt = txt + 'IfThenElse( PolicyGroup == "' + group +'",'+ to_string(value) +',\'+"\n";
	 count=count+1; 
       };
     };
     txt=txt+to_string(values["default"]);
     while(count>0){
       txt=txt+')';
       count=count-1;
     };
     txt=txt+"\n";
   };
   txt;

};


