# $Id: SUB.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::SUB;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;

sub BodyPermitted($):method {
	return 1;
}

1;
