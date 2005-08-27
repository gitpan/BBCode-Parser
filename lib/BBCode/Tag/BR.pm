# $Id: BR.pm 91 2005-08-27 11:00:11Z chronos $
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
