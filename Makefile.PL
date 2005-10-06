#!/usr/bin/perl
use 5.008;
use strict;
use warnings;

use ExtUtils::MakeMaker;
use Cwd qw(cwd);
use File::Spec;

# $Id: Makefile.PL,v 1.1 2005/09/28 16:10:47 kaffeetisch Exp $

our %build_reqs = (
  'perl-ExtUtils-Depends'   => '0.205',
  'perl-ExtUtils-PkgConfig' => '1.07',
  'perl-Glib'               => '1.100',
  'perl-GStreamer'          => '0.02',
  'GStreamerInterfaces'     => '0.8.0',
);

our %pre_reqs = (
  'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
  'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
  'Glib'                => $build_reqs{'perl-Glib'},
  'GStreamer'           => $build_reqs{'perl-GStreamer'},
);

unless (eval "use ExtUtils::Depends '$build_reqs{'perl-ExtUtils-Depends'}';"
           . "use ExtUtils::PkgConfig '$build_reqs{'perl-ExtUtils-PkgConfig'}';"
           . "use GStreamer '$build_reqs{'perl-GStreamer'}';"
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Glib::MakeHelper;"
           . "use Glib::CodeGen;"
           . "1") {
  warn "$@\n";
  WriteMakefile(
    PREREQ_FATAL => 1,
    PREREQ_PM    => \%pre_reqs,
  );
  exit 1; # not reached
}

my %pkgcfg = ExtUtils::PkgConfig->find("gstreamer-interfaces-0.8 >= $build_reqs{'GStreamerInterfaces'}");

mkdir 'build', 0777;

Glib::CodeGen->parse_maps('gstinterfacesperl');
Glib::CodeGen->write_boot(ignore => qr/^GStreamer::Interfaces$/);

my $gst = ExtUtils::Depends->new('GStreamer::Interfaces', 'GStreamer');
$gst->set_inc($pkgcfg{cflags});
$gst->set_libs($pkgcfg{libs});
$gst->add_xs(<xs/*.xs>);
$gst->add_pm('Interfaces.pm' => '$(INST_LIBDIR)/Interfaces.pm');
$gst->add_typemaps(map {File::Spec->catfile(cwd(), $_)} ('build/gstinterfacesperl.typemap'));

$gst->install(qw(gstinterfacesperl.h));
$gst->save_config('build/IFiles.pm');

WriteMakefile(
  NAME          => 'GStreamer::Interfaces',
  VERSION_FROM  => 'Interfaces.pm',
  ABSTRACT_FROM => 'Interfaces.pm',
  PREREQ_PM     => \%pre_reqs,
  XSPROTOARG    => '-noprototypes',
  $gst->get_makefile_vars,
);

sub MY::postamble {
  return Glib::MakeHelper->postamble_clean ()
       . Glib::MakeHelper->postamble_docs_full (
           DEPENDS => $gst,
           COPYRIGHT_FROM => 'copyright.pod');
}
