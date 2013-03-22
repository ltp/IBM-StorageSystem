package IBM::StorageSystem::Statistic::ClusterOpenCloseOperations;

use strict;
use warnings;

use Carp qw(croak);

our @ATTR = qw(start_time end_time open_operations close_operations);

foreach my $attr ( @ATTR ) { 
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
        my( $class, @vals ) = @_; 
        my $self = bless {}, $class;
        my $c = 0;

        foreach my $attr ( @ATTR ) { $self->{$attr} = $vals[$c]; $c++ }

        return $self
}

sub _values { return @ATTR }

1;

__END__

=pod

=head1 NAME

IBM::StorageSystem::Statistic::ClusterOpenCloseOperations - Utility class for IBM::StorageSystem cluster open and close
operations performance data.

=head1 SYNOPSIS

IBM::StorageSystem::Statistic::ClusterOpenCloseOperations is a utility class for IBM::StorageSystem cluster open and close
operation operations performance data.

An IBM::StorageSystem::Statistic::CLusterOpenCloseOperations object represents a collection of statistical 
measurements for file open and close operations across all nodes in the target cluster during a single interval 
period.  

The interval period is defined by the interval parameter passed on invocation to the specific parent class.

=head1 METHODS

=head3 start_time 

The start time of the interval over which the data was collected in the format 'YYYY-MM-DD HH:MM:SS UTC+HH'.

=head3 end_time 

The end time of the interval over which the data was collected in the format 'YYYY-MM-DD HH:MM:SS UTC+HH'.

=head3 open_operations

The number of file open operations across all nodes in the target cluster for the interval period.

=head3 close_operations

The number of file close operations across all nodes in the target cluster for the interval period.

=head1 AUTHOR

Luke Poskitt, C<< <ltp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ibm-v7000-statistic-clusteropencloseoperations at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=IBM-StorageSystem-Statistic::ClusterOpenCloseOperations>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc IBM::StorageSystem::Statistic::ClusterOpenCloseOperations

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=IBM-StorageSystem-Statistic-ClusterOpenCloseOperations>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/IBM-StorageSystem-Statistic-ClusterOpenCloseOperations>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/IBM-StorageSystem-Statistic-ClusterOpenCloseOperations>

=item * Search CPAN

L<http://search.cpan.org/dist/IBM-StorageSystem-Statistic-ClusterOpenCloseOperations/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Luke Poskitt.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
