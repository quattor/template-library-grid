#!/usr/bin/perl -w
# Queries NDGF site information and translates it from ARC to GLUE schema
# Prototype by L.Field (2006)
# Corrections and Performance enhancements by M.Flechl (2006-08-17)
# Merged with adjusted bdii-update (David Groep, L.Field, M.Litmaath) by L.Field and M.Flechl (2006-08-21)
# ARC GIIS traversal and some sanity checks for failing GRISes by Mattias Wadenstein (2007-07-03)
# Updated to work at a resource bdii-level by Daniel (2009-2010)
# Now we can generate the CEUniqueID correctly with the queue name by Pekka Kaitaniemi (2012-04-19)
#
# $Id: glite-info-provider-ndgf,v 1.1 2006/08/30 12:13:15 lfield Exp $ 

use strict;
use LWP::Simple;
use POSIX;
use IO::Handle;

sub translator;

sub getCondorJobsRunning
{
   my ($vo) = @_;
   my $file = "/var/local/condor_jobs_running";
   if (-e $file)
   {
      open(FILE, "<$file");
      foreach my $line (<FILE>)
      {
         if ($line =~ /$vo/)
         {
            my @pieces = split(/\s+/, $line);
            return $pieces[1];
         }
      }
      close(FILE);
   }
   return 0;
}


sub getCondorJobsIdle
{
   my ($vo) = @_;
   my $file = "/var/local/condor_jobs_idle";
   if (-e $file)
   {
      open(FILE, "<$file");
      foreach my $line (<FILE>)
      {
         if ($line =~ /$vo/)
         {
            my @pieces = split(/\s+/, $line);
            return $pieces[1];
         }
      }
      close(FILE);
   }
   return 0;
}

sub build_glueCEUniqueID
{
    my $cluster_name = shift;
    my $cluster_lrms_type = shift;
    my $queue_name = shift;
    return $cluster_name . ":" . "2811" . "/nordugrid-". $cluster_lrms_type . "-" . $queue_name;
}

sub build_glueServiceUniqueID
{
    my $cluster_name = shift;
    return $cluster_name . "_" . "org.nordugrid.arex";
}

# Global variables for translator
use vars qw($DEFAULT); $DEFAULT = 0;
use vars qw($outbIP $inbIP $glueSubClusterUniqueID $norduBenchmark $norduOpsys $norduNodecput $norduNodecpu);
use vars qw($glueHostMainMemoryRAMSize $glueHostArchitecturePlatformType $glueSubClusterUniqueID $GlueHostBenchmarkSI00 $GlueHostBenchmarkSF00);
use vars qw($glueSubClusterName $glueSubClusterPhysicalCPUs $glueSubClusterLogicalCPUs $glueClusterUniqueID $processorOtherDesc $smpSize);
use vars qw($AssignedSlots $mappedStatus $waitingJobs $totalJobs $waitingJobs $freeSlots $estRespTime $worstRespTime $vo $ce_unique_id);
use vars qw(@envs @vos);

# Average number of logical CPUs (cores) per WN
my $ral_smpSize = 24;

#Create nordugrid ldif
#TODO read this from optarg
my $ldif_input=`$LDIF_GENERATOR_FILE_NG`;

# These values will be read from NorduGrid MDS
my %%cluster_attributes=(
    'nordugrid-cluster-location' => '',
    'nordugrid-cluster-support' => '',
    'nordugrid-cluster-name' => '',
    'nordugrid-cluster-runtimeenvironment' => '',
    'nordugrid-cluster-contactstring' => '',
    'nordugrid-cluster-aliasname' => '',
    'nordugrid-cluster-lrms-type' => '',
    'nordugrid-cluster-lrms-version' => '',
    'nordugrid-cluster-totalcpus' => '',
    'nordugrid-cluster-opsys' => '',
    'nordugrid-cluster-benchmark' => '',
    'nordugrid-cluster-nodecpu' => '',
    'nordugrid-cluster-nodememory' => '',
    'nordugrid-cluster-nodeaccess' => '',
    'nordugrid-cluster-architecture' => '',
    'nordugrid-cluster-acl' => '',
    'nordugrid-cluster-homogeneity' => '',
    'nordugrid-cluster-comment' => '',
    'nordugrid-cluster-owner' => '',
    'nordugrid-cluster-localse' => '',
    );

#all these values will be checked if they are numeric only:
my @cluster_attributes_num = ('totalcpus','nodememory');
for (my $i=0; $i<=$#cluster_attributes_num; $i++){ $cluster_attributes_num[$i] = 'nordugrid-cluster-'.$cluster_attributes_num[$i]; }

# Queue attributes read from NorduGrid MDS
my %%queue_attributes=(
    'nordugrid-queue-name' => '',
    'nordugrid-queue-running' => '',
    'nordugrid-queue-maxrunning' => '',
    'nordugrid-queue-maxcputime' => '',
    'nordugrid-queue-maxqueuable' => '',
    'nordugrid-queue-totalcpus' => '',
    'nordugrid-queue-opsys' => '',
    'nordugrid-queue-benchmark' => '',
    'nordugrid-queue-nodecpu' => '',           
    'nordugrid-queue-nodememory' => '',
    'nordugrid-queue-architecture' => '',
    'nordugrid-queue-status' => '',
    'nordugrid-queue-gridqueued' => '',
    'nordugrid-queue-localqueued' => '',
    'nordugrid-queue-prelrmsqueued' => '',
    );

#all these values will be checked if they are numeric only:
my @queue_attributes_num = ('running','maxrunning','maxcputime','maxqueuable','totalcpus','nodememory','gridqueued','localqueued','prelrmsqueued');
for (my $i=0; $i<=$#queue_attributes_num; $i++){ $queue_attributes_num[$i] = 'nordugrid-queue-'.$queue_attributes_num[$i]; }

#Translate and print glue ldif
#TODO this should perhaps be able to write do different rootdn:s, not just mds-vo-name=resource,o=grid.
translator($ldif_input);

exit;

#translator takes an ldif-output in a scalar variable as input and prints the output to stdout
sub translator(){

    my $temp=$_[0];

    #$DEFAULT = -1;
    # Store ldif here
    my @ldif;

    #Remove blank space at the start of the line
    $temp=~s/\n //gm;
    @ldif=split "\n", $temp;
    push @ldif, "EOF";
    
    #my $hostname=hostname();
    
    #set the attributes from the ldif
    for my $key ( keys %%cluster_attributes ) {
	$cluster_attributes{$key} = join (" ", grep { /^$key/ } @ldif);
	chomp $cluster_attributes{$key};
	if ($key eq "nordugrid-cluster-opsys" or $key eq "nordugrid-cluster-owner"
	    or $key eq "nordugrid-cluster-benchmark") {
	    $cluster_attributes{$key}=~s/ ?$key//g;
	} else {
	    $cluster_attributes{$key}=~s/$key: //g;
	}
	if ($cluster_attributes{$key}=~/^$/) { $cluster_attributes{$key}="$DEFAULT" }
    }

    my $glue_site_unique_id="$GLUESITEUNIQUEID";
    #my $glue_site_unique_id=$cluster_attributes{'nordugrid-cluster-aliasname'};

    @envs = split / /, $cluster_attributes{'nordugrid-cluster-runtimeenvironment'};
    my @storages = split / /, $cluster_attributes{'nordugrid-cluster-localse'};
    
    $outbIP = "FALSE";
    $inbIP = "FALSE";
    if ($cluster_attributes{'nordugrid-cluster-nodeaccess'} eq "outbound"){
	$outbIP = "TRUE";
    } elsif ($cluster_attributes{'nordugrid-cluster-nodeaccess'} eq "inbound"){
	$inbIP = "TRUE";
    }
    if ($cluster_attributes{'nordugrid-cluster-acl'} eq "$DEFAULT") {
	$cluster_attributes{'nordugrid-cluster-acl'}="VO:ops";
    }
    
    my @owner  = split /: /, $cluster_attributes{'nordugrid-cluster-owner'};
    
    my $nclocation=$cluster_attributes{'nordugrid-cluster-location'};
    
    my $loc = $LOC; 
    my $lat = $LAT; 
    my $long = $LONG;
    my $provide_glue_site_info = "$PROVIDE_GLUE_SITE_INFO";
    $processorOtherDesc = "$PROCESSOROTHERDESCRIPTION";
    #set numeric values to $DEFAULT if they are on the list and not numeric
    for (my $i=0; $i<=$#cluster_attributes_num; $i++){
	if (! ($cluster_attributes{$cluster_attributes_num[$i]} =~ /^\d+$/) ){ $cluster_attributes{$cluster_attributes_num[$i]} = $DEFAULT; }
    }

    # Write Site Entries
    if($provide_glue_site_info =~ /true/i) {
	write_site_entries($glue_site_unique_id,
			   $cluster_attributes{'nordugrid-cluster-comment'},
			   $cluster_attributes{'nordugrid-cluster-support'},
			   $loc,$lat,$long,"$GLUESITEWEB",\@owner);
    }

    if ($cluster_attributes{'nordugrid-cluster-homogeneity'} =~ /true/i){
	$glueSubClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'};
	$norduOpsys=$cluster_attributes{'nordugrid-cluster-opsys'};
	$norduBenchmark=$cluster_attributes{'nordugrid-cluster-benchmark'};
	$norduNodecpu=$cluster_attributes{'nordugrid-cluster-nodecpu'};
	$glueHostMainMemoryRAMSize=$cluster_attributes{'nordugrid-cluster-nodememory'};
	$glueHostArchitecturePlatformType=$cluster_attributes{'nordugrid-cluster-architecture'};
	$glueSubClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'};
	$glueSubClusterName=$glue_site_unique_id;
	if ( $processorOtherDesc =~ m/Cores=(\d+(\.\d)*)/ ){
	    $smpSize=$1;
	    $glueSubClusterPhysicalCPUs=int($cluster_attributes{'nordugrid-cluster-totalcpus'}*%d/$smpSize);
	}
	else {
	    $smpSize=1;
	    $glueSubClusterPhysicalCPUs=$cluster_attributes{'nordugrid-cluster-totalcpus'};
	}
	$glueSubClusterLogicalCPUs=int($cluster_attributes{'nordugrid-cluster-totalcpus'}*%d);
	$glueClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'};
    
	WriteSubCluster();
    }

    #Do GlueCE entry for each nordugrid queue
    write_gluece_entries(\@ldif);

    # Write Cluster Entries
    write_cluster_entries($cluster_attributes{'nordugrid-cluster-name'},$glue_site_unique_id);

    #write CE-SE Binding Entries
    if ( $cluster_attributes{'nordugrid-cluster-localse'} ) {
        write_ce_se_binding_entries($cluster_attributes{'nordugrid-cluster-localse'},\@storages);
    }
    
    # Service information. This is an hack to mimic Site-BDII service information.
    my $glueServiceUniqueID = build_glueServiceUniqueID($cluster_attributes{'nordugrid-cluster-name'});
    my $glueservicename = $glue_site_unique_id."-arc";
    my $glueservicestatusinfo=`/etc/init.d/a-rex status`;
    chomp $glueservicestatusinfo;
    my $glueservicestatus;
    if ($? == 0) {
        $glueservicestatus="OK";
    } else {
        $glueservicestatus="Warning";
    }
    my $serviceendpoint = "gsiftp://". $cluster_attributes{'nordugrid-cluster-name'} . ":" . "2811" . "/jobs";
    my $serviceversion = "3.0.0";
    my $servicetype = "ARC-CE";
    write_service_information ($glueServiceUniqueID,$glueservicename,$glueservicestatus,$glueservicestatusinfo,$serviceendpoint,$serviceversion,$servicetype,'_UNDEF_');
}

# Write SubCluster Entries

sub WriteSubCluster {
    
#dn: GlueSubClusterUniqueID=$glueSubClusterUniqueID,GlueClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'},mds-vo-name=resource,o=grid

    print "
dn: GlueSubClusterUniqueID=$glueSubClusterUniqueID,GlueClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'},mds-vo-name=resource,o=grid
objectClass: GlueClusterTop
objectClass: GlueSubCluster
objectClass: GlueSchemaVersion
objectClass: GlueHostApplicationSoftware
objectClass: GlueHostArchitecture
objectClass: GlueHostBenchmark
objectClass: GlueHostMainMemory
objectClass: GlueHostNetworkAdapter
objectClass: GlueHostOperatingSystem
objectClass: GlueHostProcessor
objectClass: GlueInformationService
objectClass: GlueKey
";
 
    foreach (@envs){
	chomp;
	print "GlueHostApplicationSoftwareRunTimeEnvironment:  $_\n"
    }
 
    print "GlueHostArchitectureSMPSize: $ral_smpSize
GlueHostNetworkAdapterInboundIP: $inbIP
GlueHostNetworkAdapterOutboundIP: $outbIP";
 
    my @opsys = split /: /, $norduOpsys;
    for (my $i=0; $i<=3; $i++){
	if ($i > $#opsys) { $opsys[$i]=$DEFAULT; }
	chomp($opsys[$i]);
	$opsys[$i]=~s/\s+$//;
    }
    $GlueHostBenchmarkSI00 = $DEFAULT;
    $GlueHostBenchmarkSF00 = $DEFAULT;
    my $benchmark;
    if($norduBenchmark) {
	foreach $benchmark (split /: /, $norduBenchmark) {
	    if($benchmark =~ /SPECINT2000 @ (\d+)/) {
		$GlueHostBenchmarkSI00 = $1;
	    }
	    if($benchmark =~ /SPECFP2000 @ (\d+)/) {
		$GlueHostBenchmarkSF00 = $1;
	    }
	}
    }
 
    my @nodecpu  = split / /, $norduNodecpu;
    my $clockSpeed=$DEFAULT;
    my $cpuVer=$DEFAULT;
    for (my $i=0; $i<=$#nodecpu; $i++){
	if ($i >= 2){
	    if ($nodecpu[$i -2] =~ /@/) { $clockSpeed = $nodecpu[$i -1]." ".$nodecpu[$i]; }
	}
	if ($nodecpu[$i] =~ /I$/) { $cpuVer = $nodecpu[$i]; }
    }
    for (my $i=0; $i<=1; $i++){ if ($i > $#nodecpu) { $nodecpu[$i]=$DEFAULT; } }
    
    $clockSpeed=~s/\.[0-9]*//;
    $clockSpeed=~s/MHz//i;
    $clockSpeed=~s/GHz/000/i;
    $clockSpeed=~s/[^0-9]//g;
    if (! $clockSpeed=~m/[0-9]/) { $clockSpeed=$DEFAULT; } 
    print "
GlueHostOperatingSystemName: $opsys[1]
GlueHostOperatingSystemRelease: $opsys[2]
GlueHostOperatingSystemVersion: $opsys[3]
GlueHostProcessorVendor: $nodecpu[0]
GlueHostProcessorModel: $nodecpu[1]
GlueHostProcessorVersion: $cpuVer
GlueHostProcessorClockSpeed: $clockSpeed
GlueHostProcessorOtherDescription: $processorOtherDesc
GlueHostMainMemoryRAMSize: $glueHostMainMemoryRAMSize
GlueHostArchitecturePlatformType: $glueHostArchitecturePlatformType
GlueHostBenchmarkSI00: $GlueHostBenchmarkSI00
GlueHostBenchmarkSF00: $GlueHostBenchmarkSF00
GlueSubClusterUniqueID: $glueSubClusterUniqueID
GlueSubClusterName: $glueSubClusterName
GlueSubClusterPhysicalCPUs: $glueSubClusterPhysicalCPUs
GlueSubClusterLogicalCPUs: $glueSubClusterLogicalCPUs
GlueChunkKey: GlueClusterUniqueID=$glueClusterUniqueID
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2
";
}

sub write_site_entries($$){
    my $site_id=shift;
    my $cluster_comment=shift;
    my $cluster_support=shift;
    my $loc=shift;
    my $lat=shift;
    my $long=shift;
    my $siteweb=shift;
    my $s_owner=shift;
    my @owner=@{$s_owner};
    print "
dn: GlueSiteUniqueID=$site_id,mds-vo-name=resource,o=grid
objectClass: GlueTop
objectClass: GlueSite
objectClass: GlueKey
objectClass: GlueSchemaVersion
GlueSiteUniqueID: $site_id
GlueSiteName: $site_id
GlueSiteDescription: ARC-$cluster_comment
GlueSiteUserSupportContact: mailto: $cluster_support
GlueSiteSysAdminContact: mailto: $cluster_support
GlueSiteSecurityContact: mailto: $cluster_support
GlueSiteLocation: $loc
GlueSiteLatitude: $lat
GlueSiteLongitude: $long
GlueSiteWeb: $siteweb";

    for (my $i=1; $i<=$#owner; $i++){
	print "\nGlueSiteSponsor: $owner[$i]";
    }

    print "
GlueSiteOtherInfo: Middleware=ARC
GlueForeignKey: None
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2

";
}    

sub write_gluece_entries(){
    my $s_ldif=shift;
    my @ldif = @{$s_ldif};
    my $is_queue="false";
    my @tmp_queue;

    foreach(@ldif){
	push @tmp_queue, $_;
	if(m/^dn:\s+nordugrid-queue-name/){
	    $is_queue="true";
	    undef @tmp_queue;
	}
	
	if( ( (m/^\s*$/) || (m/^EOF/) ) && ( $is_queue eq "true" )  ){
	    $is_queue = "false";
	    
	    #Set the queue attributes from the ldif
	    for my $key ( keys %%queue_attributes ) {
		$queue_attributes{$key} = join (" ", grep { /^$key/ } @tmp_queue);
		chomp $queue_attributes{$key};
		
		if ($key eq "nordugrid-queue-opsys"){
		    $queue_attributes{$key}=~s/$key//g;
		} else {
		    $queue_attributes{$key}=~s/$key: //g;
		}
		if ($queue_attributes{$key}=~/^$/) { $queue_attributes{$key}="$DEFAULT" }
		
	    }
	    
	    #set non-numeric values to $DEFAULT if they are on the list
	    for (my $i=0; $i<=$#queue_attributes_num; $i++){
		if (! ($queue_attributes{$queue_attributes_num[$i]} =~ /^\d+$/) ){
		    #print "XXX Change $queue{$queue_num[$i]} to $DEFAULT\n";
		    $queue_attributes{$queue_attributes_num[$i]} = $DEFAULT;
		}
	    }


	    if ($cluster_attributes{'nordugrid-cluster-homogeneity'} =~ /false/i){

		$glueSubClusterUniqueID=$queue_attributes{'nordugrid-queue-name'}; ##XX
		$norduOpsys=$queue_attributes{'nordugrid-queue-opsys'}; ##XX
		$norduBenchmark=$queue_attributes{'nordugrid-queue-benchmark'}; ##XX
		$norduNodecpu=$queue_attributes{'nordugrid-queue-nodecpu'}; ##XX
		$glueHostMainMemoryRAMSize=$queue_attributes{'nordugrid-queue-nodememory'}; ##XX
		$glueHostArchitecturePlatformType=$queue_attributes{'nordugrid-queue-architecture'}; ##XX
		$glueSubClusterUniqueID=$queue_attributes{'nordugrid-queue-name'};  ##XX
		$glueSubClusterName=$queue_attributes{'nordugrid-queue-name'};  ##XX
		if ( $processorOtherDesc =~ m/Cores=(\d+)/ ){
		    $smpSize=$1;
		    $glueSubClusterPhysicalCPUs=int($queue_attributes{'nordugrid-queue-totalcpus'}/$smpSize);
		}
		else {
		    $smpSize=1;
		    $glueSubClusterPhysicalCPUs=$queue_attributes{'nordugrid-queue-totalcpus'};
		}
		$glueSubClusterLogicalCPUs=$queue_attributes{'nordugrid-queue-totalcpus'};  ##XX
		$glueClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'};  ##XX

		WriteSubCluster();
	    }
	    

	    $AssignedSlots = 0;
	    if ($queue_attributes{'nordugrid-queue-totalcpus'} ne $DEFAULT){
		$AssignedSlots = $queue_attributes{'nordugrid-queue-totalcpus'};
	    } elsif ($queue_attributes{'nordugrid-queue-maxrunning'} ne $DEFAULT)  {
		$AssignedSlots = $queue_attributes{'nordugrid-queue-maxrunning'};
	    } elsif ($cluster_attributes{'nordugrid-cluster-totalcpus'} ne $DEFAULT)  {
		$AssignedSlots = $cluster_attributes{'nordugrid-cluster-totalcpus'};
	    }
	    
	    if ($queue_attributes{'nordugrid-queue-totalcpus'} eq $DEFAULT){
		$queue_attributes{'nordugrid-queue-totalcpus'} = $cluster_attributes{'nordugrid-cluster-totalcpus'};
	    }
	    
	    $mappedStatus="";
	    if ($queue_attributes{'nordugrid-queue-status'} eq "active"){
		$mappedStatus = "Production";
	    } else{
		$mappedStatus = "Closed";
	    }
	    
	    $waitingJobs = 0;
	    if ($queue_attributes{'nordugrid-queue-gridqueued'} ne $DEFAULT) {$waitingJobs += $queue_attributes{'nordugrid-queue-gridqueued'};}
	    if ($queue_attributes{'nordugrid-queue-localqueued'} ne $DEFAULT) {$waitingJobs += $queue_attributes{'nordugrid-queue-localqueued'};}
	    if ($queue_attributes{'nordugrid-queue-prelrmsqueued'} ne $DEFAULT) {$waitingJobs += $queue_attributes{'nordugrid-queue-prelrmsqueued'};}
	    
	    $totalJobs = $waitingJobs;
	    if ($queue_attributes{'nordugrid-queue-running'} ne $DEFAULT) { $totalJobs += $queue_attributes{'nordugrid-queue-running'}; }

	    $freeSlots=$DEFAULT;
	    if ( ($queue_attributes{'nordugrid-queue-totalcpus'} ne $DEFAULT) && ($queue_attributes{'nordugrid-queue-running'} ne $DEFAULT) ){
		$freeSlots = $queue_attributes{'nordugrid-queue-totalcpus'} - $queue_attributes{'nordugrid-queue-running'};
	    }
	    
	    # Get an arbitrary approximate of how long a job may
	    # expect to wait at this site, it depends on jobs that are
	    # currently running and jobs that are waiting. Formula
	    # aquired from Kalle Happonen and the "NDGF BDII" for LHC
	    # T1 services
	    if ( $queue_attributes{'nordugrid-queue-maxrunning'} ne $DEFAULT ) {
           $estRespTime = int(600 + ($queue_attributes{'nordugrid-queue-running'} /$queue_attributes{'nordugrid-queue-maxrunning'}) *3600 + ($waitingJobs /$queue_attributes{'nordugrid-queue-maxrunning'}) * 600 );
        } else {
           $estRespTime = $DEFAULT;
        }
	    $worstRespTime = $estRespTime + 2000;
	    my @vos= split / /, $cluster_attributes{'nordugrid-cluster-acl'};
        
        my $ce_unique_id=build_glueCEUniqueID($cluster_attributes{'nordugrid-cluster-name'},
						  $cluster_attributes{'nordugrid-cluster-lrms-type'},
						  $queue_attributes{'nordugrid-queue-name'});

	    # Write CE Entries
	    
	    print "
dn: GlueCEUniqueID=$ce_unique_id,mds-vo-name=resource,o=grid
objectClass: GlueCETop
objectClass: GlueCE
objectClass: GlueSchemaVersion
objectClass: GlueCEAccessControlBase
objectClass: GlueCEInfo
objectClass: GlueCEPolicy
objectClass: GlueCEState
objectClass: GlueInformationService
objectClass: GlueKey
GlueCEUniqueID: $ce_unique_id
GlueCEHostingCluster: $cluster_attributes{'nordugrid-cluster-name'}
GlueCEName: $queue_attributes{'nordugrid-queue-name'}
GlueCEInfoGatekeeperPort: 2811
GlueCEInfoHostName: $cluster_attributes{'nordugrid-cluster-name'}
GlueCEInfoLRMSType: $cluster_attributes{'nordugrid-cluster-lrms-type'}
GlueCEInfoLRMSVersion: $cluster_attributes{'nordugrid-cluster-lrms-version'}
GlueCEInfoGRAMVersion: $DEFAULT
GlueCEInfoTotalCPUs: $queue_attributes{'nordugrid-queue-totalcpus'}
GlueCECapability: CPUScalingReferenceSI00=$CPUSCALINGREFERENCESI00
GlueCECapability: Share=cms:20
GlueCECapability: Share=lhcb:27
GlueCECapability: Share=atlas:49
GlueCECapability: Share=alice:2
GlueCECapability: Share=other:2
GlueCEInfoJobManager: arc
GlueCEInfoContactString: $cluster_attributes{'nordugrid-cluster-contactstring'}?queue=$queue_attributes{'nordugrid-queue-name'}
GlueInformationServiceURL: ldap://$cluster_attributes{'nordugrid-cluster-name'}:$BDIIPORT/mds-vo-name=resource,o=grid
GlueCEStateEstimatedResponseTime: $estRespTime
GlueCEStateRunningJobs: $queue_attributes{'nordugrid-queue-running'}
GlueCEStateStatus: $mappedStatus
GlueCEStateTotalJobs: $totalJobs
GlueCEStateWaitingJobs: $waitingJobs
GlueCEStateWorstResponseTime: $worstRespTime
GlueCEStateFreeJobSlots: $freeSlots
GlueCEStateFreeCPUs: $freeSlots
GlueCEPolicyMaxCPUTime: 6480
GlueCEPolicyMaxRunningJobs: $queue_attributes{'nordugrid-queue-maxrunning'}
GlueCEPolicyMaxTotalJobs: $queue_attributes{'nordugrid-queue-maxqueuable'}
GlueCEPolicyMaxWallClockTime: 7776
GlueCEPolicyPriority: 1
GlueCEPolicyAssignedJobSlots: $AssignedSlots\n";
            foreach (@vos){
                chomp;
                print "GlueCEAccessControlBaseRule: $_\n";
            }
            print "GlueForeignKey: GlueClusterUniqueID=$cluster_attributes{'nordugrid-cluster-name'}
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2
GlueCEImplementationName: ARC-CE
";

            foreach (@vos){
                chomp;
        	$vo = $_;
                my $vob;
        	$vo =~ s/VO:// ;
                if ($vo =~ /(\w+)/ || $vo =~ /(\w+)\./) { $vob = $1; }

                my @pieces = split(/\s+/, $cluster_attributes{'nordugrid-cluster-localse'});
                my $useLocalSE = "";
                foreach my $piece (@pieces)
                {
                   if ($piece =~ /$vob/) { $useLocalSE = $piece; }
                }
                if ($vo =~ /superb/) { $useLocalSE = "srm-superb.gridpp.rl.ac.uk"; }
                if ($useLocalSE eq "") { $useLocalSE = "srm-dteam.gridpp.rl.ac.uk"; }

                my $myVoRunning = getCondorJobsRunning($vo);
                my $myVoIdle = getCondorJobsIdle($vo);
                my $myVoTotal = $myVoRunning + $myVoIdle;

                print "
dn: GlueVOViewLocalID=$vo,GlueCEUniqueID=$ce_unique_id,Mds-Vo-name=resource,o=grid
objectClass: GlueCETop
objectClass: GlueVOView
objectClass: GlueCEInfo
objectClass: GlueCEState
objectClass: GlueCEAccessControlBase
objectClass: GlueCEPolicy
objectClass: GlueKey
objectClass: GlueSchemaVersion
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2
GlueCEInfoDefaultSE: $useLocalSE
GlueCEStateTotalJobs: $myVoTotal
GlueCEInfoDataDir: unset
GlueCEAccessControlBaseRule: VO:$vo
GlueCEStateRunningJobs: $myVoRunning
GlueChunkKey: GlueCEUniqueID=$ce_unique_id
GlueVOViewLocalID: $vo
GlueCEInfoApplicationDir: unset
GlueCEStateWaitingJobs: $myVoIdle
GlueCEStateEstimatedResponseTime: $estRespTime
GlueCEStateWorstResponseTime: $worstRespTime
GlueCEStateFreeJobSlots: $freeSlots
GlueCEStateFreeCPUs: $freeSlots
";
            }
        }
    }
}

sub write_cluster_entries(){
    my $cluster_name=shift;
    my $site_unique_id=shift;
    my $ce_unique_id=build_glueCEUniqueID($cluster_attributes{'nordugrid-cluster-name'},
					  $cluster_attributes{'nordugrid-cluster-lrms-type'},
					  $queue_attributes{'nordugrid-queue-name'});
    print "
dn: GlueClusterUniqueID=$cluster_name,mds-vo-name=resource,o=grid
objectClass: GlueClusterTop
objectClass: GlueCluster
objectClass: GlueSchemaVersion
objectClass: GlueInformationService
objectClass: GlueKey
GlueClusterName: $site_unique_id
GlueClusterService: $cluster_name
GlueClusterUniqueID: $cluster_name
GlueForeignKey: GlueCEUniqueID=$ce_unique_id
GlueForeignKey: GlueSiteUniqueID=$site_unique_id
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2

";
}

sub write_ce_se_binding_entries(){
    my $localse=shift;
    my $ce_unique_id=build_glueCEUniqueID($cluster_attributes{'nordugrid-cluster-name'},
					  $cluster_attributes{'nordugrid-cluster-lrms-type'},
					  $queue_attributes{'nordugrid-queue-name'});
    my $s_storages=shift;
    my @storages=@{$s_storages};
    
    if($localse ne '') {
	print "
dn: GlueCESEBindGroupCEUniqueID=$ce_unique_id,mds-vo-name=resource,o=grid
objectClass: GlueGeneralTop
objectClass: GlueCESEBindGroup
objectClass: GlueSchemaVersion
GlueCESEBindGroupCEUniqueID: $ce_unique_id
";

	foreach (@storages){
	    chomp;
	    print "GlueCESEBindGroupSEUniqueID: $_\n"
	}

	print "GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2
";
	
	foreach (@storages){
	    chomp;
	    print "
dn: GlueCESEBindSEUniqueID=$_,GlueCESEBindGroupCEUniqueID=$ce_unique_id,mds-vo-name=resource,o=grid
objectClass: GlueGeneralTop
objectClass: GlueCESEBind
objectClass: GlueSchemaVersion
GlueCESEBindSEUniqueID: $_
GlueCESEBindCEUniqueID: $ce_unique_id
GlueCESEBindMountInfo: none
GlueCESEBindWeight: 0
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 2
";
	}
    }
}

sub write_service_information () {
    my $serviceuniqueid = shift;
    my $servicename = shift;
    my $glueservicestatus = shift;
    my $glueservicestatusinfo = shift;
    my $serviceendpoint = shift;
    my $serviceversion = shift;
    my $servicetype = shift;
    my $servicewsdl = shift;
    my $s_acb=shift;
    my $s_acr=shift;
    my @accesscontrolbase = @{$s_acb} if defined $s_acb;
    my @accesscontrolrule = @{$s_acr} if defined $s_acr;
    
    print "
dn: GlueServiceUniqueID=$serviceuniqueid,mds-vo-name=resource,o=grid
";
    foreach (@accesscontrolbase) {
	chomp;
	print "
GlueServiceAccessControlBaseRule: $_
";
    }
    print "
GlueServiceStatus: $glueservicestatus
GlueServiceStatusInfo: $glueservicestatusinfo
objectClass: GlueTop
objectClass: GlueService
objectClass: GlueKey
objectClass: GlueSchemaVersion
GlueServiceUniqueID: $serviceuniqueid
";
    foreach (@accesscontrolrule) {
	chomp;
	print "
GlueServiceAccessControlRule: $_
";
    }
    print "
GlueServiceEndpoint: $serviceendpoint
GlueServiceVersion: $serviceversion
GlueSchemaVersionMajor: 1
GlueSchemaVersionMinor: 3
GlueServiceName: $servicename
GlueServiceType: $servicetype
GlueServiceWSDL: $servicewsdl
";
}

#EOF
