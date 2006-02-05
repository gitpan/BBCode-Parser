# $Id: I.pm 161 2006-02-05 17:31:00Z chronos $
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
