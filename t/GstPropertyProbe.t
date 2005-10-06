#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 8;

# $Id: GstPropertyProbe.t,v 1.1 2005/09/28 16:10:48 kaffeetisch Exp $

use Glib qw(TRUE FALSE);
use GStreamer -init;
use GStreamer::Interfaces;

my $plugin = "osssink";
my $property = "device";

my $element = GStreamer::ElementFactory -> make($plugin => "element");

my @pspecs = $element -> get_probe_properties();
isa_ok($pspecs[0], "Glib::ParamSpec");

my $pspec = $element -> get_probe_property("device");
isa_ok($pspec, "Glib::ParamSpec");

is($element -> needs_probe($pspec), TRUE);
$element -> probe_property($pspec);

ok($element -> get_probe_values($pspec));
ok($element -> probe_and_get_probe_values($pspec));

SKIP: {
  skip "the name stuff", 3
    unless (0);

  is($element -> needs_probe_name($property), TRUE);
  $element -> probe_property_name($property);

  ok($element -> get_probe_values_name($property));
  ok($element -> probe_and_get_probe_values_name($property));
}
