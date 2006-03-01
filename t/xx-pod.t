#!/usr/bin/perl
# $Id: xx-pod.t 186 2006-03-01 18:01:08Z chronos $

use warnings;
use strict;
use Test::More;

eval "use Test::Pod";
plan skip_all => "Test::Pod not installed" if $@;

my @dirs = qw(extra t);
if(-d 'blib') {
	push @dirs, 'blib';
} else {
	push @dirs, 'lib';
}
my @pods = all_pod_files(@dirs);
all_pod_files_ok(sort @pods);

# vim:set ft=perl:
