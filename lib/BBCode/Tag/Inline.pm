# $Id: Inline.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::Inline;
use base qw(BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.01';

sub Class($):method {
	return qw(INLINE);
}

sub BodyTags($):method {
	return qw(:INLINE);
}

1;
