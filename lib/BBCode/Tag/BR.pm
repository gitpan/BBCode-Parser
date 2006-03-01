# $Id: BR.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::BR;
use base qw(BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.30';

sub Class($):method {
	return qw(TEXT INLINE);
}

sub toBBCode($):method {
	return "[BR]";
}

sub toHTML($):method {
	return "<br/>";
}

sub toText($):method {
	return "\n";
}

1;
