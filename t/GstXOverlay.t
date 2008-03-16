#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 1;

# $Id: GstXOverlay.t,v 1.2 2008/01/19 16:33:36 kaffeetisch Exp $

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

