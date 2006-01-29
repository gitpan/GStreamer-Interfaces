#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 9;

# $Id: GstPropertyProbe.t,v 1.2 2006/01/24 19:53:42 kaffeetisch Exp $

use Glib qw(TRUE FALSE);
use GStreamer -init;
use GStreamer::Interfaces;

my $plugin = "alsamixer";
my $property = "device";

my $element = GStreamer::ElementFactory -> make($plugin => "element");
isa_ok($element, "GStreamer::PropertyProbe");

my @pspecs = $element -> get_probe_properties();
isa_ok($pspecs[0], "Glib::ParamSpec");

my $pspec = $element -> get_probe_property("device");
isa_ok($pspec, "Glib::ParamSpec");

is($element -> needs_probe($pspec), TRUE);
$element -> probe_property($pspec);

ok($element -> get_probe_values($pspec));
ok($element -> probe_and_get_probe_values($pspec));

ok(!$element -> needs_probe_name($property));
$element -> probe_property_name($property);

ok($element -> get_probe_values_name($property));
ok($element -> probe_and_get_probe_values_name($property));
