# $Id: Inline.pm 116 2006-01-10 16:41:53Z chronos $
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
