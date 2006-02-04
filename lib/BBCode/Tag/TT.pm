# $Id: TT.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::TT;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
