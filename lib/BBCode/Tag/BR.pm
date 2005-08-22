# $Id: BR.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::BR;
use base qw(BBCode::Tag);
use strict;
use warnings;

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
