#!/usr/bin/perl
use strict;
use warnings;
use Pod::Usage;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);

my @trafficCareLogs = ('src_ton',
		       'src_npi',
		       'src_addr',
		       'dst_ton',
		       'tx_dst_npi',
		       'dst_addr',
		       'dst_ton',
		       'dst_npi',
		       'dst_addr',
		       'thread_id',
		       'message_id',
		       ',',
		       'submission_time',
		       'delivery_time',
		       'retry_time',
		       'schedule_delivery_time',
		       'expiry_time',
		       'priority',
		       'esm_class',
		       'registered',
		       ',',
		       'pid',
		       'data_coding',
		       'status',
		       'num_attempts',
		       'o_err_type',
		       'o_err_value',
		       'i_err_type',
		       'i_err_value',
		       'src_op_name',
		       'orig_locn',
		       'dst_op_name',
		       'following_node',
		       'traffic_care_cdr_type',
		       ',',
		       'text_len',
		       ',',
		       'smsc_map_addr',
		       'dst_op_name_visited',
		       'dst_imsi',
		       'dst_msc',
		       'routing_decision',
		       'route_name',
		       'fallback_routing',
		       'text_message_id',
		       'rcpt_msg_state',
		       'rcpt_i_err_val',
		       'rcpt_o_err_val',
		       ',',
		       ',',
		       "EOL");

my $options = {
    'man'       => 0,
    'help'      => 0,
    'all'       => 0,
    'logfile'   => undef,
    'src_esme'  => undef,
    'dst_esme'  => undef,
    'thread_id' => undef,
    'src_addr'  => undef,
    'dst_addr'  => undef,
    'pdu_type'  => undef,
    'esm_class' => undef,
};

GetOptions(
    'file|f:s'      => \$$options{'logfile'},
    'src_esme|s:s'  => \$$options{'src_esme'},
    'dst_esme|d:s'  => \$$options{'dst_esme'},
    'thread_id|i:s' => \$$options{'thread_id'},
    'src_addr|t:s'  => \$$options{'src_addr'},
    'dst_addr|r:s'  => \$$options{'dst_addr'},
    'pdu_type|p:s'  => \$$options{'pdu_type'},
    'esm_class|c:s' => \$$options{'esm_class'},
    'all|a'         => \$$options{'all'},
    'help|h'        => \$$options{'help'},
    'man|m'         => \$$options{'man'},
    ) or pod2usage(2);

pod2usage(1) if $$options{'help'};
pod2usage(-exitval => 0, -verbose => 2) if $$options{'man'};

die "\nOption -file or -f not specified.\n\n"
    if (!defined $$options{'logfile'} || $$options{'logfile'} eq '');

die "\nUsage: $0 [options] [file ...]\n\n" unless @ARGV == 0;

open(my $fh, '<', $$options{'logfile'})
    or die "Could not open file ".$$options{'logfile'}." $!";

my @content = <$fh>;
chomp @content;

my $HoHRef = {};
my $SecondaryHoHRef = {};
my $lineNumber = 1;

foreach my $line (@content) {
    my $hashRef = {};
    next if $line =~ /^\s*$/; # If empty or white space next line
    my @values = split(',', $line); # Split all elements in line into an array
    s{^\s+|\s+$}{}g foreach @values; # Remove white space both sides
    @$hashRef{@trafficCareLogs} = @values; # Assign all elements to hash values

    if ((defined $$options{'src_esme'}) &&
	($options->{'src_esme'} eq $hashRef->{'src_esme'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
	print "in\n";
	exit 0;
    }
    elsif ((defined $$options{'dst_esme'}) &&
	   ($options->{'dst_esme'} eq $hashRef->{'dst_esme'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'thread_id'}) &&
	   ($options->{'thread_id'} eq $hashRef->{'thread_id'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'src_addr'}) &&
	   ($options->{'src_addr'} eq $hashRef->{'src_addr'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'dst_addr'}) &&
	   ($options->{'dst_addr'} eq $hashRef->{'dst_addr'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'pdu_type'}) &&
	   ($options->{'pdu_type'} eq $hashRef->{'pdu_type'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'esm_class'}) &&
	   ($options->{'esm_class'} eq $hashRef->{'esm_class'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    else {
	$SecondaryHoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
}

close $fh # wait for sort to finish
    or die "Error closing '$$options{'logfile'}' $!";

if (values %{$HoHRef}) {
    print Dumper $HoHRef;
}
elsif ($$options{'all'}) {
    print Dumper $SecondaryHoHRef;
    print "Second\n";
}
else {
    print "\nNo match Found at ".$$options{'logfile'}."\n\n";
}

__END__

=head1 NAME

traffic_care_log - process CDR log file and print the matched CDR(s) based on filtering parameters.

=head1 SYNOPSIS

traffic_care_log [OPTIONS]... [FILE]...

Options:
    --file or -f,
    --src_esme or -s,
    --dst_esme or -d,
    --thread_id or -i,
    --src_addr or -t,
    --dst_addr or -r,
    --pdu_type or -p,
    --esm_class or -c,
    --help or -h,
    --man or -m

=head1 DESCRIPTION

Process customer care log CDR(s) file to standard output.

With no filtering parameter defined the standard output will print all the CDR(s).

=over 8

=item B<-f, --file>
log file to be processed

=item B<-s, --src_esme>
diplay CDR(s) with matching source esme

=item B<-d, --dst_esme>
diplay CDR(s) with matching destination esme

=item B<-i, --thread_id>
diplay CDR(s) with matching thread id

=item B<-t, --src_addr>
diplay CDR(s) with matching source addr

=item B<-r, --dst_addr>
diplay CDR(s) with matching destination addr

=item B<-p, --pdu_type>
diplay CDR(s) with matching PDU type

=item B<-e, --esm_class>
diplay CDR(s) with matching esme class

=item B<-h, --help>
print a brief help message and exits.

=item B<-m, --man>
prints the manual page full documentation.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something
    useful with the contents thereof.

=head1 AUTHOR

Written by Athanasios Garyfalos.

=head1 REPORTING BUGS

Please report any bugs or feature requests to GARYFALOS at cpan.org. I will be notified, and I will try to make changes as soon as possible. I will update you with a reply as soon as the modifications will be applied.

=head1 COPYRIGHT

This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to  the  extent
       permitted by law.
=cut
