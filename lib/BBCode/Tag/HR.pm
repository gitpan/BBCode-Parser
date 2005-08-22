# $Id: HR.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::HR;
use base qw(BBCode::Tag::Block);
use strict;
use warnings;

sub toBBCode($):method {
	return "[HR]";
}

sub toHTML($):method {
	return "<hr/>";
}

1;
