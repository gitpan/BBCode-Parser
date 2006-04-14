# $Id: TT.pm 200 2006-04-14 12:26:48Z chronos $
package BBCode::Tag::TT;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
