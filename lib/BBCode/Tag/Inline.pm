# $Id: Inline.pm 90 2005-08-27 10:58:31Z chronos $
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
