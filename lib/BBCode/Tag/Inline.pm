# $Id: Inline.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::Inline;
use base qw(BBCode::Tag);
use strict;
use warnings;

sub Class($):method {
	return qw(INLINE);
}

sub BodyTags($):method {
	return qw(:INLINE);
}

1;
