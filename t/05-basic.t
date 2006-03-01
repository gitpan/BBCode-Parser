#!/usr/bin/perl
# $Id: 05-basic.t 186 2006-03-01 18:01:08Z chronos $

use Test::More tests => 5;
use strict;
use warnings;

BEGIN { use_ok 'BBCode::Parser'; }

our $p = BBCode::Parser->new;
isa_ok($p, 'BBCode::Parser');

my $foo = $p->parse("Foo");
isa_ok($foo, 'BBCode::Tag');
is($foo->body->[0]->Tag, 'TEXT', 'TEXT Tag sanity check (type)');
ok($foo->body->[0]->BodyPermitted == 0, 'TEXT Tag sanity check (body?)');

# vim:set ft=perl:
