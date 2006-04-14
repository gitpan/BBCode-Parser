# $Id: I.pm 200 2006-04-14 12:26:48Z chronos $
package BBCode::Tag::I;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use BBCode::Util qw(multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

sub BodyPermitted($):method {
	return 1;
}

sub toText($):method {
	return multilineText '/'.shift->bodyText().'/';
}

1;
