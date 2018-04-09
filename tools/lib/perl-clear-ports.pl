#!/usr/bin/perl
use strict;
use warnings;

# my $filename = "";
# my $start_port = 0;

my $update_file = 0;

# edit files in place
my $args = @ARGV;
if ($args > 0) {
    my $i = $ARGV[0];

    if ($i =~ /-i/) {
        $i = shift @ARGV;
        $update_file = 1;
    }
}


# print $update_file;
# exit 1;

my ($filename, $start_port) = @ARGV;


if (!defined $filename) {
    print "Error <filename>\n";
    print "Usage:
    $0 <FILENAME> [START_PORT]\n";
    exit(1);
}

my $filenameDesc = $filename;

if (!defined $start_port) {
    $start_port = 20080;
    # print "defined start_port: $start_port\n";
}

$start_port = $start_port + 0;
$filenameDesc =~ s/\.yml$/.override.yml/;

sub fix_port_inc
{
    my $port = $start_port;
    my $port_guest = shift;
    $start_port = $start_port + 1;
    return "$port:$port_guest";
}

sub fix_port
{
    my $arg = shift;
    my $arg1 = shift;
    my $arg3 = shift;

    if ($start_port == 0) {
        return "${arg3}";
    }

    my $ports = $arg;
    $ports =~ s/(\d+):(\d+)/fix_port_inc($2)/eig;

    return "${arg1}ports:${ports}${arg3}";
}


sub parse_file
{
    my $string = "";
    open(OUT, $filename) or die "File nod read";
    while(<OUT>) {
        $string .= $_ . "";
    }
    close(OUT);

    $string =~ s/(\n +)ports:([\s\S]+?)(\n +[a-z]|\n*$)/fix_port($2, $1, $3)/eig;

    return $string;
}

sub main
{
    my $string = parse_file();

    if ($update_file == 1) {
        open(my $fh, '>', $filenameDesc) or die "File nod read";
        print $fh $string;
        close ($fh);
    } else {
        print $string;
    }
}

# print "start_port: $start_port\n";

main();
