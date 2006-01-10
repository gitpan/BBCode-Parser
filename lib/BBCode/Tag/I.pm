# $Id: I.pm 116 2006-01-10 16:41:53Z chronos $
package BBCode::Tag::I;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
