# $Id: SUB.pm 161 2006-02-05 17:31:00Z chronos $
package BBCode::Tag::SUB;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
