# $Id: BR.pm 116 2006-01-10 16:41:53Z chronos $
package BBCode::Tag::BR;
use base qw(BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.01';

sub Class($):method {
	return qw(TEXT INLINE);
}

sub toBBCode($):method {
	return "[BR]";
}

sub toHTML($):method {
	return "<br/>";
}

1;
