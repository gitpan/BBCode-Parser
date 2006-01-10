# $Id: B.pm 112 2006-01-09 16:52:08Z chronos $
package BBCode::Tag::B;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
