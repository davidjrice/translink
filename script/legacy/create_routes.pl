#!/usr/bin/perl

use Geography::NationalGrid;
use Geography::NationalGrid::IE;
use Geo::HelmertTransform;
#use Data::Dumper;
use JSON;

my $airy1830M = Geo::HelmertTransform::datum('Airy1830Modified');
my $wgs84 = Geo::HelmertTransform::datum('WGS84');

my @MetroServices = ('10A', '10B', '10C', '10D', '10E', '10F', '10G', '10H', '11', '11A', '11B', '11C', '11D', '12', '12A', '12B', '12C', '13', '13A', '13B', '13C', '14', '14A', '14B', '14C', '17', '18', '19', '19A', '1A', '1B', '1C', '1D', '1E', '1G', '1H', '20', '20A', '214', '23', '23B', '26', '26a', '27', '28', '29', '29A', '2A', '2B', '2C', '2D', '2E', '2F', '30', '30A', '31', '3A', '4A', '4B', '57', '57A', '5A', '5B', '6', '600', '600 Airlink', '61', '64', '64A', '64a', '64b', '6A', '77', '78', '79', '7A', '7B', '7C', '7D', '80', '80A', '81', '81A', '82', '82A', '89', '8A', '8B', '8C', '9', '90', '91', '92', '92A', '92B', '93', '94', '94C', '95', '96', '9A', '9B', '9C', 'EB1', 'EB2', 'EB3', 'EB4', 'EB5', 'EB6', 'NL1', 'NL2', 'NL3', 'NL4', 'NL5', 'NL6', 'NL7', 'NL9');
my %HoA;
foreach (@MetroServices) {
  my $service = uc($_);
  open (FILE, './translinkdata.txt');
  my @AoH;
  while (<FILE>) {
    chomp;
    my @cols = split(/\t/);
    my $services = "uc($cols[9])";
    my $easting = "$cols[2]";
    my $northing = "$cols[3]";
    my $stopname = "$cols[6]";
    my $street = "$cols[7]";
    my $direction = "$cols[8]";
    next unless $services =~ m/\W$service\W/;
    my $point = new Geography::NationalGrid::IE(
      Easting =>  $easting,
      Northing => $northing
    );
    my $h = 0;
    my $lat = $point->latitude;
    my $lon = $point->longitude;
    ($lat, $lon, $h) = Geo::HelmertTransform::convert_datum($airy1830M, $wgs84, $lat, $lon, $h);
    push @AoH, { 'stopname' => $stopname, 'street' => $street,'direction' => $direction,  'lat' => $lat, 'lon' => $lon};
  }
#  @AoH = sort { $a->{igcode} <=> $b->{igcode} } @AoH;
  $HoA{"route_$service"} = [ @AoH ];
  close (FILE);
}
my $json_text = to_json(\%HoA, {utf8 => 1, pretty => 1});
print "var myTranslink = ";
print $json_text;
