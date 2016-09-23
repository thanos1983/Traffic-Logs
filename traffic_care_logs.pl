#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

=trafficCareLogs Hash
my %trafficCareLogs = ("post_tx_src_ton" => undef,
		       "post_tx_src_npi" => undef,
		       "post_tx_src_addr" => undef,
		       "post_tx_dst_ton" => undef,
		       "post_tx_dst_npi" => undef,
		       "post_tx_dst_addr" => undef,
		       "post_tx_dst_ton" => undef,
		       "post_tx_dst_npi" => undef,
		       "post_tx_dst_addr" => undef,
		       "thread_id" => undef,
		       "message_id" => undef,
		       "," => undef,
		       "submission_time" => undef,
		       "delivery_time" => undef,
		       "retry_time" => undef,
		       "schedule_delivery_time" => undef,
		       "expiry_time" => undef,
		       "priority" => undef,
		       "esm_class" => undef,
		       "registered" => undef,
		       "," => undef,
		       "pid" => undef,
		       "data_coding" => undef,
		       "status" => undef,
		       "num_attempts" => undef,
		       "o_err_type" => undef,
		       "o_err_value" => undef,
		       "i_err_type" => undef,
		       "i_err_value" => undef,
		       "src_op_name" => undef,
		       "orig_locn" => undef,
		       "dst_op_name" => undef,
		       "following_node" => undef,
		       "traffic_care_cdr_type" => undef,
		       "," => undef,
		       "text_len" => undef,
		       "," => undef,
		       "smsc_map_addr" => undef,
		       "dst_op_name_visited" => undef,
		       "dst_imsi" => undef,
		       "dst_msc" => undef,
		       "routing_decision" => undef,
		       "route_name" => undef,
		       "fallback_routing" => undef,
		       "ext_message_id" => undef,
		       "rcpt_msg_state" => undef,
		       "rcpt_i_err_val" => undef,
		       "rcpt_o_err_val" => undef,
		       "," => undef,
		       "," => undef,
		       "EOL" => undef);
=cut

my @trafficCareLogs = ("post_tx_src_ton",
		       "post_tx_src_npi",
		       "post_tx_src_addr)",
		       "post_tx_dst_ton)",
		       "post_tx_dst_npi",
		       "post_tx_dst_addr",
		       "post_tx_dst_ton",
		       "post_tx_dst_npi",
		       "post_tx_dst_addr",
		       "thread_id",
		       "message_id",
		       ",",
		       "submission_time",
		       "delivery_time",
		       "retry_time",
		       "schedule_delivery_time",
		       "expiry_time",
		       "priority",
		       "esm_class",
		       "registered",
		       ",",
		       "pid",
		       "data_coding",
		       "status",
		       "num_attempts",
		       "o_err_type",
		       "o_err_value",
		       "i_err_type",
		       "i_err_value",
		       "src_op_name",
		       "orig_locn",
		       "dst_op_name",
		       "following_node",
		       "traffic_care_cdr_type",
		       ",",
		       "text_len",
		       ",",
		       "smsc_map_addr",
		       "dst_op_name_visited",
		       "dst_imsi",
		       "dst_msc",
		       "routing_decision",
		       "route_name",
		       "fallback_routing",
		       "ext_message_id",
		       "rcpt_msg_state",
		       "rcpt_i_err_val",
		       "rcpt_o_err_val",
		       ",",
		       ",",
		       "EOL");

my @AoH;
my %HoH;
my $lineNumber = 1;
my $logOutputFile = '/tmp/capturedLog.txt';

if (@ARGV > 1 or @ARGV < 1) {
    die "Please insert only one logfile to process \n";
}

my $fileHandleRead = openFileReadSub($ARGV[0]);
my @content = <$fileHandleRead>;
chomp @content;


foreach my $line (@content) {
    my %hash;
    my @values = split(',', $line);
    if ($values[18] eq '4'){
        my $fileHandleWrite = openFileWriteSub($logOutputFile);
	@hash{@trafficCareLogs} = @values;
	$HoH{'Line number: ' . $lineNumber++} = \%hash;
	# write to file
	print $fileHandleWrite localtime() . "\n";
	print $fileHandleWrite Dumper \%HoH;
	print $fileHandleWrite "\n";
	closeFileSub($fileHandleWrite);
	print Dumper \%HoH;
    }
}

closeFileSub($fileHandleRead);

#print Dumper \%HoH;
exit 0;

sub openFileReadSub {
    my ($filename) = shift;
    open(my $fh, '<', $filename)
	or die "Could not open file '$filename' $!";
    return $fh;
}

sub openFileWriteSub {
    my ($filename) = shift;
    open(my $fh, '>>:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
    return $fh;
}

sub closeFileSub {
    my ($filename) = shift;
    close $filename  # wait for sort to finish
	or die "Error closing '$filename' $!";
}
