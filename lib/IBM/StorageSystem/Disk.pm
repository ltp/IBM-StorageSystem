package IBM::StorageSystem::Disk;

use strict;
use warnings;

use Carp qw(croak);

our $VERSION = '0.01';
our @ATTR = qw(Name File_system Failure_group Type Pool Status Availability Timestamp Block_properties);

foreach my $attr ( map lc, @ATTR ) { 
        {   
                no strict 'refs';
                *{ __PACKAGE__ .'::'. $attr } = sub {
                        my( $self, $val ) = @_; 
                        $self->{$attr} = $val if $val;
                        return $self->{$attr}
                }   
        }   
}

sub new {
        my( $class, $ibm, %args ) = @_; 
        my $self = bless {}, $class;
        defined $args{Name} or croak 'Constructor failed: mandatory Name argument not supplied';

        foreach my $attr ( @ATTR ) { $self->{lc $attr} = $args{$attr} }

        return $self
}

1;

__END__

=pod

=head1 NAME

IBM::StorageSystem::Disk - Class for operations with IBM StorageSystem disks

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

IBM::StorageSystem::Disk is a utility class for operations with IBM StorageSystem disks.

        use IBM::StorageSystem;
        
        my $ibm = IBM::StorageSystem->new(      user            => 'admin',
                                        host            => 'my-v7000',
                                        key_path        => '/path/to/my/.ssh/private_key'
                                ) or die "Couldn't create object! $!\n";

	# Get drive ID 2 as an IBM::StorageSystem::Drive object - note that drive ID 2 
	# is not necessarily the physical disk in slot ID 2 - see notes below.
	my $drive = $ibm->drive( 2 );

	# Print the drive capacity in bytes
	print $drive->capacity;
	
	# Print the drive vendor and product IDs
	print "Vendor ID: ", $drive->vendor_id, " - Product ID: ", $drive->product_id, "\n";
	
	# Print the SAS port status and drive status for all drives in a nicely formatted list
	printf("%-20s%-20s%-20s%-20s\n", 'Drive', 'SAS Port 1 Status', 'SAS Port 2 Status', 'Status');
	printf("%-20s%-20s%-20s%-20s\n", '-'x18, '-'x18, '-'x18, '-'x18);
	map { printf( "%-20s%-20s%-20s%-20s\n", $_->id, $_->port_1_status, $_->port_2_status, $_->status) } $ibm->get_drives;

	# e.g.
	# Drive               SAS Port 1 Status   SAS Port 2 Status   Status              
	# ------------------  ------------------  ------------------  ------------------  
	# 0                   online              online              online              
	# 1                   online              online              online              
	# 2                   online              online              online              
	# 3                   online              online              online
	# ...

	# Print the drive ID, slot ID, MDisk name and member ID of all drives
        foreach my $drive ( $ibm->get_drives ) { 
                print '-'x50, "\n";
                print "Drive ID  : " . $drive->id . "\n";
                print "Slot ID   : " . $drive->slot_id . "\n";
                print "MDisk ID  : " . $drive->mdisk_name . "\n";
                print "Member ID : " . $drive->member_id . "\n";
        } 

	# e.g.	
	# --------------------------------------------------
	# Drive ID  : 0
	# Slot ID   : 17
	# MDisk ID  : host-9
	# Member ID : 3
	# --------------------------------------------------
	# Drive ID  : 1
	# Slot ID   : 19
	# MDisk ID  : host-2
	# Member ID : 11
	# --------------------------------------------------
	# Drive ID  : 2
	# Slot ID   : 19
	# MDisk ID  : host-1
	# Member ID : 8
	# --------------------------------------------------
	# ... etc.


=head1 METHODS

=head3 availability

Returns the disk availability status.

=head3 block_properties

Returns a comma-separated list of the disk block properties.

=head3 failure_group

Returns the disk failure group.

=head3 file_system

Returns the file system to which the disk is allocated.

=head3 name

Returns the name of the disk.

=head3 pool

Returns the pool of which the disk is a member.

=head3 status

Returns the disk status.

=head3 timestamp

Returns a timestamp of the last time at which the CTDB disk information was updated.

=head3 type

Returns the disk type.

=head1 AUTHOR

Luke Poskitt, C<< <ltp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ibm-v7000-disk at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=IBM-StorageSystem-Disk>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc IBM::StorageSystem::Disk


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=IBM-StorageSystem-Disk>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/IBM-StorageSystem-Disk>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/IBM-StorageSystem-Disk>

=item * Search CPAN

L<http://search.cpan.org/dist/IBM-StorageSystem-Disk/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Luke Poskitt.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
