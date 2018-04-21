#!/usr/bin/perl
use strict;
use warnings;

sub get_file
{
    my $f = shift;
    my $text = "";
    open(OUT, $f) or die "File nod read";
    while(<OUT>) {
        $text .= $_ . "";
    }
    close(OUT);
    return $text;
}

sub print_out
{
    my $out = shift;
    my $text = shift;

    if (!defined $out) { # $out is undef
        print STDOUT $text;
        return;
    }

    open(my $fh, '>', $out) or die "File nod read";
    print $fh $text;
    close ($fh);
}

sub fix_port
{
    my $ports = shift;
    my $arg1 = shift;
    my $arg3 = shift;

    $ports =~ s/(\d+):(\d+)/$2/eig;

    return "${arg1}ports:${ports}${arg3}";
}

sub parse_ports
{
    my $text = shift;
    $text =~ s/(\n +)ports:([\s\S]+?)(\n +[a-z]|\n*$)/fix_port($2, $1, $3)/eig;
    return $text;
}
# --------------

my $desc = undef;
if (@ARGV) {
    my $i = $ARGV[0];

    if ($i =~ /-i/) {
        $i = shift @ARGV;
        $desc = $ARGV[0];
    } elsif ($i =~ /-o/) {
        $i = shift @ARGV;
        $desc = shift @ARGV;
    }
}

my ($filename) = @ARGV;

if (!defined $filename) {
    print "Error <filename>\n";
    print "Usage:
    $0 [-i|-o <DESC>] <FILENAME>\n";
    exit(1);
}

my $text = get_file($filename);
$text = parse_ports($text);

print_out($desc, $text);
