# $Id: B.pm 90 2005-08-27 10:58:31Z chronos $
package BBCode::Tag::B;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
