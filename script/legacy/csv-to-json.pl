#!perl

use strict;
use warnings;
use JSON;
use Text::CSV;
#use Data::Dumper;

open(INFILE, '<', "translinkdata.txt");

my $csv = Text::CSV->new({ sep_char => "\t" });

my @list;
my $line_no = 0;
while (<INFILE>) {
    next if $line_no++ == 0;
    if ( ! $csv->parse($_)) {
       die "bad line [$_]";
    }
    my %row;
    @row{qw(Latitude Longitude Easting Northing
            IG_Code Stop_Name Street Service Direction
            MetroService)} = $csv->fields();

    push(@list, \%row);
}

close(INFILE);

print to_json(\@list, {utf8 => 1, pretty => 1});