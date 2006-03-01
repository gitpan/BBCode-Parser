# $Id: TT.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::TT;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
