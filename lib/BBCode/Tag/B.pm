# $Id: B.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::B;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use BBCode::Util qw(multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

sub BodyPermitted($):method {
	return 1;
}

sub toText($):method {
	return multilineText '*'.shift->bodyText().'*';
}

1;
