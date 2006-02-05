#!/usr/bin/perl -w
# $Id: Build.PL 161 2006-02-05 17:31:00Z chronos $

use Module::Build;

my $build = Module::Build->new(
	module_name		=> 'BBCode::Parser',
	license			=> 'perl',
	dist_author		=> 'Donald King <dlking@cpan.org>',
	create_readme	=> 1,
	create_makefile_pl => 'passthrough',
	sign			=> 1,
	requires		=> {
		'perl'				=> '5.6.1',	# Possibly 5.8, need to test more
		'Carp'				=> 0,
		'HTML::Entities'	=> 0,
		'URI'				=> 0,
	},
);

$build->create_build_script;
