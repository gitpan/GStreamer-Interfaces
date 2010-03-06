#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 1;

# $Id$

use Glib qw(TRUE FALSE);
use GStreamer -init;
use GStreamer::Interfaces;

my $plugin = "xvimagesink";

my $element = GStreamer::ElementFactory -> make($plugin => "element");

SKIP: {
  skip 'make() returned undef', 1
    unless defined $element;

  isa_ok($element, "GStreamer::XOverlay");
  $element -> set_xwindow_id(0);
  $element -> expose();
  $element -> got_xwindow_id(0);
  $element -> prepare_xwindow_id();
}

