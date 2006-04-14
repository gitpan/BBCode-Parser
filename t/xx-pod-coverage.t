#!/usr/bin/perl
# $Id: xx-pod-coverage.t 200 2006-04-14 12:26:48Z chronos $

use warnings;
use strict;
use Test::More;
use File::Spec;

plan skip_all => "Pod coverage is TODO";

eval { require Test::Pod::Coverage; Test::Pod::Coverage->import; };
plan skip_all => "Test::Pod::Coverage not installed" if $@;

all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::CountParents' });

# vim:set ft=perl:
