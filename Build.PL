#!/usr/bin/perl -w
# $Id: Build.PL 116 2006-01-10 16:41:53Z chronos $

use Module::Build;

my $build = Module::Build->new(
	module_name		=> 'BBCode::Parser',
	license			=> 'perl',
	dist_author		=> 'Donald King <dlking@cpan.org>',
	create_readme	=> 1,
	create_makefile_pl => 'passthrough',
#	requires		=> {
#		'perl'			=> '5.6.1',
#		'Some::Module'	=> '1.23',
#		'Other::Module'	=> '>= 1.2, != 1.5, < 2.0',
#	},
);

$build->create_build_script;
