#!/usr/bin/perl
use strict;
use warnings;

# my $filename = "";
# my $start_port = 0;

my ($filename, $start_port) = @ARGV;

my $filenameDesc = $filename;

if (!defined $start_port) {
    $start_port = 20080;
    print "defined start_port: $start_port\n";
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
    open(my $fh, '>', $filenameDesc) or die "File nod read";
    print $fh $string;
    close ($fh);
}

# print "start_port: $start_port\n";

main();
