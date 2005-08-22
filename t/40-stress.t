#!/usr/bin/perl
# $Id: 10-inline.t 67 2005-05-08 14:11:41Z chronos $

use Test::More tests => 15;
use strict;
use warnings;
use lib 't';

BEGIN { require "common.ph"; }

BEGIN { use_ok 'BBCode::Parser'; }

our $p = BBCode::Parser->new;

bbfail q(Bogus argument[BR=10]);
bbfail q([B STYLE="display: none"]Bogus parameter[/B]);
bbfail q([SIZE=foo]Bogus size[/SIZE]);
bbfail q([COLOR=salmon]Bogus color[/COLOR]);
bbfail q([CODE LANG='<foo/>']Breakout attempt[/CODE]);
bbfail q([CODE][B]Bogus nesting[/B][/CODE]);
bbfail q([URL=javascript:void(0)]Javascript link[/URL]);
bbfail q([IMG=javascript:void(0)]Javascript image);
bbfail q([QUOTE CITE=javascript:void(0)]Javascript cite[/QUOTE]);
bbfail q([UL BULLET=javascript:void(0)][LI]Javascript list bullet[/LI][/UL]);

bbtest	q([FONT=Verdana\'\"><foo/>]Breakout attempt[/FONT]),
		q(<span style="font-family: 'Verdana&apos;&quot;&gt;&lt;foo/&gt;'">Breakout attempt</span>);

bbtest	q([LIST][*]One[*]Two),
		q([LIST][LI]One[/LI][LI]Two[/LI][/LIST]),
		qq(<ul>\n\t<li>One</li>\n\t<li>Two</li>\n</ul>);
# vim:set ft=perl:
