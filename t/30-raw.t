#!/usr/bin/perl
# $Id: 30-raw.t 112 2006-01-09 16:52:08Z chronos $

use Test::More tests => 4;
use strict;
use warnings;
use lib 't';

BEGIN { require "common.ph"; }

BEGIN { use_ok 'BBCode::Parser'; }

my $bbcode = '';

my $html = <<'EOF';
EOF

our $p = BBCode::Parser->new;

bbfail	q([HTML]&amp;<embed src="foo.swf" width="200" height="100" />[/HTML]);

$p->permit('HTML');

bbtest	q([HTML]&amp;<embed src="foo.swf" width="200" height="100" />[/HTML]),
		q(&amp;<embed src="foo.swf" width="200" height="100" />);

# vim:set ft=perl:
