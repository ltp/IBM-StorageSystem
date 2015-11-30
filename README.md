## NAME

IBM::StorageSystem - Perl API to IBM StorageSystem CLI

## VERSION

Version 0.01

## SYNOPSIS

IBM::StorageSystem is a Perl module that provides a simple API to the IBM 
StorageSystem CLI.

	use IBM::StorageSystem;

	# Create a IBM::StorageSystem object
	my $ibm = IBM::StorageSystem->new(
					user     => 'admin',
					host     => 'my-StorageSystem',
					key_path => '/path/to/my/.ssh/private_key'
			) or die "Couldn't create object! $!\n";

	# Get a list of our enclosures as IBM::StorageSystem::Enclosure objects
	my @enclosures = $ibm->get_enclosures;

	# Print the status of each enclosure
	map { 
		printf( "Enclosure %s status: %10s\n",
				$_->id,
				$_->status 
		) 
	} @enclosures;

	# Get the status of each PSU in each enclosure as 
	# IBM::StorageSystem::Enclosure::PSU objects
	map { 
		printf( "\tPSU %s status: %s", $_->id, $_->status ) 
	} map { 
		print "--- Enclosure $_->id ---\n"; $ $_->get_psus 
	} @enclosures;

	# Prints something like:
	# --- Enclosure 1 ---
	#     PSU 1 status: online
	#     PSU 2 status: online
	# --- Enclosure 2 ---
	#     PSU 1 status: online
	#     PSU 2 status: online
	# ...

	# Get a list of canisters in the first enclosure as 
	# IBM::StorageSystem::Enclosure::Canister objects
	my @canisters = $enclosures[0]->get_canisters;

	# Get the temperature of just the first canister in the second enclosure
	print "Temperature: ", $ibm->enclosure(2)->canister(1)->temperature, "\n";

	# Prints - Temperature: 39
    ...

## METHODS

### new 

	my $ibm = IBM::StorageSystem->new(
					user     => 'admin',
					host     => 'my-StorageSystem',
					key_path  => '/path/to/my/.ssh/private_key'
			) or die "Couldn't create object! $!\n";

Constructor - creates a new IBM::StorageSystem object.  This method accepts 
three mandatory parameters and one optional parameter, the three mandatory 
parameters are:

- user

    The username of the user with which to connect to the device.

- host

    The hostname or IP address of the device to which we are connecting.

- key\_path

    Either a relative or fully qualified path to the private ssh key valid for the
    user name and device to which we are connecting.  Please note that the 
    executing user must have read permission to this key.

The optional parameter is:

- stats\_threshold

    The period in seconds for which retrieved system statistics will be considered 
    fresh, after which they will be re-retrieved.  If not set, the default value of 
    this parameter is zero meaning that the statistics are not refreshed unless 
    done explicitly via the __refresh__ method of an [IBM:StorageSystem::Statistic](IBM:StorageSystem::Statistic) 
    object.

### auth\_service\_cert\_set

Specifies if the authentication service certificate has been set.

### auth\_service\_configured

True if the auth\_service\_type is configured and either one of the following is 
true:

- The auth\_service\_type is LDAP-only (if at least one LDAP server is configured)
- The auth\_service\_type is TIP-only:
    - The name, password, and URL are established
    - An SSL certificate is created (if an HTTPS URL is available)

### auth\_service\_enabled

True if auth\_service\_type is configured.

### auth\_service\_pwd\_set

Specifies if the authentication password has been set.

### auth\_service\_type

Returns the authentication services type, either; Tivoli Integrated Portal 
(TIP) or Native Lightweight Directory Access Protocol (LDAP)

### auth\_service\_url

Returns the authentication services URL.

### auth\_service\_user\_name

Returns the user name used for authentication services.

### bandwidth

Returns the bandwidth available on the intersystem link for background copy, 
in megabytes per second (MBps).

### cluster\_isns\_IP\_address

Returns the cluster ISNS IP address.

### cluster\_locale

Returns the cluster configured locale.

### cluster\_ntp\_IP\_address

Returns the cluster NTP service address.

### code\_level

Returns the cluster code level.

### console\_IP

Returns the cluster console IP address.

### email\_contact

Returns the clusters email contact information - this value is usually the 
system name.

### email\_contact2

Returns the clusters extended email contact information.

### email\_contact2\_alternate

Returns the clusters extended alternate email contact information.

### email\_contact2\_primary

Returns the clusters extended primary email contact information.

### email\_contact\_alternate

Returns the clusters email contact alternate information.

### email\_contact\_location

Returns the clusters email contact location.

### email\_contact\_primary

Returns the clusters email contact phone number.

### email\_reply

Returns the clusters email reply email.

### email\_state

Returns the clusters email operational state.

### gm\_inter\_cluster\_delay\_simulation

Returns the cluster gm inter cluster delay simulation.

### gm\_intra\_cluster\_delay\_simulation

Returns the cluster gm intra cluster delay simulation.

### gm\_link\_tolerance

Returns the cluster gm link delay tolerance in seconds.

### gm\_max\_host\_delay

Returns the cluster gm maximum host delay value.

### has\_nas\_key

Specifies if the cluster has a NAS key configured.

### id

Returns the cluster ID.

### id\_alias

Returns the cluster ID alias.

### inventory\_mail\_interval

Returns the cluster inventory mail interval period in days.

### iscsi\_auth\_method

Returns the cluster iSCSI authentication method.

### iscsi\_chap\_secret

Returns the iSCSI CHAP secret.

### layer

Returns the cluster layer type; either replication or storage (default).
Replication means the system can create partnerships with Storwize 
StorageSystem Unified. Storage means the system can present storage to 
Storwize StorageSystem Unified.

### location

Returns the cluster location type, either local or remote.

### name

Returns the cluster name.

### partnership

Returns the cluster partnership type, either one of; fully\_configured, 
partially\_configured\_local, partially\_configured\_local\_stopped, not\_present, 
fully\_configured\_stopped, fully\_configured\_remote\_stopped, 
fully\_configured\_local\_excluded, fully\_configured\_remote\_excluded or 
fully\_configured\_exceeded

### rc\_buffer\_size

Returns the cluster resource buffer size assigned for Metro Mirror or Global 
Mirrored Copy Services.

### relationship\_bandwidth\_limit

Returns the cluster relationship bandwidth limit in megabytes per second (MBps).

### space\_allocated\_to\_vdisks

Returns the space allocated to VDisks - this may be in a variable notation 
format.

### space\_in\_mdisk\_grps

Returns the space allocated to MDisk groups - this may be in a variable 
notation format.

### statistics\_frequency

Returns the statistics collection frequency interval.

### statistics\_status

Returns the statistics collection status.

### tier

Returns an array containing the supported tier types for the cluster.

__Note__ that this method returns an array of the available tier types and that 
the ordering of these types is preserved from the CLI output.  The ordering of 
these types can be used to retrieve the tier capacity of each tier type with 
the __tier\_capacity__ command.

### tier\_capacity

Returns the total tier capacity for each tier type in the cluster.

__Note__ that this method returns an array of tier capacity values, the index 
of which corresponds with the array indexes of tier types as returned by the 
__tier__ method.

For example, to print each tier type and the corresponding tier capacity for 
this cluster:

        for ( my $i = 0; $i < scalar @{ $ibm->tier } ; $i++ ) {
                print "Tier: " . $ibm->tier->[$i] .
                        " - Capacity: " . $ibm->tier_capacity->[$i] . "\n"
        }

Returns

### tier\_free\_capacity

Returns the free tier capacity for each tier type in the cluster.

__Note__ that like the __tier__ and __tier\_capacity__ methods, this method also 
returns an array of tier free capacity values, the order of which corresponds 
with the arrays returned by the aforementioned methods.

### time\_zone

Returns the cluster time zone.

### total\_allocated\_extent\_capacity

Returns the clusters total allocated capacity - this may be in a variable 
notation format.

### total\_free\_space

Returns the clusters total free space - this may be in a variable notation 
format.

### total\_mdisk\_capacity

Returns the clusters total MDisk capacity - this may be in a variable notation 
format.

### total\_overallocation

Returns the cluster total overallocation limit.

### total\_used\_capacity

Returns the clusters total used capacity - this may be in a variable notation 
format.

### total\_vdisk\_capacity

Returns the clusters total VDisk capacity - this may be in a variable notation 
format.

### total\_vdiskcopy\_capacity

Returns the clusters total VDisk copy capacity - this may be in a variable 
notation format.

### compression\_cpu\_pc

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for allocated CPU capacity 
utilised for compression.

### cpu\_pc

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for allocated CPU capacity 
utilised for the system.

### drive\_r\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object the average amount of I/O 
operations transferred per second for read operations to drives during the 
sample period.

### drive\_r\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for read operations to drives during the 
sample period.

### drive\_r\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to read requests to 
drives over the sample period.

### drive\_w\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object the average amount of I/O 
operations transferred per second for write operations to drives during the 
sample period.

### drive\_w\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for write operations to drives during the 
sample period.

### drive\_w\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to write requests to 
drives over the sample period.

### fc\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total input/output 
(I/O) operations transferred per seconds for Fibre Channel traffic on the 
system. This value includes host I/O and any bandwidth that is used for 
communication within the system.

### fc\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total number of 
megabytes transferred per second for Fibre Channel traffic on the system. This 
value includes host I/O and any bandwidth that is used for communication within 
the system.

### iscsi\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total I/O 
operations transferred per second for iSCSI traffic on the system.

### iscsi\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total number of 
megabytes transferred per second for iSCSI traffic on the system.

### mdisk\_r\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
I/O operations transferred per second for read operations to MDisks during the 
sample period.

### mdisk\_r\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for read operations to MDisks during the 
sample period.

### mdisk\_r\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to read requests to 
MDisks over the sample period.

### mdisk\_w\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
I/O operations transferred per second for write operations to MDisks during 
the sample period.

### mdisk\_w\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for write operations to MDisks during the 
sample period.

### mdisk\_w\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to write requests to 
MDisks over the sample period.

### sas\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total I/O 
operations transferred per second for SAS traffic on the system. This value 
includes host I/O and bandwidth that is used for background RAID activity.

### sas\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total number of 
megabytes transferred per second for iSCSI traffic on the system.

### total\_cache\_pc

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the total percentage 
for both the write and read cache usage for the node.

### vdisk\_r\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
I/O operations transferred per second for read operations to volumes during 
the sample period.

### vdisk\_r\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for read operations to MDisks during the 
sample period.

### vdisk\_r\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to read requests to 
MDisks over the sample period.

### vdisk\_w\_io

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
I/O operations transferred per second for read operations to drives during the 
sample period. 

### vdisk\_w\_mb

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average number of 
megabytes transferred per second for read operations to drives during the 
sample period

### vdisk\_w\_ms

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the average amount of 
time in milliseconds that the system takes to respond to read requests to 
MDisks over the sample period.

### write\_cache\_pc

Returns an [IBM::StorageSystem::Statistic](https://metacpan.org/pod/IBM::StorageSystem::Statistic) object for the percentage of the 
write cache usage for the node.

### refresh\_system\_stats

This method refreshes all system statistics with updated values from the 
system.  This method may be handy if instantiate an IBM::StorageSystem object 
within a long running or non-exiting process and wish to either periodically 
retrieve updated system statistics.

__Note__ that you can call __refresh__ on individual system statistics which may 
have a slight performance increase over this method.

### stats\_threshold

This method allows you specify the statistics threshold freshness interval in 
seconds. This interval is used to determine if the values returned by a 
statistics method are fresh or whether they should be refreshed from the 
target system.

By default this value is zero, meaning that the statistics are never refreshed 
unless explicitly done so by calling the __refresh__ method of the statistic 
object.  This may result in a performance increase in situations where 
statistic methods are frequently used, and may also result in more consistent 
reporting of the target system state as the statistic values will more closely 
represent a single point in time overview of the system rather than a series 
of consecutive snapshots.

In situation where you may want to gather a set of statistical values for the 
target system over a finite period, you could set the threshold value low, and 
reset it afterwards. e.g.

	# Print the current FC IOPS value every two seconds for a minute
	$ibm->stats_threshold = 1;
	for ( 1 .. 30 ) {
		print $ibm->fc_io_current;
		sleep 2
	}
	# Disable automatic refreshing
	$ibm->stats_threshold = 0;

### cluster\_throughput ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterThroughput](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterThroughput) 
performance data on bytes read and written across all nodes and all GPFS 
filesystems in the cluster.

The method accepts a single optional parameter; the time period for which to 
return the data. The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year. If omitted, this parameter will 
default to minute.



### cluster\_client\_throughput ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterClientThroughput](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterClientThroughput) 
performance data on client throughput across all nodes in the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data. The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_create\_delete\_latency ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterCreateDeleteLatency](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterCreateDeleteLatency) 
performance data on cluster file creation and deletion latency across all 
nodes in the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_create\_delete\_operations ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterCreateDeleteOperations](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterCreateDeleteOperations) 
performance data on cluster file creation and deletion operations across all 
nodes in the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_open\_close\_latency ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterOpenCloseLatency](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterOpenCloseLatency) 
performance data on cluster file open and close latency across all nodes in 
the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_open\_close\_operations ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterCreateDeleteOperations](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterCreateDeleteOperations) 
performance data on cluster file open and close operations across all nodes in 
the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_read\_write\_latency ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterReadWriteLatency](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterReadWriteLatency) 
performance data on cluster file read and write latency across all nodes in 
the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### cluster\_read\_write\_operations ( $interval )

Returns either a single, or list, of [IBM::StorageSystem::StatisticsSet](https://metacpan.org/pod/IBM::StorageSystem::StatisticsSet) 
objects containing [IBM::StorageSystem::Statistics::ClusterReadWriteOperations](https://metacpan.org/pod/IBM::StorageSystem::Statistics::ClusterReadWriteOperations) 
performance data on cluster file read and write operations across all nodes in 
the target cluster.

The method accepts a single optional parameter; the time period for which to 
return the data.  The allowed values for this parameter are one of; minute, 
hour, day, week, month, quarter and year.  If omitted, this parameter will 
default to minute.

### array( $id )

	# Print the capacity and RAID level of array 1 in GB
	my $array = $ibm->array( 1 );
	print "Array 1 capacity: " 
		. int ( $array->capacity / ( 1024 ** 3 ) )
		. " (" . $array->raid_level . ")\n"

	# e.g. Array 1 capacity: 5824G (raid10)

Returns an [IBM::StorageSystem::Array](https://metacpan.org/pod/IBM::StorageSystem::Array) object representing the array 
specified by the numerical id parameter.

__Note__ that this is a caching method and that a previously retrieved 
[IBM::StorageSystem::Array](https://metacpan.org/pod/IBM::StorageSystem::Array) object will be returned if one has been cached 
from previous invocations.

### get\_array( $id )

Returns the array specified by the value of the numerical ID argument as an 
[IBM::StorageSystem::Array](https://metacpan.org/pod/IBM::StorageSystem::Array) object.

__Note__ that this method is non-caching and the array information will always 
be retrieved from the StorageSystem system even if a cached object exists.

### get\_arrays

	# Print the array status of all arrays in our system
        map { 
		print "Array ", $_->mdisk_id, " status ", $_->status, "\n"
	} $ibm->get_arrays;

Returns an array of [IBM::StorageSystem::Array](https://metacpan.org/pod/IBM::StorageSystem::Array) objects representing all 
arrays in the target system.

### disk ( $id ) 

	# Get the disk named "system_vol_00" as an IBM::StorageSystem::Disk 
	# object
	my $disk = $ibm->disk(system_vol_00);
	
	# Print the disk status
	print $disk->status;

	# Alternately
	print $ibm->disk(system_vol_00)->status;

Returns a [IBM::StorageSystem::Disk](https://metacpan.org/pod/IBM::StorageSystem::Disk) object representing the disk specified 
by the value of the id parameter, which should be a valid disk name in the 
target system.

### get\_disk( $id )

This is a functionally equivalent non-caching implementation of the __disk__ 
method.

### get\_disks

	# Print a listing of all disks in the target system including their 
	# name, the assigned pool and status

	printf( "%-20s%-20s%-20s\n", "Name", "Pool", "Status" );
	printf( "%-20s%-20s%-20s\n", "-----", "------", "-------" );

	foreach my $disk ( $ibm->get_disks ) { 
		printf( "%-20s%-20s%-20s\n", 
			$disk->name, 
			$disk->pool, 
			$disk->status ) 
	}

	# Prints something like:
	#
	# Name                Pool                Status              
	# -----               ------              -------             
	# silver_vol_00       silver              ready               
	# silver_vol_01       silver              ready               
	# silver_vol_02       silver              ready    
	# ... etc.

Returns an array of [IBM::StorageSystem::Disk](https://metacpan.org/pod/IBM::StorageSystem::Disk) objects representing all disks 
in the target system.

### drive ( $id ) 

	# Get drive ID 2 as an IBM::StorageSystem::Drive object
        my $drive = $ibm->drive( 2 );

        # Print the drive capacity in bytes
        print $drive->capacity;

	# Alternately;
	print $ibm->drive( 2 )->capacity;

        # Print the drive vendor and product IDs
        print "Vendor ID: ", $drive->vendor_id, 
		" - Product ID: ", $drive->product_id, "\n";

Returns the drive specified by the value of the integer argument as a 
[IBM::StorageSystem::Drive](https://metacpan.org/pod/IBM::StorageSystem::Drive) object.

__note__ that this method implements caching and that a cached object will be 
retrieved if present.

If you require a non-cached object, then use the __get\_drive__ method instead.

### get\_drive( $id )

Returns the drive specified by the value of the integer argument.  This method 
is non-caching and always retrieves information directly from the target 
system even if a cached object is present.

### get\_drives( $id )

        # Print the SAS port status and drive status for all drives in a 
	# nicely formatted list
        printf( "%-20s%-20s%-20s%-20s\n", 
		'Drive', 
		'SAS Port 1 Status', 
		'SAS Port 2 Status', 
		'Status'
	);

        printf( "%-20s%-20s%-20s%-20s\n", 
		'-'x18, 
		'-'x18, 
		'-'x18, 
		'-'x18
	);

        map { 
		printf( "%-20s%-20s%-20s%-20s\n", 
			$_->id, 
			$_->port_1_status, 
			$_->port_2_status, 
			$_->status ) 
	} $ibm->get_drives;

        # e.g.
        # Drive               SAS Port 1 Status   SAS Port 2 Status   Status              
        # ------------------  ------------------  ------------------  ------------------  
        # 0                   online              online              online              
        # 1                   online              online              online              
        # 2                   online              online              online              
        # 3                   online              online              online
        # ...

Returns all drives as an array of [IBM::StorageSystem::Drive](https://metacpan.org/pod/IBM::StorageSystem::Drive) objects.

### enclosure( $id )

	# Print the status of a specific enclosure
        print "Enclosure two status is " 
		. $ibm->enclosure(2)->status . "\n";

        # Get all PSUs in an enclosure as 
	# IBM::StorageSystem::Enclosure::PSU objects.
        my @psus = $ibm->enclosure(1)->psus;

Returns the enclosure specified by the numerical identifier of the id parameter 
as an [IBM::StorageSystem::Enclosure](https://metacpan.org/pod/IBM::StorageSystem::Enclosure) object.

__Note__ that this is a caching method and that a cached object will be 
returned if one is present.  If you require a non-cached result, then please 
use the __get\_enclosure__ method.

### get\_enclosure( $id )

This method is a functionally equivalent non-caching implementation of the 
__enclosure__ method.

### get\_enclosures

        # Print the status of each enclosure in our system.
        foreach my $enclosure ( $ibm->get_enclosures ) {
                print "Enclosure ", $enclosure->id, 
			" status: ", $enclosure->status, "\n"
        }

Returns an array of [IBM::StorageSystem::Enclosure](https://metacpan.org/pod/IBM::StorageSystem::Enclosure) objects representing all 
enclosures present in the target system.

### get\_exports

        # Print a listing of all configured exports containing the export 
	# name, the export path, the export protocol and the export status.

        printf( "%-20s%-40s%-10s%-10s\n", 
		'Name', 
		'Path', 
		'Protocol', 
		'Active' 
	);

        foreach my $export ( $ibm->get_exports ) { 
                print '-'x100,"\n";
                printf( "%-20s%-40s%-10s%-10s\n", 
			$export->name, 
			$export->path, 
			$export->protocol, 
			$export->active 
		)
        }

        # Prints something like:
        #
        #Name                Path                                    Protocol  Active    
        # ----------------------------------------------------------------------------------------------------
        # homes_root          /ibm/fs1/homes                          NFS       true      
        # ----------------------------------------------------------------------------------------------------
        # shares_root         /ibm/fs1/shares                         NFS       true      
        # ----------------------------------------------------------------------------------------------------
        # test                /ibm/fs1/test                           CIFS      true      
        # ----------------------------------------------------------------------------------------------------
        # ... etc.

Returns all configured exports on the target system as an array of 
[IBM::StorageSystem::Export](https://metacpan.org/pod/IBM::StorageSystem::Export) objects.

### get\_fabrics

        # Print a list of our fabrics (sorted by fabric ID) including the 
	# fabric ID, node ID, port ID, local WWPN, remote WWPN and fabric 
	# status.

        printf( "%-5s%-8s%-8s%-20s%-20s%-10s\n", 
		'ID', 
		'Node', 
		'Port', 
		'Local WWPN', 
		'Remote WWPN', 
		'Status'
	);
        print '-'x80,"\n";

        for my $fabric ( map { $_->[0] } 
			 sort { $a->[1] cmp $b->[1] } 
			 map { [$_, $_->id] } $ibm->get_fabrics 
		) {
                printf( "%-5s%-8s%-8s%-20s%-20s%-10s\n", 
			$fabric->id, 
			$fabric->node_name, 
			$fabric->local_port,
                        $fabric->local_wwpn, 
			$fabric->remote_wwpn, 
			$fabric->state 
		)
        }

        # Prints something like:
        #
        # ID   Node    Port    Local WWPN          Remote WWPN         Status    
        # --------------------------------------------------------------------------------
        # 1    node1   1       5005076802159D73    21000024FF43DE7B    active    
        # 1    node1   2       5005076802259D73    21000024FF35B8FC    active    
        # 2    node2   1       5005076802159D74    21000024FF43DE7A    active    
        # 2    node2   2       5005076802259D74    21000024FF35B8FD    active 

Returns all configured fabrics on the target system as an array of 
[IBM::StorageSystem::Fabric](https://metacpan.org/pod/IBM::StorageSystem::Fabric) objects.

### filesystem( $filesystem\_name )

        # Print the block size of file system 'fs1'
        print $ibm->filesystem(fs1)->block_size;
        
        # Get the file system 'fs2' as a IBM::StorageSystem::FileSystem object
        my $fs = $ibm->filesystem(fs2);

        # Print the mount point of this file system
        print "fs2 mount point: " . $fs->mount_point . "\n";

        # Call a function if inode usage on file system 'fs2' exceeds 90% of 
	# maximum allocation.
	monitoring_alert( 'Inode allocation > 90% on '.$filesystem->device_name ) 
                if ( ( ( $fs->inodes / $fs->max_inodes ) * 100 ) > 90 );

Returns the file system specified by the value of the named parameter as a 
[IBM::StorageSystem::FileSystem](https://metacpan.org/pod/IBM::StorageSystem::FileSystem) object.

Note that this is a caching method and a cached object will be retrieved if 
one exists,  If you require a non-cached object, then please use the 
__get\_filesystem__ method.

### get\_filesystem( $filesystem\_name )

This is a non-caching functionally equivalent implementation of the 
__filesystem__ method.  Use this method if you require the file system 
information to be retrieved directly from the target system rather than cache.

### get\_filesystems

        # Do the same for all file systems
        map { 
		monitoring_alert( 'Inode allocation > 90% on '.$_->device_name )
                if ( ( ( $fs->inodes / $fs->max_inodes ) * 100 ) > 90 ) 
	} $ibm->get_filesystems;

Returns an array of [IBM::StorageSystem::FileSystem](https://metacpan.org/pod/IBM::StorageSystem::FileSystem) objects representing all 
configured file systems on the target system.

### get\_healths

        # Simple one-liner to print the sensor status and value for any error 
	# conditions.
        map { 
		print join ' -> ', ( $_->sensor, $_->value."\n" ) 
	} grep { 
		$_->status =~ /ERROR/ 
	} $ibm->get_healths;

        # e.g.
        # CLUSTER -> Alert found in component cluster
        # MDISK -> Alert found in component mdisk
        # NODE -> Alert found in component node

Returns an array of [IBM::StorageSystem::Health](https://metacpan.org/pod/IBM::StorageSystem::Health) objects representative of 
all health sensors on the target system.

__Note__ that this method is only implemented on StorageSystem Unified systems 
and not StorageSystem SONAS systems.

### host( $hostname )

	# Print the host status of the attached host 'sauron'
	print "Status: " . $ibm->host(sauron)->status . "\n";

Returns the host specified by the value of the named host parameter as an 
[IBM::StorageSystem::Host](https://metacpan.org/pod/IBM::StorageSystem::Host) object.

__Note__ that this is a caching method and a cached object will be returned if 
one exists.  If you require a non-cached object, then please use the 
__get\_host__ method.

### get\_host( $hostname )

This is a functionally equivalent non-caching implementation of the __host__ 
method.

### get\_hosts

        # Print a list of all configured hosts sorted by hostname, their 
	# WWPNs, port state and login status.

        foreach $host ( map { $_->[0] } 
			sort { $a->[1] cmp $b->[1] } 
			map { [ $_, $_->name ] } $ibm->get_hosts 
		) { 
                my $c = 0;

                foreach $wwpn ( @{ $host->WWPN } ) { 
                        print ( $c ? "\t" : ('-'x100)."\n".$host->name );
                        print "\t\t\t$wwpn\t" . @{ $host->state }[$c] . "\t\t" .
                                ( @{$host->node_logged_in_count }[$c] ? '' : 'not ' ) 
				. "logged in\n";
                        $c++
                }   
        }

        # Prints something similar to:
        # ----------------------------------------------------------------------------------------------------
        # host-3                        2101001B32A3D94C        active          logged in
        #                               2100001B3283D94C        active          logged in
        # ----------------------------------------------------------------------------------------------------
        # host-4                        2100001B320786E7        active          logged in
        #                               2101001B322786E7        active          logged in
        # ----------------------------------------------------------------------------------------------------
        # storage-2                     210100E08BB40A08        offline         not logged in
        #                               210000E08B940A08        offline         not logged in
        # ... etc.

Returns an array of [IBM::StorageSystem::Host](https://metacpan.org/pod/IBM::StorageSystem::Host) objects representing all host 
attached to the target system.

### iogroup( $id )

        # Get I/O group 0
        my $io_group = $ibm->get_iogroup(0);

        # Print the I/O group maintenance state
        print $io_group->maintenance_state;

        # Alternately:
        print $ibm->iogroup(0)->maintenance_state;

Returns the I/O group identified by the value of the numerical ID parameter as 
an [IBM::StorageSystem::IOGroup](https://metacpan.org/pod/IBM::StorageSystem::IOGroup) object.

__Note__ that this method implements caching and a cached object will be 
returned should one be present.  If you require a non-cached object then 
please use the __get\_iogroup__ method.

### get\_iogroup( $id )

This is a functionally equivalent non-caching implementation of the 
__iogroup__ method.

### get\_iogroups

        # Print a formatted listing of all I/O groups by ID and name, along 
	# with their VDisk count, host count, node count and maintenance state.
        map { printf( "%-8s%-20s%-20s%-20s%-20s%-20s\n", 
                $_->id,
                $_->name,
                $_->vdisk_count,
                $_->host_count,
                $_->node_count,
                $_->maintenance )
        } $ibm->get_iogroups;

        # Prints something like:
        #
        # ID      Name                VDisk Count         Host Count          Node Count          Maintenance         
        # 0       io_grp0             2                   3                   2                   no                  
        # 1       io_grp1             0                   3                   0                   no                  
        # 2       io_grp2             0                   3                   0                   no                  
        # 3       io_grp3             0                   3                   0                   no
        # ... etc.

Returns an array of [IBM::StorageSystem::IOGroup](https://metacpan.org/pod/IBM::StorageSystem::IOGroup) objects representing all 
configured I/O groups on the target system.

### interface ( $id )

	# Get interface ethX0 on management node mgmt001st001 as an 
	# IBM::StorageSystem::Interface object
        # Print the interface status
        print $interface->up_or_down;

        # Print the interface status
        print $interface->speed;

        # Alternately;
        print $ibm->interface('mgmt001st001:ethX0')->speed;

Returns the interface identified by the value of the id parameter as an 
[IBM::StorageSystem::Interface](https://metacpan.org/pod/IBM::StorageSystem::Interface) object.

The value of the id parameter must be a valid node and interface name 
separated by a colon.

__Note__ that this method implements caching and a cached object will be 
returned should one be present.  If you require a non-cached object then 
please use the __get\_iogroup__ method.

### get\_interface( $id )

This is a functionally equivalent non-caching implementation of the 
__interface__ method.

### get\_interfaces

        # Print a list of all interfaces, their status, speed and role
        
        foreach my $interface ( $ibm->get_interfaces ) {
                print "Interface: " . $interface->interface . "\n";
                print "\tStatus: " . $interface->up_or_down . "\n";
                print "\tSpeed: " . $interface->speed . "\n";
                print "\tRole: " . $interface->isubordinate_or_master 
			. "\n----------\n";
        }

Returns an array of [IBM::StorageSystem::Interface](https://metacpan.org/pod/IBM::StorageSystem::Interface) objects representing all 
interfaces on the target system.

### mount( $mount )

	# Print mount status of file system fs1
	print "Mount status: " . $ibm->mount(fs1) . "\n";

	# Print only those file system that are not mounted
	map  { print $_->file_system . " is not mounted.\n" }
	grep { $_->mount_status ne 'mounted' }
	$ibm->get_mounts;

Returns the mount identified by the mount parameter as a 
[IBM::StorageSystem::Mount](https://metacpan.org/pod/IBM::StorageSystem::Mount) object.

__Note__ that this method implements caching and a cached object will be 
returned should one be present.  If you require a non-cached object then 
please use the __get\_iogroup__ method.

### get\_mount( $mount )

This is a functionally equivalent non-caching implementation of the 
__mount__ method.

### get\_mounts

This method returns an array of [IBM::StorageSystem::Mount](https://metacpan.org/pod/IBM::StorageSystem::Mount) objects 
representing all mounts on the target system.

### node( $node )

        # Get node mgmt001st001 as an IBM::StorageSystem::Node object
        my $node = $ibm->node( mgmt001st001 );
        
        # Print the node description
        print "Description: " . $node->description . "\n";

        # Prints something like: "Description: active management node"
        # Or alternately;
        print "Description: " . $ibm->node( mgmt001st001 )->description . "\n";



Returns the node identified by the value of the node parameter as a 
[IBM::StorageSystem::Node](https://metacpan.org/pod/IBM::StorageSystem::Node) object.

__Note__ that this method implements caching and that a cached object will be 
returned if one is available.  If you require a non-cached object, then please 
use the non-caching __get\_node__ method.

### get\_node( $node )

This is a functionally equivalent non-caching implementation of the __node__ 
method.

### get\_nodes

        # Print the GPFS and CTDB statuses of all nodes
        foreach my $node ( $ibm->get_nodes ) {
                print "GPFS status: " . $node->GPFS_status 
			. " - CTDB status: " . $node->CTDB_status . "\n"
        }

Returns an array of [IBM::StorageSystem::Node](https://metacpan.org/pod/IBM::StorageSystem::Node) objects representing all 
configured nodes on the target system.

### pool( $pool )

Returns the pool identified by the value of the node parameter as a 
[IBM::StorageSystem::Pool](https://metacpan.org/pod/IBM::StorageSystem::Pool) object.

__Note__ that this method implements caching and that a cached object will be 
returned if one is available.  If you require a non-cached object, then please 
use the non-caching __get\_pool__ method.

### get\_pool( $pool )

This is a functionally equivalent non-caching implementation of the __pool__ 
method.

### get\_pools( $pool )

Returns an array of [IBM::StorageSystem::Pool](https://metacpan.org/pod/IBM::StorageSystem::Pool) objects representing all 
configured pools on the target system.

### replication( $eventlog\_id )

Returns the replication event identified by the eventlog\_id parameter as an 
[IBM::StorageSystem::Replication](https://metacpan.org/pod/IBM::StorageSystem::Replication) object.

__Note__ that this method implements caching and that a cached object will be 
returned if one is available.  If you require a non-cached object, then please 
use the non-caching __get\_node__ method.

### get\_replication( $eventlog\_id )

This is a functionally equivalent non-caching implementation of the 
__replication__ method.

### get\_replications

        use Date::Calc qw(date_to_Time Today_and_Now);

        my $ibm = IBM::StorageSystem->new(      
					user     => 'admin',
                                        host     => 'my-v7000',
                                        key_path => '/path/to/my/.ssh/private_key'
                                ) or die "Couldn't create object! $!\n";

        # Generate an alert for any replication errors in the last six hours

        foreach my $task ( $ibm->get_replications ) {

                if ( $task->status eq 'ERROR' 
			and ( Date_to_Time( Today_and_Now ) - 
				( Date_to_Time( split /-| |\./, $task->time ) ) 
			) < 21_600 
		) {
                        alert( "Replication failure for filesystem " 
				. $task->filesystem . " - log ID: " 
				. $task->log_id . 
			)
                }

        }

Returns all asynchronous replication tasks as an array of 
[IBM::StorageSystem::Replication](https://metacpan.org/pod/IBM::StorageSystem::Replication) objects.

### service( $service )

        # Print the enabled status of the NFS service
        print $ibm->service(NFS)->enabled;

        # Print the configured and enabled status of all services
        printf( "%-20s%-20s%-20s\n", 'Service', 'Configured', 'Active' );
        map { 
		printf( "%-20s%-20s%-20s\n",
			$_->name,
			$_->configured,
			$_->active 
		)
	} $ibm->get_services;

Returns a [IBM::StorageSystem::Service](https://metacpan.org/pod/IBM::StorageSystem::Service) object representing the service 
identified by the value of the service parameter.

__Note__ that this method implements caching and that a cached object will be 
returned if one is available.  If you require a non-cached object, then please 
use the non-caching __get\_node__ method.

### get\_service( $service )

This is a functionally equivalent non-caching implementation of the __service__ 
method.

### get\_services

Returns an array of [IBM::StorageSystem::Service](https://metacpan.org/pod/IBM::StorageSystem::Service) objects representing all 
configured services on the target system.

### task( $task )

	# Print the status of the SNAPSHOTS task
	my $snapshots = $ibm->task(SNAPSHOTS);
	print "Status: " . $snapshots->status . "\n";

	# Alternately
	print "Status: " . $ibm->task(SNAPSHOTS)->status . "\n";

Return the task identified by the value of the task parameter as an 
[IBM::StorageSystem::Task](https://metacpan.org/pod/IBM::StorageSystem::Task) object.

__Note__ that this method implements caching and that a cached object will be 
returned if one is available.  If you require a non-cached object, then please 
use the non-caching __get\_node__ method.

### get\_task( $task )

This is a functionally equivalent non-caching implementation of the __task__ 
method.

### get\_tasks

	# Call an alert function for any tasks that are not in an OK state
	map { alert( $_->name ) } grep { $_->status ne 'OK' } $ibm->get_tasks;

Returns an array of [IBM::StorageSystem::Task](https://metacpan.org/pod/IBM::StorageSystem::Task) objects representing all tasks 
on the target system.

### vdisk( $id )

        # Get the VDisk ID 3 and print the VDisk UUID
        my $vdisk = $ibm->vdisk(3);
        print $vdisk->vdisk_UUID;

        # Alternately:
        print $ibm->vdisk(3)->vdisk_UUID;

Returns an [IBM::StorageSystem::VDisk](https://metacpan.org/pod/IBM::StorageSystem::VDisk) object representing the VDisk 
identified by the numerical ID parameter.

__Note__ that this method implements caching to improve performance and reduce 
network overhead, and that a cached object will be returned if one is present.
If you require a non-cached object then please use the __get\_vdisk__ method.

### get\_vdisk( $id )

This is a functionally equivalent non-caching implementation of the __vdisk__ 
method.

### get\_vdisks

        # Print the name, ID, capacity in GB and MDisk group name of all 
	# VDisks in a nicely formatted output
        printf( "%-20s%-8s%-15s%20s\n", 
		'Name',
		'ID',
		'Capacity (GB)',
		'MDisk Group Name'
	);

        printf( "%-20s%-8s%-15s%20s\n", 
		'-'x18,
		'-'x4,
		'-'x12,
		'-'x15 
	);

        map { 
		printf( "%-20s%-8s%-15s%20s\n", 
			$_->name, 
			$_->id, 
			(int($_->capacity / (1024**3))), 
			$_->mdisk_grp_name
		)
	} grep { 
		$_->status eq 'online' 
	} $ibm->get_vdisks;

        # Should print something like:
        # Name                ID      Capacity (GB)      MDisk Group Name
        # ------------------  ----    ------------       ---------------
        # file-host-1         0       5823               FILE_POOL
        # backup-host-2       1       2330               BACKUP_POOL
        # ... etc.

Returns all configured VDisks in the target system as an array of 
[IBM::StorageSystem::VDisk](https://metacpan.org/pod/IBM::StorageSystem::VDisk) objects.

### get\_quotas 

	# Call a function to send a quota warning email for any quotas where 
	# the current usage exceeds 85% of the quota usage hard limit.

	map  { send_quota_warning_email( $_ )		}
	grep { ( $_->used_usage / $_->HL_usage ) > 0.85 }
	grep { $_->name ne 'root'			}
	grep { $_->type eq 'U' } $ibm->get_quotas;

Returns all quotas defined on the target system as an array of 
[IBM::StorageSystem::Quota](https://metacpan.org/pod/IBM::StorageSystem::Quota) objects.

## AUTHOR

Luke Poskitt, `<ltp at cpan.org>`

## BUGS

Please report any bugs or feature requests to 
`bug-ibm-StorageSystem at rt.cpan.org`, or through the web interface at 
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=IBM-StorageSystem](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=IBM-StorageSystem).  I will 
be notified, and then you'll automatically be notified of progress on your bug 
as I make changes.

## SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc IBM::StorageSystem

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=IBM-StorageSystem](http://rt.cpan.org/NoAuth/Bugs.html?Dist=IBM-StorageSystem)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/IBM-StorageSystem](http://annocpan.org/dist/IBM-StorageSystem)

- CPAN Ratings

    [http://cpanratings.perl.org/d/IBM-StorageSystem](http://cpanratings.perl.org/d/IBM-StorageSystem)

- Search CPAN

    [http://search.cpan.org/dist/IBM-StorageSystem/](http://search.cpan.org/dist/IBM-StorageSystem/)

## LICENSE AND COPYRIGHT

Copyright 2012 Luke Poskitt.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


